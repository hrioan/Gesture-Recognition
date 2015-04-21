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

% for each joint there will be a struct with the following data
P = struct('JointType','Hipcenter','TimeMtx', zeros(3,nfrm));

f1 = figure('Name','Skeleton Frame','NumberTitle','off');

%% 1: Extract skeletal information

startFr = start_gestures(16); 
endFr = start_gestures(17);
z = 0;                              % frames passed to matrix

for i = startFr:endFr
    
    iptstr = sprintf('./Sample00003_Export/Sample00003_%d.mat',i);
    S = load(iptstr);                               % load specific Frame
    
    %% 1.a Bypass frames with no Skeletal information
    if (~nnz(S.Frame.Skeleton.PixelPosition))
        fprintf('Skeleton joints not present for frame: %d',i);
        nfrm = nfrm + 1;
        continue;
    end
    
    %% 1.b SkeletonViewer --> Visualize Skeleton information
    clf(f1);
    subplot(2,2,1:2);
    skeletonViewer(S.Frame.Skeleton.WorldPosition, false, i, S.Frame.Skeleton.JointType, 'Original' );
    
    %% 1.c Normalization
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
    
    %% 1.d Keep data to P matrix 
    z = z + 1;
    if (z > nfrm)
        fprintf('Gathered the nesessary frames for computation');
        break;
    end
    
    for j= 1:20
        P(j).JointType = S.Frame.Skeleton.JointType(j);
        P(j).TimeMtx(:,z) = sjoint(j,:)';
    end
    
    refreshdata;
    drawnow;
    
    clearvars -except keepVariables i BBOX f1 nfrm start_gestures P startFr endFr z S
    clear functions
    
end

fprintf('\n-- Step 1 Complete -- Continue?');
%pause;

%% 2. Apply Vector Median Filtering

% initial window w = 3
for i = 1:20
    P(i).TimeMtx = medfilt2(P(i).TimeMtx,[1,3]);
end

fprintf('\n-- Step 2 Complete -- Continue?');
%pause;

%% 3. Angle Based Pose Descriptor

%% a. Principal Component Analysis on 6 torso joints
%       it is used to form a new body plane x,y,z

torsoJnt = zeros(3,6);                                                      % Only  the torso Joints for PCA algorithm 
sjoint = zeros(20, 3);                                                      % copy of skeleton Joints for individual frame.

f2 = figure('Name','After PCA Frame','NumberTitle','off');

% For each extracted frame...                                               ('Here z total extracted frames')
for i = 1:(z-1)
    
    % a.1 keep copy of all skeleton joints
    for j = 1:20
        sjoint(j,:) = P(j).TimeMtx(:,i)';
    end
    
    % a.2 isolate the torso Joint coordinates ,ie. Shoulder center,right,left
    %     ,Hip Center,right,left
    torsoJnt(:,1) = sjoint(3,:)';        %P(3).TimeMtx(:,i)
    torsoJnt(:,2) = sjoint(9,:)';        %P(9).TimeMtx(:,i)
    torsoJnt(:,3) = sjoint(5,:)';        %P(5).TimeMtx(:,i)
    torsoJnt(:,4) = sjoint(1,:)';        %P(1).TimeMtx(:,i)
    torsoJnt(:,5) = sjoint(17,:)';       %P(17).TimeMtx(:,i)
    torsoJnt(:,6) = sjoint(13,:)';       %P(13).TimeMtx(:,i)
    
    %% PCA analysis
    % Computes the principal components of the matrix. Basically we want to
    % align the skeleton data to the elleiptic plane that the 'static' 
    % torso joints form.  
    coeffs = princomp(torsoJnt');
   
    % 2-d projection of the ellipse.
    % projJnt = ([coeffs(:,2), coeffs(:,1)]' * torsoJnt)';
    % figure(3);
    % plot(projJnt(:,1),projJnt(:,2),'b+');
    % hold on;

    
    % 3d projection of the ellipse
    projJnt = (coeffs(:,:)' * sjoint')';                                    % prjJnt Joints after PCA projection
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    tmp = projJnt(:,1);
    projJnt(:,1) = projJnt(:,2);
    projJnt(:,2) = tmp;
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

    clf(f2);
    skeletonViewer(projJnt, false, i, S.Frame.Skeleton.JointType,'After PCA');
    
    
    %% b. Angle Calculation
    
    % The matrix represents the sets of joints that compose each of the 9
    % requested angles
    joint_sets = [ 12 10 9; 10 9 3; 9 3 5; 3 5 6; 5 6 8; 1 3 4; 12 1 3; 8 1 3; 12 1 8 ];
    
    %% b.1 angle vector a
    a = zeros(9,1);
    
    % Calculate angles
    for iter = 1:length(joint_sets)

        % ...for now we are focusing on the x,y 2-d space
        a(iter) = angleCalc(projJnt(joint_sets(iter,1),1:2), projJnt(joint_sets(iter,2),1:2), projJnt(joint_sets(iter,3),1:2) )
        
    end
    
    % Rule: 1 ? ... angles 1,2,3,4,5 must be less than 180 degrees
    for i2= 1:5
        if a(i2) > 180.00
           a(i2) = 360 - a(i2); 
        end
    end
    
    
end





