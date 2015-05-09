% playful me 

%% visualize array to image

% C = [0 2 4 6; 8 10 12 14; 16 18 20 22];
% image(C)
% colorbar
% 
% disp('Press any key to continue');
% pause;
% clc;
% %%
% x = linspace(-pi,pi);
% y1 = sin(x);
% y2 = cos(x);
% 
% plot(x,y1,'r-')
% hold on
% plot(x,y2,'b-')
% 
% hold off
% y3 = sin(2*x);
% plot(x,y3)
% %%
% ax1 = subplot(2,1,1);
% x = linspace(0,2*pi);
% y1 = sin(x);
% plot(x,y1)
% 
% ax2 = subplot(2,1,2);
% y2 = cos(x);
% plot(x,y2)
% 
% hold(ax1,'on')
% y3 = sin(2*x);
% plot(ax1,x,y3)
% 
% a=[1:100];
% 
% figure;
% h=plot(1,a(1));
% for i=2:100
%   set(h,'XData',[1:i])
%   set(h,'YData',a(1:i))
%   refreshdata
%   drawnow
% end


    %% depth sensor --->  
    %% The idea is to use it as a mask to bring forth the hand pixels
    %% and distinguish them from the background (not sure if needed)
    
    % ------- DOES NOT SHOW GOOD ACCURACY - Can't distinguish hand -------%
%     
%     max_depth = max(max(S.Frame.Depth));
%     
%     rhand_g = (S.Frame.Depth(d(2):a(2),a(1):b(1),:) >= max_depth - 2).* rhand_g;
%     
%    


%% 3-dimensional data in MATLAB

% red = [1 22; 239 7];
% green = [6 6; 208 6];
% blue = [1 1; 207 3];
% 
% truecolor_image = cat(3, red, green, blue);
% image(truecolor_image)
% axis equal % Display the image using square pixels
% 
% 
% 
% p1 = [2,2,3];
% p2 = [2,2,3];
% p3 = [2,2,3];
% p4 = [2,2,3];
% 
% p = [p1;p2;p3;p4; p1];
% figure;
% line(p(:,1), p(:,2), p(:,3));
% 
% 

% 
% 
% a = -1 : .1 : 0;
% b = 1 : -.1 : 0;
% c = b;
% plot3(a, b, c) 


% % 
% % fs = 100;
% % t = 0:1/fs:1;
% % x = sin(2*pi*t*3)+0.25*sin(2*pi*t*40);
% % y = medfilt1(x,10);
% % figure,clf
% % plot(t,x,t,y),grid on
% % xlabel 'Time (s)',ylabel Signal
% % legend('Original','Filtered')
% % legend boxoff


x = [0:100]
A = [x; exp(x)];

fileID = fopen('exp.txt','w');
%fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'[ ');
for i = 1:length(x)
    fprintf(fileID,'%d ',x(i));
end
fprintf(fileID,']\n ');

fclose(fileID);
