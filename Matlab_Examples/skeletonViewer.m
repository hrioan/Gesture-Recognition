function [] = skeletonViewer( skeleton, postFlag, framenum )
% Visualize Skeleton data in 3-d (optimized for Kinect Sensor)
% postFlag = True  :: Visualize entire skeleton 
% postFlag = False :: Visualize upper body posture (with legs + no wrists)

if postFlag == true

    SkeletonConnectionMap = [   [1 2]; [2 3]; [3 4];                % Spine
                                [3 5]; [5 6]; [6 7]; [7 8];         % Left Hand
                                [3 9]; [9 10]; [10 11]; [11 12];    % Right Hand
                                [1 17]; [17 18]; [18 19]; [19 20];  % Right Leg
                                [1 13]; [13 14]; [14 15]; [15 16]]; % Left Leg

else
    SkeletonConnectionMap = [   [1 2]; [2 3]; [3 4];        % Spine
                                [3 5]; [5 6]; [6 8];        %Left Hand
                                [3 9]; [9 10]; [10 12];     %Right Hand
                                [1 17];                     % Hip left
                                [1 13]                      % Hip Right 
                             ];
end

% Draw the skeleton in 3-d plot 
f1 = figure('Name','Skeleton Frame','NumberTitle','off');
title(sprintf('Skeleton Frame: %d',framenum));

for i = 1:length(SkeletonConnectionMap)
   
    % joint A
    X1 = skeleton.WorldPosition(SkeletonConnectionMap(i,1),1);
    Y1 = skeleton.WorldPosition(SkeletonConnectionMap(i,1),2);
    Z1 = skeleton.WorldPosition(SkeletonConnectionMap(i,1),3);
    
    % Joint B
    X2 = skeleton.WorldPosition(SkeletonConnectionMap(i,2),1);
    Y2 = skeleton.WorldPosition(SkeletonConnectionMap(i,2),2);
    Z2 = skeleton.WorldPosition(SkeletonConnectionMap(i,2),3);
    
    % plot line
    plot3([X1,X2], [Y1,Y2], [Z1,Z2], 'g','LineWidth', 2);
    hold on;
    % .. and skeletal points
    %plot3([X1,Y1,Z1], 'g--o');
    %plot3([X2,Y2,Z2], 'g--o');
    plot3(X1,Y1,Z1, '--rs', 'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','b','MarkerSize',10 );
    plot3(X2,Y2,Z2, '--rs', 'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','b','MarkerSize',10 );

    text(X1,Y1,Z1,skeleton.JointType(SkeletonConnectionMap(i,1)));
    view(184,-88) % also -180,-72 is good to give a sense of depth
end

    drawnow;
    pause;
    close(f1);

end