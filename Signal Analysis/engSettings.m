function varargout = engSettings(varargin)
% ENGSETTINGS MATLAB code for engSettings.fig
%      ENGSETTINGS, by itself, creates a new ENGSETTINGS or raises the existing
%      singleton*.
%
%      H = ENGSETTINGS returns the handle to a new ENGSETTINGS or the handle to
%      the existing singleton*.
%
%      ENGSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGSETTINGS.M with the given input arguments.
%
%      ENGSETTINGS('Property','Value',...) creates a new ENGSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engSettings

% Last Modified by GUIDE v2.5 03-Feb-2014 14:00:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @engSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @engSettings_OutputFcn, ...
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


% --- Executes just before engSettings is made visible.
function engSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engSettings (see VARARGIN)

% Choose default command line output for engSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes engSettings wait for user response (see UIRESUME)
% uiwait(handles.engSettings);
    

% --- Outputs from this function are returned to the command line.
function varargout = engSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function trough_thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trough_thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trough_thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of trough_thresh_edit as a double


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


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata...
    (0, 'spike' , str2double(get(handles.spike_thresh_edit , 'String')))
setappdata...
    (0, 'trough', str2double(get(handles.trough_thresh_edit, 'String')))
setappdata...
    (0, 'burst' , str2double(get(handles.burst_thresh_edit , 'String')))



% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.engSettings);
