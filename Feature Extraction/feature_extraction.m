%% Feature Extraction of gesture sequences

% path to feature info matrices
path = '/media/scaler13/TOSHIBA EXT/Chalearn_datasets/MatlabViewer/Feature Extraction/feature_matrices';

% sample #2 does not exist in training1 folder
%noSamples = [1 3:47 49:199 200:222 250:330 332:348 351:347];       % >>> TO BE SET IN EVERY FEATURE EXTRACTION -- here training data taken <<<
noSamples = [351:381 383:386 389:397 401 402];                      % Test data
%%noSamples = [ 410:418 420:509];      % Testing Data 
%%noSamples = [200:215];


% Initialize Gesture ids field
gesIds = gestureIds();

% Open File to dump all coefficients
fname = sprintf('Coeffs_in_text/AllSamples.txt');
fileID = fopen(fname,'w');

%% FEATURE EXTRACTION PHASE
for i = 1:length(noSamples)
    
    % load each specific file
    feature_path = sprintf('%s/Sample%05d.mat', path, noSamples(i));
    L = load(feature_path);
    
    fprintf('Processing file: Sample%05d.mat', noSamples(i));
    
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
    
    % for each gesture call to get its Pose Descriptor 
    for j = 1:ngest
               
        fprintf(fileID,'ISample%05d_Features_%02d [ \n',noSamples(i), seqGes(j));
        
        %BLANK FILES
        fname_2 = sprintf('Coeffs_in_text/ISample%05d_Features_%02d.txt',noSamples(i), seqGes(j));
        fileID_2 = fopen(fname_2,'w');
        fprintf(fileID_2,'Whatever');
        fclose(fileID_2);
        %BLANK FILES
        
        %---------------------------------------------------------------
        
        fprintf('Processing Gesture: %s',L.Video.Labels(j).Name);
        startges = L.Video.Labels(j).Begin;
        endges = L.Video.Labels(j).End;
        
        PD = skeleton_reader(frames_fold_path, base_name, startges, endges);
        
        %fprintf('\t\t > Pose Descriptor:');
        %PD';
        
        % Write every Pose Descriptor to a file (according to prototype)
        for i3 = 1:length(PD)
            fprintf(fileID,'%f ',PD(i3));
            if mod(i3, 33) == 0                                                  %% 9 htane PALIA !!!
                fprintf(fileID,'\n ');
            end
        end
        
        fprintf(fileID,']\n ');
    
    end
    
    disp('------ Completed --------');
    %clearvars -except PD i j nframes ngest sFreq base_name frames_fold_path
end
 fclose(fileID);
