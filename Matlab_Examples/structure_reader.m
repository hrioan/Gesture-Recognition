%% Data parser 

%% Gestures in time
% load the designated sample video
S = load('Sample00004.mat');


% visualize the information 
disp('The Matrix read has the following structure: ');
disp(S);

% number of gesture Labels
num_of_gestures = length(S.Video.Labels);

% Print table of the gestures - their begin and end point

for i = 1:num_of_gestures
    % display begin- end points
    outpt = ['> Gesture : ', S.Video.Labels(i).Name, ' begins at: ', num2str(S.Video.Labels(i).Begin), ...
                ' and ends at: ', num2str(S.Video.Labels(i).End), 'sec.'];
    disp(outpt);
end 

disp('--------------------------------------------------------------');

%% Frames ????



