%% O happy day .... (s?) 
%% (workarounds^3)
%path = '/media/scaler13/TOSHIBA EXT/Chalearn_datasets/MatlabViewer/training1/'

[filenamewhatever,path] = uigetfile('*.zip');
%% ???
hObject = 174.0020;
handles.figure1 = 173.0026;
handles.text = 3.0027;
handles.exportData = 2.0027;
handles.soundButton = 1.0027;
handles.playButton = 0.0027;
handles.loadButton = 174.0026;
handles.output = 173.0026;
%% ???

% Load all thingies from file
for i = 401:403                                                             %training set 2 
    
    % load each zip file
    %zip_path = sprintf('%s/', path);
    filename = sprintf('Sample%05d.zip', i);
    
    eventdata = [];
    handles = loadButton_Callback(hObject, eventdata, handles, filename, path);
    
    handles
    % ... and export it to mat files :P
    exportData_Callback(hObject, eventdata, handles)
    
    %break;
end