%% Feature Extraction of gesture sequences

% path to feature info matrices
path = '/media/scaler13/TOSHIBA EXT/Chalearn_datasets/MatlabViewer/Feature Extraction/feature_matrices';

% Samples to be extracted
%noSamples = [1 3:47 49:199 200:222 250:330 332:348 351:347 351:381 383:386 389:397 401 402 ];              % A. Training data
%noSamples = [351:381 383:386 389:397 401 402];                             % B. Test data (to be used in Isolated testing)
%noSamples = [ 410:418 420:509 510 516:539 541:550 552:620 ];                                          % C. Test Data (to be used in embedded training) 
%%noSamples = [200:215];510 516:539 541:550 552:610

noSamples = [ 653:689 ];

% flag : 0 for isolated data sequences (A,B)
%        1 returns entire sequences (A,B,C) 
flag = 0;

% T for training , I for testing 
f2 = 'I';

% Initialize Gesture ids field
gesIds = gestureIds();

% Open File to dump all coefficients
fname = sprintf('Coeffs_in_text/AllSamples.txt');
fileID = fopen(fname,'w');
% ----------------------------------------------------------------------- %
%% ------------------- Feature Extraction Phase -------------------------
for i = 1:length(noSamples)
    
    % load each specific file
    feature_path = sprintf('%s/Sample%05d.mat', path, noSamples(i));
    L = load(feature_path);
    
    fprintf('Processing file: Sample%05d.mat\n', noSamples(i));
    
    % > path to frames folder
    frames_fold_path = L.handles.path;
    
    % > base name
    base_name = L.handles.filenameBase;
    
    % > Sampling_freq 
    sFreq = L.handles.fs;
    
    % > number of total frames in Folder
    nframes = L.Video.NumFrames;
    
    % > number of total gestures
    ngest = length(L.Video.Labels);
    
    %------------------------------------------------------------------
    % > write as header the sequence of extracted gestures (in %d_%d.. form)
    % A. Open the file where we' ll put the extracted pose descriptors 
    seqGes = gestSeq(L.Video.Labels, ngest, gesIds);
    %------------------------------------------------------------------
    
    if flag == 0
        % for each gesture call to get its Pose Descriptor 
        for j = 1:ngest

            fprintf(fileID,'%sSample%05d_Features_%02d [ \n',f2,noSamples(i), seqGes(j));

            % Create some files to help Kaldi categorize the data 
            fname_2 = sprintf('Coeffs_in_text/%sSample%05d_Features_%02d.txt',f2,noSamples(i), seqGes(j));
            fileID_2 = fopen(fname_2,'w');
            fprintf(fileID_2,'Whatever');
            fclose(fileID_2);
            
            % extract to mat files as well
            mname = sprintf('Coeffs_in_mat/%sSample%05d_Features_%02d.mat',f2,noSamples(i), seqGes(j));
            mfile = matfile(mname,'Writable',true);
            mfile.class = seqGes(j);
            
            fprintf('Processing Gesture: %s \n',L.Video.Labels(j).Name);
            startges = L.Video.Labels(j).Begin;
            endges = L.Video.Labels(j).End;

            PD = skeleton_reader(frames_fold_path, base_name, startges, endges);

            % write to mat
            mfile.cmtx = reshape(PD,88,length(PD)/88)';
            
            % Write every Pose Descriptor to a file (according to prototype)
            for i3 = 1:length(PD)
                fprintf(fileID,'%f ',PD(i3));
                if mod(i3, 88) == 0                                                  %% 9 htane PALIA !!! 33 kai pleon 88 
                    fprintf(fileID,'\n ');
                end
            end
            fprintf(fileID,']\n ');
        end
    
    elseif flag == 1
       
        %extract flags (if any)
        s = '_';
        if ngest == 0
            s = 'ZZ';
        else
            for j = 1:ngest
                s = sprintf('%s_%02d',s, seqGes(j));
            end 
        end
        
        % extract sequences of gestures
        fprintf(fileID,'%sSample%05d_%s [ \n', f2, noSamples(i),s);

        % Create some files to help Kaldi categorize the data 
        fname_2 = sprintf('Coeffs_in_text/%sSample%05d_%s.txt', f2, noSamples(i),s);
        fileID_2 = fopen(fname_2,'w');
        fclose(fileID_2);
        
        % extract to mat files as well
        mname = sprintf('Coeffs_in_mat/%sSample%05d_%s.mat', f2, noSamples(i),s);
        mfile = matfile(mname,'Writable',true);
        mfile.class = 21;
        
        fprintf('Processing Gesture from file: Sample%05d \n', noSamples(i));
        startges = 1;
        endges = L.Video.NumFrames;

        PD = skeleton_reader(frames_fold_path, base_name, startges, endges);
        
        % write to mat
        mfile.cmtx = reshape(PD,88,length(PD)/88)';
        
        % Write every Pose Descriptor to a file (according to prototype)
        for i3 = 1:length(PD)
            fprintf(fileID,'%f ',PD(i3));
            if mod(i3, 88) == 0                                                  %% 9 htane PALIA !!!
                fprintf(fileID,'\n ');
            end
        end
        fprintf(fileID,']\n ');
    end
    
    
    disp('------ Completed --------');
    %clearvars -except PD i j nframes ngest sFreq base_name frames_fold_path
end
 fclose(fileID);
