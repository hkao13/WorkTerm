function varargout = engFileImport(varargin)
% ENGFILEIMPORT MATLAB code for engFileImport.fig
%      ENGFILEIMPORT, by itself, creates a new ENGFILEIMPORT or raises the existing
%      singleton*.
%
%      H = ENGFILEIMPORT returns the handle to a new ENGFILEIMPORT or the handle to
%      the existing singleton*.
%
%      ENGFILEIMPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGFILEIMPORT.M with the given input arguments.
%
%      ENGFILEIMPORT('Property','Value',...) creates a new ENGFILEIMPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engFileImport_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engFileImport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engFileImport

% Last Modified by GUIDE v2.5 11-Feb-2014 10:43:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @engFileImport_OpeningFcn, ...
                   'gui_OutputFcn',  @engFileImport_OutputFcn, ...
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

% --- Executes just before engFileImport is made visible.
function engFileImport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engFileImport (see VARARGIN)

% Choose default command line output for engFileImport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes engFileImport wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = engFileImport_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function root1_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function root1_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function import_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function import_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function path_file_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function path_file_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
    engBrowseButton;
end

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
end


function cell_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function from_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function from_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function to_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function to_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

