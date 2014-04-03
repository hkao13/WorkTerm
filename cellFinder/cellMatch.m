function varargout = cellMatch(varargin)
% CELLMATCH MATLAB code for cellMatch.fig
%      CELLMATCH, by itself, creates a new CELLMATCH or raises the existing
%      singleton*.
%
%      H = CELLMATCH returns the handle to a new CELLMATCH or the handle to
%      the existing singleton*.
%
%      CELLMATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLMATCH.M with the given input arguments.
%
%      CELLMATCH('Property','Value',...) creates a new CELLMATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellMatch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellMatch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellMatch

% Last Modified by GUIDE v2.5 28-Mar-2014 14:54:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellMatch_OpeningFcn, ...
                   'gui_OutputFcn',  @cellMatch_OutputFcn, ...
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


% --- Executes just before cellMatch is made visible.
function cellMatch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellMatch (see VARARGIN)

% Choose default command line output for cellMatch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cellMatch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cellMatch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function red_menu_Callback(hObject, eventdata, handles)
    [filename, pathname] = uigetfile({'*.mat'});
    full = fullfile(pathname, filename);
    matrix = load(full);
    handles.imgRed = matrix.image;
    str = ['R   -   ', filename];
    listboxContent = cellstr(get(handles.files_list,'String'));
    listboxLength = length(listboxContent);
    listboxContent{listboxLength + 1} = str;
    set(handles.files_list, 'String', listboxContent);
    handles.imgRedPosition = listboxLength + 1;
    
    
    guidata(hObject, handles);
% --------------------------------------------------------------------
function green_menu_Callback(hObject, eventdata, handles)
    [filename, pathname] = uigetfile({'*.mat'});
    full = fullfile(pathname, filename);
    matrix = load(full);
    handles.imgGreen = matrix.image;
    str = ['G   -   ', filename];
    listboxContent = cellstr(get(handles.files_list,'String'));
    listboxLength = length(listboxContent);
    listboxContent{listboxLength + 1} = str;
    set(handles.files_list, 'String', listboxContent);
    handles.imgGreenPosition = listboxLength + 1;
    guidata(hObject, handles);

% --------------------------------------------------------------------
function blue_load_Callback(hObject, eventdata, handles)
    [filename, pathname] = uigetfile({'*.mat'});
    full = fullfile(pathname, filename);
    matrix = load(full);
    handles.imgBlue = matrix.image;
    str = ['B   -   ', filename];
    listboxContent = cellstr(get(handles.files_list,'String'));
    listboxLength = length(listboxContent);
    listboxContent{listboxLength + 1} = str;
    set(handles.files_list, 'String', listboxContent);
    handles.imgBluePosition = listboxLength + 1;
    guidata(hObject, handles);

% --- Executes on selection change in files_list.
function files_list_Callback(hObject, eventdata, handles)
% hObject    handle to files_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns files_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from files_list


% --- Executes during object creation, after setting all properties.
function files_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_button.
function view_button_Callback(hObject, eventdata, handles)
    position = get(handles.files_list, 'Value');
    
    switch position
        case handles.imgRedPosition
            image = handles.imgRed;
        case handles.imgGreenPosition
            image = handles.imgGreen;
        case handles.imgBluePosition
            image = handles.imgBlue;
    end

    axes(handles.axes1)
    imshow(image, 'InitialMagnification', 'fit');
