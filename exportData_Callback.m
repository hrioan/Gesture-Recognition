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

%set(handles.text,'String','Exported');


function depth = getDepth(frame,maxDepth)
    depth = uint16(round(double(rgb2gray(frame))/255.0*maxDepth));

function ui = getUser(frame)
ui = logical(rgb2gray(frame));

%guidata(hObject,handles);