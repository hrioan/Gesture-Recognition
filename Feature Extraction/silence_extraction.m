%% Train silence Models

% path to feature info matrices
path = '/media/scaler13/TOSHIBA EXT/Chalearn_datasets/MatlabViewer/Feature Extraction/feature_matrices';

% Samples to be used 
noSamples = [1 3:47 49:199 200:222 250:330 332:348 351:347 351:381 383:386 389:397 401 402 ];                   % A. Training data

%noSamples = [ 653:689 ];

% Open File to dump all silence coefficients
fname = sprintf('Coeffs_in_text/SilenceSamples.txt');
fileID = fopen(fname,'w');

% ----------------------------------------------------------------------- %
%% ------------------- Silence Extraction Phase -------------------------
iter = 0;  
for i = 1:length(noSamples)
    
    % load each specific file
    feature_path = sprintf('%s/Sample%05d.mat', path, noSamples(i));
    L = load(feature_path);
    
    fprintf('Processing file: Sample%05d.mat\n', noSamples(i));
    
    % > base name
    base_name = L.handles.filenameBase;
    
    % > path to frames folder
    frames_fold_path = L.handles.path;
    
    % > number of total frames in Folder
    nframes = L.Video.NumFrames;
    
    % > number of total gestures
    ngest = length(L.Video.Labels);
                                                                            % - Silence Training -                                     
    for j = 2:ngest                                                         %   start from 2nd gesture in sequence and extract the frames between the end of the i-1th
                                                                            %   gesture and the beginning of the i th gesture
        startges = L.Video.Labels(j-1).End;         
        endges = L.Video.Labels(j).Begin;
        
        if (endges - startges > 1)
            
            fprintf(fileID,'Sil%05d [ \n',iter);

            % Create some files to help Kaldi categorize the data 
            fname_2 = sprintf('Coeffs_in_text/Sil%05d.txt',iter);
            fileID_2 = fopen(fname_2,'w');
            fprintf(fileID_2,'Whatever');
            fclose(fileID_2);
            
            % extract to mat files as well
            mname = sprintf('Coeffs_in_mat/Sil%05d.mat',iter);
            mfile = matfile(mname,'Writable',true);
            mfile.class = 22;
            
            fprintf('Processing Silence %d \n',iter);
            
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
            
            iter = iter + 1;
        end
    end 
end