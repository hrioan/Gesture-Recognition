function varargout = dataViewer(varargin)
% DATAVIEWER MATLAB code for dataViewer.fig
%      DATAVIEWER, by itself, creates a new DATAVIEWER or raises the existing
%      singleton*.
%
%      H = DATAVIEWER returns the handle to a new DATAVIEWER or the handle to
%      the existing singleton*.
%
%      DATAVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAVIEWER.M with the given input arguments.
%
%      DATAVIEWER('Property','Value',...) creates a new DATAVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataViewer

% Last Modified by GUIDE v2.5 02-Apr-2013 07:57:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @dataViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dataViewer is made visible.
function dataViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataViewer (see VARARGIN)

% Choose default command line output for dataViewer
handles.output = hObject;

set(handles.playButton,'Enable','off');
set(handles.soundButton,'Enable','off');
set(handles.exportData,'Enable','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exportData.
function exportData_Callback(hObject, eventdata, handles)
% hObject    handle to exportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(handles.text,'String','Working...');

%guidata(hObject, handles);

filenameMatBase = handles.filenameBase; %strcat(handles.filenameBase, 'Sample');
pathExportFolder = strcat(handles.path, handles.filenameBase, '_Export');
mkdir(pathExportFolder);

skeletonStruct = struct();
skeletonStruct.WorldPosition = zeros(20,3);
skeletonStruct.WorldRotation = zeros(20,4);
skeletonStruct.JointType = cell(20,1);
skeletonStruct.PixelPosition = zeros(20,2);

frameStruct = struct('RGB',0,'Depth',0,'UserIndex',0,'Skeleton',skeletonStruct());
videoStruct = struct('NumFrames',0,'FrameRate',0,'Labels',0,'Audio',0);

Video = videoStruct();
Video.NumFrames = handles.Video.NumFrames;
Video.FrameRate = handles.Video.FrameRate;
Video.Labels = handles.Video.Labels;
audio = struct('y',handles.y, 'fs', handles.fs);
Video.Audio = audio;

save(strcat(filenameMatBase,'.mat'));

Frame = frameStruct();
for i = 1:handles.Video.NumFrames
    
    if handles.mode==1,
        Frame.RGB = step(handles.colorVid);
        Frame.Depth =  getDepth(step(handles.depthVid),handles.Video.MaxDepth);
        Frame.UserIndex = getUser(step(handles.userVid));
        Frame.Skeleton = handles.Video.Frames(i).Skeleton;
    elseif handles.mode==2,
    
        Frame.RGB = read(handles.colorVid, i);
        Frame.Depth =  getDepth(read(handles.depthVid, i),handles.Video.MaxDepth);
        Frame.UserIndex = getUser(read(handles.userVid, i));
        Frame.Skeleton = handles.Video.Frames(i).Skeleton;
    end
    
    s = sprintf(strcat(filenameMatBase,'_%d.mat'), i);
    s = strcat(pathExportFolder,'/',s);
    save(s,'Frame');
end

set(handles.text,'String','Exported');

guidata(hObject,handles);

function depth = getDepth(frame,maxDepth)
    depth = uint16(round(double(rgb2gray(frame))/255.0*maxDepth));

function ui = getUser(frame)
ui = logical(rgb2gray(frame));


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
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

[filename,path] = uigetfile('*.zip');

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

set(handles.playButton,'Enable','on');
set(handles.soundButton,'Enable','on');
set(handles.exportData,'Enable','on');

guidata(hObject, handles);


function C = drawBones(ui, bones)
C = ui;
[h,w,l] = size(ui);
%C = cat(3,ui2,ui2,ui2);
for i = 1 : 20
    Y = bones(i,1);
    X = bones(i,2);
    dxm = max(X-4,1);
    dxM = min(X+4,h);
    dym = max(Y-4,1);
    dyM = min(Y+4,w);
    C(dxm:dxM,dym:dyM,2) = 0;
end
    

% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sz = get(0, 'ScreenSize');
w = 410;
h = 330;
x = ceil((sz(3)-h)/2);
y = ceil((sz(4)-w)/2);


% If Windows, use DeployableVideoPlayer, otherwise use VideoPlayer

if(ispc),

    videoPlayer1 = vision.DeployableVideoPlayer;
    set(videoPlayer1, 'Location', [x y]);
    set(videoPlayer1, 'Size', 'Custom');
    set(videoPlayer1, 'CustomSize', [w h]);
    set(videoPlayer1, 'Name', 'Color');
    videoPlayer2 = vision.DeployableVideoPlayer;
    set(videoPlayer2, 'Location', [x-w-10 y]);
    set(videoPlayer2, 'Size', 'Custom');
    set(videoPlayer2, 'CustomSize', [w h]);
    set(videoPlayer2, 'Name', 'Depth');
    videoPlayer3 = vision.DeployableVideoPlayer;
    set(videoPlayer3, 'Location', [x+w+10 y]);
    set(videoPlayer3, 'Size', 'Custom');
    set(videoPlayer3, 'CustomSize', [w h]);
    set(videoPlayer3, 'Name', 'User Index');

else
    videoPlayer1 = vision.VideoPlayer;
    set(videoPlayer1, 'Position',[x y w h]);
    set(videoPlayer1, 'Name', 'Color');

    videoPlayer2 = vision.VideoPlayer;
    set(videoPlayer2, 'Position',[x+w+10 y w h]);
    set(videoPlayer2, 'Name', 'Depth');

    videoPlayer3 = vision.VideoPlayer;
    set(videoPlayer3, 'Position',[x-w-10 y w h]);
    set(videoPlayer3, 'Name', 'User Index');
end

for k = 1 : handles.Video.NumFrames
       
    if handles.mode==1,
        f1 = step(handles.colorVid);
        step(videoPlayer1,f1);
        f2 = step(handles.depthVid);
        step(videoPlayer2,f2);
        bones = handles.Video.Frames(k).Skeleton.PixelPosition;
        f3 = step(handles.userVid);
        step(videoPlayer3, drawBones(f3,bones));
    elseif handles.mode==2,
    
        f1 = read(handles.colorVid, k);
        step(videoPlayer1,f1);
        f2 = read(handles.depthVid, k);
        step(videoPlayer2,f2);
        bones = handles.Video.Frames(k).Skeleton.PixelPosition;
        f3 = read(handles.userVid, k);
        step(videoPlayer3, drawBones(f3,bones));
        
    end
end

handles.colorVid.reset();
handles.depthVid.reset();
handles.userVid.reset();


% --- Executes on button press in soundButton.
function soundButton_Callback(hObject, eventdata, handles)
% hObject    handle to soundButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play(handles.audioplayer);
