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

% Last Modified by GUIDE v2.5 30-Jan-2014 13:49:57

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
end

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
end

% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end
% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
threshold = str2double(get(handles.thresh_edit, 'String'));
handles.span = str2double(get(handles.moving_avg_edit, 'String'));
guidata(hObject, handles);
axes(handles.axes2);
cla;
ro = root(handles.time, handles.root, threshold);
ro.bandpass;
ro.filterData(handles.span);
ro.plotData;
set(handles.test_edit, 'String', 'Import Status');
end

function thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of thresh_edit as a double
end

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
end


function spike_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spike_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spike_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of spike_thresh_edit as a double
end

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
end


function burst_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to burst_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of burst_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of burst_thresh_edit as a double
end

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
end


function trough_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trough_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trough_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of trough_thresh_edit as a double
end

% --- Executes during object creation, after setting all properties.
function trough_thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trough_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function avg_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_dur_edit as a double
end

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
end


function avg_per_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_per_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_per_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_per_edit as a double
end

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
end


function avg_amp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to avg_amp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_amp_edit as text
%        str2double(get(hObject,'String')) returns contents of avg_amp_edit as a double
end

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
    handles.spike = str2double(get(handles.spike_thresh_edit, 'String'));
    handles.trough = str2double(get(handles.trough_thresh_edit, 'String'));
    handles.burst = str2double(get(handles.burst_thresh_edit, 'String'));
    guidata(hObject, handles);
    set(handles.thresh_edit, 'String', y);
    threshold = str2double(get(handles.thresh_edit, 'String'));
    axes(handles.axes2);
    ro = root(handles.time, handles.root, threshold);
    ro.bandpass;
    ro.filterData(handles.span);
    ro.aboveThreshold;
    ro.isBurst(handles.spike, handles.trough, handles.burst);
    ro.averageDuration;
    ro.averagePeriod;
    ro.averageAmplitude;
    ro.plotMarkers;
    ro.plotAmplitude;
    set(handles.avg_dur_edit, 'String', ro.averageBurstDuration);
    set(handles.avg_per_edit, 'String', ro.averageBurstPeriod);
    set(handles.avg_amp_edit, 'String', ro.averageAmp);
    
    %objs = get(gca, 'Children');
    %set(handles.test_edit, 'String', numel(objs));
    cursor_button_Callback(hObject, eventdata, handles);

end
end

function root_col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to root_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of root_col_edit as text
%        str2double(get(hObject,'String')) returns contents of root_col_edit as a double
end

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
end


function test_edit_Callback(hObject, eventdata, handles)
% hObject    handle to test_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of test_edit as text
%        str2double(get(hObject,'String')) returns contents of test_edit as a double
end

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
end

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
% hObject    handle to import_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
root_col = str2double(get(handles.root_col_edit, 'String'));
cell_col = str2double(get(handles.cell_col_edit, 'String'));
first = str2double(get(handles.from_edit, 'String'));
last = str2double(get(handles.to_edit, 'String'));

if (isnan(first))
    first = 0;
end

if (isnan(last))
    last = 'e';
end

try
    [data, si] =...
        abfload(handles.path_and_file, 'start', first, 'stop', last);
    handles.root = data(:,root_col);
    handles.cell = data(:,cell_col);
    sample = (1 / (si*10 ^ -6));
    handles.time = (0 : (1/sample) : (numel(handles.root) - 1)/sample)';
    guidata(hObject, handles);
    set(handles.test_edit, 'String', 'Import Successful');
catch err
    disp(err);
    set(handles.test_edit, 'String', 'Import Unsuccessful');
end
end

% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, path_name] = uigetfile({...
'*.atf;*.abf', 'All Axon Files (*.atf. *.abf)';...
'*.atf','Axon Text Files (*.atf)';...
'*.abf','Axon Binary Files (*.abf)'}, 'Please select ENG data file');
handles.path_and_file = strcat(path_name, file_name);
guidata(hObject, handles);
set(handles.path_file_edit, 'String', handles.path_and_file);
end


function path_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_file_edit as text
%        str2double(get(hObject,'String')) returns contents of path_file_edit as a double
end

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
    handles.spike = str2double(get(handles.spike_thresh_edit, 'String'));
    handles.trough = str2double(get(handles.trough_thresh_edit, 'String'));
    handles.burst = str2double(get(handles.burst_thresh_edit, 'String'));
    guidata(hObject, handles);
    axes(handles.axes2);
    ro = root(handles.time, handles.root, threshold);
    ro.bandpass;
    ro.filterData(handles.span);
    ro.aboveThreshold;
    ro.isBurst(handles.spike, handles.trough, handles.burst);
    ro.averageDuration;
    ro.averagePeriod;
    ro.averageAmplitude;
    ro.plotMarkers;
    ro.plotAmplitude;
    set(handles.avg_dur_edit, 'String', ro.averageBurstDuration);
    set(handles.avg_per_edit, 'String', ro.averageBurstPeriod);
    set(handles.avg_amp_edit, 'String', ro.averageAmp);
end
end


function cell_col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cell_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_col_edit as text
%        str2double(get(hObject,'String')) returns contents of cell_col_edit as a double
end

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
end


function moving_avg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to moving_avg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of moving_avg_edit as text
%        str2double(get(hObject,'String')) returns contents of moving_avg_edit as a double
end

% --- Executes during object creation, after setting all properties.
function moving_avg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moving_avg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function from_edit_Callback(hObject, eventdata, handles)
% hObject    handle to from_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from_edit as text
%        str2double(get(hObject,'String')) returns contents of from_edit as a double
end

% --- Executes during object creation, after setting all properties.
function from_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function to_edit_Callback(hObject, eventdata, handles)
% hObject    handle to to_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_edit as text
%        str2double(get(hObject,'String')) returns contents of to_edit as a double
end

% --- Executes during object creation, after setting all properties.
function to_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in manual_button.
function manual_button_Callback(hObject, eventdata, handles)
% hObject    handle to manual_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_items = findobj(gca, 'Color', 'red', '-or', 'Color', 'blue' ,...
    '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
    'Marker', '<');
delete(del_items);
mm = manualmode(handles.time, handles.root);
[x, y, button] = ginput(1);
axes(handles.axes2);
doStuff(mm, x, y, button);

    function doStuff(mm, x, y, button)
        
        if (button == 1)
            mm.appendOnset(x, y);
            mm.plotOnset(x, y);
        end
 
        if (button == 3)
            mm.appendOffset(x, y);
            mm.plotOffset(x, y);
        end
    
        if (button == 8)
            try
                mm.deleteOnset;
                mm.deleteOnsetMarker;
                mm.deleteOffset;
                mm.deleteOffsetMarker;
            catch err
                disp(err);
            end
        end
        
        if (isempty(button))
            button = NaN;
            set(handles.avg_dur_edit, 'String', mm.averageDuration);
            set(handles.avg_per_edit, 'String', mm.averagePeriod);
            set(handles.avg_amp_edit, 'String', mm.averageAmplitude);
            mm.plotThreshold;
            mm.plotAmplitude;
        end
        
        if ((button == 1) || (button == 3) || (button == 8))
            [x, y, button] = ginput(1);
            doStuff(mm, x, y, button);
        end
        
        
    end
end
