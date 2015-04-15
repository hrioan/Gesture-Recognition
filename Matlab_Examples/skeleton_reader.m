%% Skeleton Frames Reader

diary on;
clear; clc;
imtool close all;  % Close all imtool figures.
disp('Skeleton Reader in Matlab');
pause;
clc;

%% CONSTANTS
% bounding box 
BBOX = 60;
% the vector shows us the start of each gesture in the current video --->
% would be extracted from Matlab Viewer later 
start_gestures = [1 80 120 160 200 240 280 360 400 480 520 560 620 680 740 780 840 920 980 1060 ];

% numbers of frames to be extracted and used in training
nfrm = 20;

P = zeros(20,3,nfrm);

f1 = figure('Name','Skeleton Frame','NumberTitle','off');

%% 1: Extract skeletal information

startFr = start_gestures(16); 
endFr = start_gestures(17);
z = 0;                              % frames passed to matrix

for i = startFr:endFr
    
    iptstr = sprintf('./Sample00003_Export/Sample00003_%d.mat',i);
    S = load(iptstr);                               % load specific Frame
    
    % 1.a Bypass frames with no Skeletal information
    if (~nnz(S.Frame.Skeleton.PixelPosition))
        fprintf('Skeleton joints not present for frame: %d',i);
        nfrm = nfrm + 1;
        continue;
    end
    
    % 1.b SkeletonViewer --> Visualize Skeleton information
    clf(f1);
    subplot(2,2,1:2);
    skeletonViewer(S.Frame.Skeleton.WorldPosition, false, i, S.Frame.Skeleton.JointType, 'Original' );
    
    % 1.c Normalization
    % eucleidian distance between Shoulder Center and HipCenter
    edist = norm(S.Frame.Skeleton.WorldPosition(1,:) - S.Frame.Skeleton.WorldPosition(3,:));
    
    % normalize each joint in regard to the above distance and substract to
    % make Hip Center the origin of the coordinate system
    sjoint = zeros(20, 3);
    for j = 1:20
        sjoint(j,:) = (S.Frame.Skeleton.WorldPosition(j,:) / edist) - (S.Frame.Skeleton.WorldPosition(1,:) / edist) ;
    end
    
    subplot(2,2,3:4);
    skeletonViewer(sjoint, false, i, S.Frame.Skeleton.JointType,'Normalized');
    
   
    % Keep data to P matrix 
    z = z + 1;
    if (z > nfrm)
        fprintf('Gathered the nesessary frames for computation');
        break;
    end
    P(:,:,z) = sjoint(:,:);
    
    refreshdata;
    drawnow;
    
    clearvars -except keepVariables i BBOX f1 nfrm start_gestures P startFr endFr z
    clear functions
    
end