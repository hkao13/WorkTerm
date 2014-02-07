function varargout = eng(varargin)
% ENG MATLAB code for eng.fig
%      ENG, by itself, creates a new ENG or raises the existing
%      singleton*.
%
%      H = ENG returns the handle to a new ENG or the handle to
%      the existing singleton*.
%
%      ENG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENG.M with the given input arguments.
%
%      ENG('Property','Value',...) creates a new ENG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eng_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eng_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eng

% Last Modified by GUIDE v2.5 07-Feb-2014 10:09:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eng_OpeningFcn, ...
                   'gui_OutputFcn',  @eng_OutputFcn, ...
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

% --- Executes just before eng is made visible.
function eng_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eng (see VARARGIN)

% Choose default command line output for eng
    handles.output = hObject;

% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes eng wait for user response (see UIRESUME)
% uiwait(handles.eng);
    initializeVar;
end

% --- Outputs from this function are returned to the command line.
function varargout = eng_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end

function timeDiff = set_time_diff (handles)
    if (numel(handles.cellOnset) ~= numel(handles.rootOnset))
        timeDiff = 'ERROR';
    else
        timeDiff = delta(handles.cellOnset, handles.rootOnset);
    end
end

% -------------------------------------------------------------------------
% FILE IMPORT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
    engBrowseButton;
end

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
    engImportButton;
end

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
    engPlotButton;
end

% -------------------------------------------------------------------------
% ROOT INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root_button.
function set_root_button_Callback(hObject, eventdata, handles)
    engRootSetButton;
end

% --- Executes on button press in cursor_root_button.
function cursor_root_button_Callback(hObject, eventdata, handles)
    engRootCursorButton;
end

% --- Executes on button press in manual_root_button.
function manual_root_button_Callback(hObject, eventdata, handles)
    engRootManualButton;
end

% -------------------------------------------------------------------------
% CELL INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in manual_cell_button.
function manual_cell_button_Callback(hObject, eventdata, handles)
    engCellManualButton;
end


% --- Executes on button press in time_diff_button.
function time_diff_button_Callback(hObject, eventdata, handles)
    set(handles.time_diff_edit, 'String', set_time_diff(handles));
end

% -------------------------------------------------------------------------
% ROOT INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function thresh_root_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_root_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function root_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% FILE IMPORT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function root_col_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root_col_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function test_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function test_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function path_file_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function path_file_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function cell_col_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_col_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function moving_avg_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function moving_avg_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function from_edit_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function from_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function to_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function to_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% -------------------------------------------------------------------------
% SETTINGS BUTTON
% -------------------------------------------------------------------------
% --- Executes on button press in settings_GUI_button.
function settings_GUI_button_Callback(hObject, eventdata, handles)
    engSettings;
end


% -------------------------------------------------------------------------
% CELL OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function cell_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    end
end

function cell_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function time_diff_edit_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function time_diff_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
