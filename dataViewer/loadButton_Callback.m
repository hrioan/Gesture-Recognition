% --- Executes on button press in loadButton.
function [ handles ] = loadButton_Callback(hObject, eventdata, handles, filename, path)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filename = uigetfile('*.mat');
% handles.video = load(filename);
% handles.video = handles.video.video;
% 
% handles.audioplayer = audioplayer(handles.video.audio.y, handles.video.audio.fs);
% 
% set(handles.playButton,'Enable','on');
% set(handles.soundButton,'Enable','on');
% 
% guidata(hObject, handles);

hObject
handles
eventdata

%%%[filename,path] = uigetfile('*.zip');

filenameBase = filename(1:length(filename)-4);
handles.path = path;

%folder = strcat(path, '/', filenameBase);
folder = regexprep(path, '\\', '/');
if folder(end)=='/',
    folder=folder(1:end-1);
end
folder = strcat(folder, '/', filenameBase);

%mkdir(folder);
unzip(strcat(path,filename), folder);

filenameColor = strcat(folder, '/',filenameBase, '_color.mp4');
filenameDepth = strcat(folder, '/',filenameBase, '_depth.mp4');
filenameUser = strcat(folder, '/',filenameBase, '_user.mp4');
filenameAudio = strcat(folder, '/',filenameBase, '_audio.wav');
filenameMat = strcat(folder, '/',filenameBase, '_data.mat');

handles.Video = load(filenameMat);
handles.Video = handles.Video.Video;

% Some Windows systems fails on loading mp4 files. In case of error, use
% alternative reading mode.
try
    handles.mode=1;
    handles.colorVid = vision.VideoFileReader(filenameColor);
    handles.depthVid = vision.VideoFileReader(filenameDepth);
    handles.userVid = vision.VideoFileReader(filenameUser);
catch
    handles.mode=2;
    handles.colorVid = VideoReader(filenameColor);
    handles.depthVid = VideoReader(filenameDepth);
    handles.userVid = VideoReader(filenameUser);
end

[handles.y, handles.fs] = wavread(filenameAudio);
handles.audioplayer = audioplayer(handles.y,handles.fs);

handles.filenameBase = filenameBase;

handles

%set(handles.playButton,'Enable','on');
%set(handles.soundButton,'Enable','on');
%set(handles.exportData,'Enable','on');
