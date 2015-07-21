function  PD  = skeleton_reader( frames_fold_path, base_name ,startges, endges)
% Skeleton_Reader Extracts the pose descriptor for one specific gesture seq
%   

%% General Variables
% Numbers of frames to be extracted and used in training
nfrm = endges - startges;

% For each joint there will be a struct with the following data
P = struct('JointType','Hipcenter','TimeMtx', zeros(3,nfrm));

%f1 = figure('Name','Skeleton Frame','NumberTitle','off');

%% 1: Extract skeletal information
startFr = startges; 
endFr = endges;
z = 0;                                        % #no frames passed to matrix

for i = startFr:endFr
    
    iptstr = sprintf('%s%s_Export/%s_%d.mat',frames_fold_path, base_name, base_name, i);
    S = load(iptstr);                               % load specific Frame
    
    %% 1.a Bypass frames with no Skeletal information
    if (~nnz(S.Frame.Skeleton.PixelPosition))
        fprintf('Skeleton joints not present for frame: %d in %s \n',i, base_name);
        continue;
    end
    
    %% 1.b SkeletonViewer --> Visualize Skeleton information
    %clf(f1);
    %subplot(2,2,1:2);
    %skeletonViewer(S.Frame.Skeleton.WorldPosition, false, i, S.Frame.Skeleton.JointType, 'Original' );
    
    %% 1.c Normalization
    % Eucleidian distance between Shoulder Center and HipCenter
    edist = norm(S.Frame.Skeleton.WorldPosition(1,:) - S.Frame.Skeleton.WorldPosition(3,:));
    
    % Normalize each joint in regard to the above distance and substract to
    % make Hip Center the origin of the coordinate system
    sjoint = zeros(20, 3);
    for j = 1:20
        sjoint(j,:) = (S.Frame.Skeleton.WorldPosition(j,:) / edist) - (S.Frame.Skeleton.WorldPosition(1,:) / edist) ;
    end
    
    %subplot(2,2,3:4);
    %skeletonViewer(sjoint, false, i, S.Frame.Skeleton.JointType,'Normalized');
    
    %% 1.d Keep data to P matrix 
    z = z + 1;
    if (z > nfrm)
        fprintf('Gathered the nesessary frames for computation ::  ');
        break;
    end
    
    for j= 1:20
        P(j).JointType = S.Frame.Skeleton.JointType(j);
        P(j).TimeMtx(:,z) = sjoint(j,:)';
    end
    
    %refreshdata;
    %drawnow;
    %clearvars -except keepVariables i BBOX f1 nfrm start_gestures P startFr endFr z S
    %clear functions
    
end

%% 2. Apply Vector Median Filtering

% Initial window w = 3
for i = 1:20
    P(i).TimeMtx = medfilt2(P(i).TimeMtx,[1,3]);
end

%% 3. Angle Based Pose Descriptor
%% a. Principal Component Analysis on 6 torso joints
%       it is used to form a new body plane x,y,z

torsoJnt = zeros(3,6);                                                      % Only  the torso Joints for PCA algorithm 
sjoint = zeros(20, 3);                                                      % copy of skeleton Joints for individual frame.

%f2 = figure('Name','After PCA Frame','NumberTitle','off');

%% Pose descriptor for extracted gesture
pose_descriptor_gesture = [];

% For each extracted frame...                                               ('Here z total extracted frames')
for i = 1:(z-1)
    
    % a.1 Keep copy of all skeleton joints
    for j = 1:20
        sjoint(j,:) = P(j).TimeMtx(:,i)';
    end
    
    % a.2 Isolate the torso Joint coordinates ,ie. Shoulder center,right,left
    %     ,Hip Center,right,left
    torsoJnt(:,1) = sjoint(3,:)';       
    torsoJnt(:,2) = sjoint(9,:)';       
    torsoJnt(:,3) = sjoint(5,:)';       
    torsoJnt(:,4) = sjoint(1,:)';      
    torsoJnt(:,5) = sjoint(17,:)';     
    torsoJnt(:,6) = sjoint(13,:)';     
    
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
    
    % flip x,y axes 
    tmp = projJnt(:,1);
    projJnt(:,1) = projJnt(:,2);
    projJnt(:,2) = tmp;
    
    %clf(f2);
    %skeletonViewer(projJnt, false, i, S.Frame.Skeleton.JointType,'After PCA');
    
    %% b. Angle Calculation
    
    % The matrix represents the sets of joints that compose each of the 9
    % requested angles
    joint_sets = [ 12 10 9; 10 9 3; 9 3 5; 3 5 6; 5 6 8; 1 3 4; 12 1 3; 8 1 3; 12 1 8 ];
    
    %% b.1 angle vector a
    a = zeros(9,1);
    
    % Calculate angles
    for iter = 1:length(joint_sets)
        % ...for now we are focusing on the x,y 2-d space
        a(iter) = angleCalc(projJnt(joint_sets(iter,1),1:2), projJnt(joint_sets(iter,2),1:2), projJnt(joint_sets(iter,3),1:2) );
    end
    
    % Rule: 1 ? ... angles 1,2,3,4,5 must be less than 180 degrees
    for i2= 1:5
        if a(i2) > 180.00
           a(i2) = 360 - a(i2); 
        end
    end
    
    %% b.2 angle vector b
    
    b = zeros(9,1);
    
    % Calculate angles
    for iter = 1:length(joint_sets)
        % ...for now we are focusing on the x,y 2-d space
        b(iter) = angleCalc(projJnt(joint_sets(iter,1),2:3), projJnt(joint_sets(iter,2),2:3), projJnt(joint_sets(iter,3),2:3) );
    end
    
    % Rule: 1 ? ... angles 1,2,3,4,5 must be less than 180 degrees
    for i2= 1:5
        if b(i2) > 180.00
           b(i2) = 360 - a(i2); 
        end
    end
    
    %% b.3 angle vector c 
    c = zeros(9,1);
    
    % Calculate angles
    for iter = 1:length(joint_sets)
        % ...for now we are focusing on the x,y 2-d space
        c(iter) = angleCalc(projJnt(joint_sets(iter,1),1:2:3), projJnt(joint_sets(iter,2),1:2:3), projJnt(joint_sets(iter,3),1:2:3) );
    end
    
    % Rule: 1 ? ... angles 1,2,3,4,5 must be less than 180 degrees
    for i2= 1:5
        if c(i2) > 180.00
           c(i2) = 360 - a(i2); 
        end
    end
    
    %% b.4 Distance vector d
    % calculate 3 sets of distances between joints 
    
    ysets = [projJnt(12, :); projJnt(10, :); projJnt(9, :); projJnt(5, :); projJnt(6, :); projJnt(8, :)];
    
    % mahalanobis distance of hand and l-r shoulder joints
    d1 = mahal(ysets,projJnt);
    
    nges = cat(1, a, b, c, d1);
    pose_descriptor_gesture = [ pose_descriptor_gesture(:); nges(:) ];
   
    %% b.5 Eucleidian distances
    
    % the joints used in computation
    joint_tags = [1 3 4 5 6 8 9 10 12 13 17];
    f = zeros(55,1);
    
    count=1;
    for h1= 1:11
        for h2= (h1+1):11
            f(count) = sqrt(sum((projJnt(joint_tags(h1), :) - projJnt(joint_tags(h2), :)).^2));
            count = count + 1;
        end
    end
    
    pose_descriptor_gesture = [ pose_descriptor_gesture(:); f ];
    
    %disp('================');
    %length(pose_descriptor_gesture)
    %disp('================');
    
end

%fprintf('\n-- Pose descriptor for gesture #%d is: ', 0);
PD = pose_descriptor_gesture;
end