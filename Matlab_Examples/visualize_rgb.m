%% Image manipulation in matlab 

diary on;
clear; clc;
imtool close all;  % Close all imtool figures.
disp('Image Manipulation in Matlab');
pause;
clc;

%% 
BBOX = 60;

%% visualize frame along with skeletal information

%scrsz = get(0,'ScreenSize');

f1 = figure('Name','Gesture Frame','NumberTitle','off');
%set(f1, 'Position', [ 250  250 800 800  ]);

%f = figure(2);

start_gestures = [1 80 120 160 200 240 280 360 400 480 520 560 620 680 740 780 840 920 980 1060 ]

%% 1: visualize each frame repeatedly with image
for i = start_gestures(17):1117
   
    figure(f1);  %set figure f1 current
    
    iptstr = sprintf('./Sample00003_Export/Sample00003_%d.mat',i);
    %disp(['Frame:',i,'Path:',iptstr]);
    S = load(iptstr);
    
    % 1.a Bypass frames with no Skeletal information
    if (~nnz(S.Frame.Skeleton.PixelPosition))
        fprintf('Skeleton joints not present for frame: %d',i);
        continue;
    end
    
    % Plot data
    subplot(2,4,1:2);
    title(sprintf('RGB Data : Frame: %d',i));
    imshow(S.Frame.RGB,'Border','tight');
    hold on 
    
    %% 2: For each frame plot its skeleton joints
    for j=1:20
        %disp(['Frame',i,'Joint:',S.Frame.Skeleton.JointType(j),S.Frame.Skeleton.PixelPosition(j,:)])
        plot(S.Frame.Skeleton.PixelPosition(j,1),S.Frame.Skeleton.PixelPosition(j,2),'g+');
        hold on
    end
    %hold off
    
    %% 3: Right and Left hand + Bounding Boxes
    
    % right hand and left hand boxes
    lx = S.Frame.Skeleton.PixelPosition(8,1);
    ly = S.Frame.Skeleton.PixelPosition(8,2);
    a = [lx - BBOX/2 , ly + BBOX/2];
    b = [lx + BBOX/2 , ly + BBOX/2];
    d = [lx - BBOX/2 , ly - BBOX/2];
    lhand = S.Frame.RGB(d(2):a(2),a(1):b(1),:);
    
    rx = S.Frame.Skeleton.PixelPosition(12,1);
    ry = S.Frame.Skeleton.PixelPosition(12,2);
    a = [rx - BBOX/2 , ry + BBOX/2];
    b = [rx + BBOX/2 , ry + BBOX/2];
    d = [rx - BBOX/2 , ry - BBOX/2];
    rhand = S.Frame.RGB(d(2):a(2),a(1):b(1),:);
    
    subplot(2,4,3);    
    imshow(lhand);
    title('Left hand');
    hold off
    
    subplot(2,4,4);    
    imshow(rhand);
    title('Right hand');
    hold off
    %% 4: Generate Skinmap
    
    %Convert hand boxes in Grayscale 
    %rhand_g = rgb2gray(rhand);
    %lhand_g = rgb2gray(lhand);
    
    % Apply Gaussian Smoothing
    gaussian_filter = fspecial('gaussian',[4 4], 0.5);
    rhand = imfilter(rhand, gaussian_filter, 'replicate');
    lhand = imfilter(lhand, gaussian_filter, 'replicate');
    
    [rhand_skin, rhand_bin] = generate_skinmap( im2uint8(rhand) );
    [lhand_skin, lhand_bin ] = generate_skinmap( im2uint8(lhand) );

    subplot(2,4,5);    
    imshow(lhand_bin);
    title('Skinmap Left');
   
    subplot(2,4,6);    
    imshow(rhand_bin);
    title('Skinmap Right');
    %% Classic Edge detection 
    
    lhand_g = edge(lhand_bin, 'canny');
    rhand_g = edge(rhand_bin, 'canny');
    
    subplot(2,4,7);    
    imshow(rhand_g);
    title('Right hand');
    
    subplot(2,4,8);    
    imshow(lhand_g);
    title('Left hand');
    %% draw bounding box on rgb plot (disabled for faster rendering)
    %  rectangle('Position',[d(1), d(2), BBOX, BBOX],'EdgeColor','r');

    %% Plot Depth data 
%     figure(2);
%     image(S.Frame.Depth);
    
    refreshdata;
    drawnow;
    
    clearvars -except keepVariables BBOX f1
    clear functions
end

% 1.b visualize through matlab's video viewer ???

%(EDIT:: We need a Video type structure (provided) .. that supports all the frames)
% for i = 1:1117
%     iptstr = sprintf('./Sample00003_Export/Sample00003_%d.mat',i);
%     disp(['Frame:',i,'Path:',iptstr]);
%     
%     gestureseq = load(iptstr);
%     implay(gestureseq);
% end

%%
disp('Press any key to continue');
pause;
clc;

diary off;