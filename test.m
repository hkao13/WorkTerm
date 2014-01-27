function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 27-Jan-2014 10:04:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = handles.time;
threshold = str2double(get(handles.thresh_edit, 'String'));
axes(handles.axes3);
cla;
cp = signalprocess(time, handles.cell, threshold);
cp.downSample(0);
cp.bandpass;
cp.filterData;
cp.plotData;

axes(handles.axes2);
cla;

potential = handles.root;
sp = signalprocess(time, potential, threshold);
sp.downSample(0);
sp.bandpass;
sp.filterData;
sp.plotData;


function thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spike_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spike_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spike_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of spike_thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function spike_thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spike_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function burst_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to burst_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of burst_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of burst_thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function burst_thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to burst_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trough_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trough_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trough_edit as text
%        str2double(get(hObject,'String')) returns contents of trough_edit as a double


% --- Executes during object creation, after setting all properties.
function trough_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trough_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avg_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_dur_edit as a double


% --- Executes during object creation, after setting all properties.
function avg_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avg_per_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_per_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_per_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_per_edit as a double


% --- Executes during object creation, after setting all properties.
function avg_per_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_per_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avg_amp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_amp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_amp_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_amp_edit as a double


% --- Executes during object creation, after setting all properties.
function avg_amp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_amp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cursor_button.
function cursor_button_Callback(hObject, eventdata, handles)
% hObject    handle to cursor_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x, y, button] = ginput(1);

if (button == 1)
    del_items = findobj(gca, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
        'Marker', '<');
    delete(del_items);
    
    set(handles.thresh_edit, 'String', y);
    time = handles.time;
    potential = handles.root;
    threshold = str2double(get(handles.thresh_edit, 'String'));
    spike = str2double(get(handles.spike_thresh_edit, 'String'));
    trough = str2double(get(handles.trough_thresh_edit, 'String'));
    burst = str2double(get(handles.burst_thresh_edit, 'String'));
    axes(handles.axes2);
    sp = signalprocess(time, potential, threshold);
    sp.downSample(0);
    sp.bandpass;
    sp.filterData;
    sp.aboveThreshold;
    sp.isBurst(spike, trough, burst);
    sp.averageDuration;
    sp.averagePeriod;
    sp.averageAmplitude;
    sp.plotMarker;
    sp.plotAvgAmp;
    set(handles.avg_dur_edit, 'String', sp.average_burst_duration);
    set(handles.avg_per_edit, 'String', sp.average_burst_period);
    set(handles.avg_amp_edit, 'String', sp.average_amplitude);
    
    %objs = get(gca, 'Children');
    %set(handles.test_edit, 'String', numel(objs));
    cursor_button_Callback(hObject, eventdata, handles);

end


function root_col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to root_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of root_col_edit as text
%        str2double(get(hObject,'String')) returns contents of root_col_edit as a double


% --- Executes during object creation, after setting all properties.
function root_col_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to root_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function test_edit_Callback(hObject, eventdata, handles)
% hObject    handle to test_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of test_edit as text
%        str2double(get(hObject,'String')) returns contents of test_edit as a double


% --- Executes during object creation, after setting all properties.
function test_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
% hObject    handle to import_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path_and_file = handles.path_and_file;
root_col = str2double(get(handles.root_col_edit, 'String'));
cell_col = str2double(get(handles.cell_col_edit, 'String'));
try
    [data, si] = abfload(path_and_file);
    root = data(:,root_col);
    handles.root = root;
    guidata(hObject, handles);
    cell = data(:,cell_col);
    handles.cell = cell;
    guidata(hObject, handles);
    sample = (1 / (si*10 ^ -6));
    time = (0 : (1/sample) : (numel(root) - 1)/sample)';
    handles.time = time;
    guidata(hObject, handles);
    set(handles.test_edit, 'String', 'Import Successful');
catch err
    set(handles.test_edit, 'String', 'Import Unsuccessful');
end


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, path_name] = uigetfile({...
'*.atf;*.abf', 'All Axon Files (*.atf. *.abf)';...
'*.atf','Axon Text Files (*.atf)';...
'*.abf','Axon Binary Files (*.abf)'}, 'Please select EMG data file');
path_and_file = strcat(path_name, file_name);
handles.path_and_file = path_and_file;
guidata(hObject, handles);
set(handles.path_file_edit, 'String', path_and_file);



function path_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_file_edit as text
%        str2double(get(hObject,'String')) returns contents of path_file_edit as a double


% --- Executes during object creation, after setting all properties.
function path_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_button.
function set_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
threshold = str2double(get(handles.thresh_edit, 'String'));
if ( isnan(threshold) )
    set(handles.thresh_edit, 'String', 'Please enter a value.')
else
    del_items = findobj(gca, 'Color', 'red', '-or', 'Color', 'blue' ,...
        '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
        'Marker', '<');
    delete(del_items);
    
    time = handles.time;
    potential = handles.root;
    spike = str2double(get(handles.spike_thresh_edit, 'String'));
    trough = str2double(get(handles.trough_thresh_edit, 'String'));
    burst = str2double(get(handles.burst_thresh_edit, 'String'));
    axes(handles.axes2);
    sp = signalprocess(time, potential, threshold);
    sp.downSample(0);
    sp.bandpass;
    sp.filterData;
    sp.aboveThreshold;
    sp.isBurst(spike, trough, burst);
    sp.averageDuration;
    sp.averagePeriod;
    sp.averageAmplitude;
    sp.plotMarker;
    sp.plotAvgAmp;
    set(handles.avg_dur_edit, 'String', sp.average_burst_duration);
    set(handles.avg_per_edit, 'String', sp.average_burst_period);
    set(handles.avg_amp_edit, 'String', sp.average_amplitude);
end



function cell_col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cell_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_col_edit as text
%        str2double(get(hObject,'String')) returns contents of cell_col_edit as a double


% --- Executes during object creation, after setting all properties.
function cell_col_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
