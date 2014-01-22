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

% Last Modified by GUIDE v2.5 22-Jan-2014 10:16:48

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



function x_data_Callback(hObject, eventdata, handles)
% hObject    handle to x_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_data as text
%        str2double(get(hObject,'String')) returns contents of x_data as a double


% --- Executes during object creation, after setting all properties.
function x_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_data_Callback(hObject, eventdata, handles)
% hObject    handle to y_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_data as text
%        str2double(get(hObject,'String')) returns contents of y_data as a double


% --- Executes during object creation, after setting all properties.
function y_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in_x = get(handles.x_data, 'String');
time = evalin('base', char(in_x));
in_y = get(handles.y_data, 'String');
potential = evalin('base', char(in_y));
threshold = str2double(get(handles.thresh_edit, 'String'));
spike = str2double(get(handles.spike_thresh_edit, 'String'));
trough = str2double(get(handles.trough_thresh_edit, 'String'));
burst = str2double(get(handles.burst_thresh_edit, 'String'));
axes(handles.axes1);
sp = signalprocess(time, potential, threshold);
sp.downSample(5);
sp.bandpass;
sp.filterData;
if (isnan(threshold))
    sp.plotData;
else
    sp.aboveThreshold;
    sp.isBurst(spike, trough, burst);
    sp.plotData;
    sp.plotTest;
    sp.averageDuration;
    sp.averagePeriod;
    sp.averageAmplitude;
    sp.plotAvgAmp;
    set(handles.avg_dur_edit, 'String', sp.average_burst_duration);
    set(handles.avg_per_edit, 'String', sp.average_burst_period);
    set(handles.avg_amp, 'String', sp.average_amplitude);
end

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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avg_amp_Callback(hObject, eventdata, handles)
% hObject    handle to avg_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_amp as text
%        str2double(get(hObject,'String')) returns contents of avg_amp as a double


% --- Executes during object creation, after setting all properties.
function avg_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cursor_button.
function cursor_button_Callback(hObject, eventdata, handles)
% hObject    handle to cursor_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x, y, button] = ginput(1);
if (button == 1)
    set(handles.thresh_edit,'String', y);
    in_x = get(handles.x_data, 'String');
    time = evalin('base', char(in_x));
    in_y = get(handles.y_data, 'String');
    potential = evalin('base', char(in_y));
    threshold = str2double(get(handles.thresh_edit, 'String'));
    spike = str2double(get(handles.spike_thresh_edit, 'String'));
    trough = str2double(get(handles.trough_thresh_edit, 'String'));
    burst = str2double(get(handles.burst_thresh_edit, 'String'));
    axes(handles.axes1);
    sp = signalprocess(time, potential, threshold);
    sp.downSample(5);
    sp.bandpass;
    sp.filterData;
    if (isnan(threshold))
        sp.plotData;
    else
        sp.aboveThreshold;
        sp.isBurst(spike, trough, burst);
        sp.plotData;
        sp.plotTest;
        sp.averageDuration;
        sp.averagePeriod;
        sp.averageAmplitude;
        sp.plotAvgAmp;
        set(handles.avg_dur_edit, 'String', sp.average_burst_duration);
        set(handles.avg_per_edit, 'String', sp.average_burst_period);
        set(handles.avg_amp, 'String', sp.average_amplitude);
    end
    cursor_button_Callback(hObject, eventdata, handles);
end