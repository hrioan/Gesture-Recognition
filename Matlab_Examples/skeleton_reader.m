%% Skeleton Frames Reader

diary on;
clear; clc;
imtool close all;  % Close all imtool figures.
disp('Skeleton Reader in Matlab');
pause;
clc;

%% CONSTANTS
BBOX = 60;
start_gestures = [1 80 120 160 200 240 280 360 400 480 520 560 620 680 740 780 840 920 980 1060 ];

%% 1: Extract skeletal information
for i = start_gestures(17):1117
    
    iptstr = sprintf('./Sample00003_Export/Sample00003_%d.mat',i);
    S = load(iptstr);
    
    % 1.a Bypass frames with no Skeletal information
    if (~nnz(S.Frame.Skeleton.PixelPosition))
        fprintf('Skeleton joints not present for frame: %d',i);
        continue;
    end
    
    % 1.b SkeletonViewer --> Visualize Skeleton information
    skeletonViewer(S.Frame.Skeleton, false, i);
    
    % 1.c Normalization
    
    
    
    clearvars -except keepVariables BBOX f1
    clear functions
    
end