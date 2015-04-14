% My scriptaki

%% 1.  Structs intro

% patient(1).name = 'John Doe';
% patient(1).billing = 127.00;
% patient(1).test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];
% 
% disp('And the patient is :');
% patient(1)
% disp('...and his table is:')
% patient(1).test
% 
% % add records for other patients to the array by including subscripts after the array name
% 
% patient(2).name = 'Ann Lane';
% patient(2).billing = 28.50;
% patient(2).test = [68, 70, 68; 118, 118, 119; 172, 170, 169];
% patient
% 
% disp('-------');
% patient(1)
% disp('-------');
% patient(2).test
% disp('-------');
% 
% patient(3).name = 'New Name';
% patient(3)
% 
% % test results - Visualize test data 
% amount_due = patient(1).billing
% bar(patient(1).test)                        % represent as bar graph
% title(['Test Results for ', patient(1).name])

%% 2. Access data in structure arrays
% 
% S = load('Sample00004.mat');
% 
% S
% S.Video
% 
% [fileName,filePath] = uigetfile('*', 'Select data file', '.');
% if filePath==0, error('None selected!'); end
% U = load( fullfile(filePath,fileName) );


%%

m = ones(20,20,3)
figure(1);
imshow(m)
pause;
figure(2);
m(3:8,2:17,:) = 0
imshow(m)
figure(3);
mm = m(3:8,2:17,:)
imshow(mm)



