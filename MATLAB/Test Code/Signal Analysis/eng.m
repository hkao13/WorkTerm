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

% Last Modified by GUIDE v2.5 12-Feb-2014 17:11:13

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
    
    fig = engSelectPlots;
    waitfor(fig);
    plot1 = getappdata(0, 'plot1');
    plot2 = getappdata(0, 'plot2');
    
    switch plot1
        case 1
            firstPlot = handles.cellOnset;
        case 2
            firstPlot = handles.rootOnset1;
        case 3
            firstPlot = handles.rootOnset2;
        otherwise
            fprinf('\nInvalid plot, Please choose again.\n')
    end
    
    switch plot2
        case 1
            secondPlot = handles.cellOnset;
        case 2
            secondPlot = handles.rootOnset1;
        case 3
            secondPlot = handles.rootOnset2;
    end
        
    if (numel(firstPlot) ~= numel(secondPlot))
        msg1 = msgbox('Please select the bursts in the first plot using left click, then press ENTER when finished.');
        waitfor(msg1);
        [cellX, cellY] = ginput;
        msg2 = msgbox('Please select the bursts in the second plot using left click, then press ENTER when finished.');
        waitfor(msg2);
        [rootX, rootY] = ginput;
        cellInd = [];
        rootInd = [];
        for i = 1:numel(cellX)
            cellInd(end+1) = find(firstPlot<cellX(i), 1, 'last');
            rootInd(end+1) = find(secondPlot<rootX(i), 1, 'last');
        end
        cellOnset = firstPlot(cellInd);
        rootOnset = secondPlot(rootInd);
        timeDiff = delta(cellOnset, rootOnset);
    else
        msg3 = msgbox('Equal amount of bursts between both plots. Press O.K. to get result.');
        waitfor(msg3);
        timeDiff = delta(firstPlot, secondPlot);
    end
end

% -------------------------------------------------------------------------
% FILE IMPORT PANEL BUTTONS
% -------------------------------------------------------------------------


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
    engPlotButton;
end
% -------------------------------------------------------------------------
% ROOT 1 PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root1_button.
function set_root1_button_Callback(hObject, eventdata, handles)
    engRootSetButton;
end

% --- Executes on button press in cursor_root1_button.
function cursor_root1_button_Callback(hObject, eventdata, handles)
    engRootCursorButton;
end

% --- Executes on button press in manual_root1_button.
function manual_root1_button_Callback(hObject, eventdata, handles)
    engRootManualButton;
end

% --- Executes on button press in erase_root1_button.
function erase_root1_button_Callback(hObject, eventdata, handles)
    engRootEraseButton;
end

% --- Executes on button press in baseline1_button.
function baseline1_button_Callback(hObject, eventdata, handles)
    [x, y] = ginput(1);
    handles.baseline1 = y;
    guidata(hObject, handles);
    set(handles.baseline1_edit, 'String', handles.baseline1)
    hold on;
    base = refline(0, handles.baseline1);
    set(base, 'Color', 'r');
    hold off;
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

% --- Executes on button press in erase_cell_button.
function erase_cell_button_Callback(hObject, eventdata, handles)
end

% -------------------------------------------------------------------------
% ROOT 1 PANEL EDIT BOXES
% -------------------------------------------------------------------------
function thresh_root1_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_root1_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function baseline1_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function baseline1_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%--------------------------------------------------------------------------



function thresh_root2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_root2_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in cursor_root2_button.
function cursor_root2_button_Callback(hObject, eventdata, handles)
    engRootCursorButton2;
end

% --- Executes on button press in set_root2_button.
function set_root2_button_Callback(hObject, eventdata, handles)
    engRootSetButton2;
end

% --- Executes on button press in manual_root2_button.
function manual_root2_button_Callback(hObject, eventdata, handles)
    engRootManualButton2;
end

% --- Executes on button press in erase_root2_button.
function erase_root2_button_Callback(hObject, eventdata, handles)
    engRootEraseButton2;
end




% -------------------------------------------------------------------------
% ROOT 1 OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function root1_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root1_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root1_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root1_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root1_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root1_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



% -------------------------------------------------------------------------
% SETTINGS BUTTON
% -------------------------------------------------------------------------
% --- Executes on button press in settings1_GUI_button.
function settings1_GUI_button_Callback(hObject, eventdata, handles)
    engSettings;
end


% --- Executes on button press in settings2_GUI_button.
function settings2_GUI_button_Callback(hObject, eventdata, handles)
    engSettings2;
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


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function file_open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    engFileImport;
end



function root2_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root2_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root2_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in baseline2_button.
function baseline2_button_Callback(hObject, eventdata, handles)
    [x, y] = ginput(1);
    handles.baseline2 = y;
    guidata(hObject, handles);
    set(handles.baseline2_edit, 'String', handles.baseline2)
    hold on;
    base = refline(0, handles.baseline2);
    set(base, 'Color', 'r');
    hold off;
end


function baseline2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function baseline2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root2_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function cell_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root1_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root1_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end