%% Feature Extraction of gesture sequences

% path to feature info matrices
path = '/media/scaler13/TOSHIBA EXT/Chalearn_datasets/MatlabViewer/Feature Extraction/feature_matrices';

% sample #2 does not exist in training1 folder
noSamples = [1 3:27];       % >>> TO BE SET IN EVERY FEATURE EXTRACTION <<<

% Initialize Gesture ids field
gesIds = gestureIds();

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
    
    % > Open the file where we' ll put the extracted pose descriptors 
    fname = sprintf('Sample%05d_Features.txt', noSamples(i));
    fileID = fopen(fname,'w');
    
    % > write as header the sequence of extracted gestures (in %d_%d.. form)
    seqGes = gestSeq(L.Video.Labels, ngest, gesIds);
    seqGes = seqGes(2:length(seqGes));
    fprintf(fileID,'%s [',seqGes);
    
    % for each gesture call to get its Pose Descriptor 
    for j = 1:ngest
        
        fprintf('Processing Gesture: %s',L.Video.Labels(j).Name);
        startges = L.Video.Labels(j).Begin;
        endges = L.Video.Labels(j).End;
        
        PD = skeleton_reader(frames_fold_path, base_name, startges, endges);
        
        %fprintf('\t\t > Pose Descriptor:');
        %PD';
        
        % Write every Pose Descriptor to a file (according to prototype)
        fprintf(fileID,' [ ');
        for i3 = 1:length(PD)
            fprintf(fileID,'%f ',PD(i3));
        end
        fprintf(fileID,']\n ');
    end
    
    fprintf(fileID,' ] ');
    fclose(fileID);
    
    disp('------ Completed --------');
    %clearvars -except PD i j nframes ngest sFreq base_name frames_fold_path
end
