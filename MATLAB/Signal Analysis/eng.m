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

% Last Modified by GUIDE v2.5 12-Mar-2014 10:39:15

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
    setappdata(0, 'defaultHandles', handles)
    initializeVar;
% UIWAIT makes eng wait for user response (see UIRESUME)
% uiwait(handles.eng);
    
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

% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function file_load_menu_Callback(hObject, eventdata, handles)
    engFileImport;
end

% --------------------------------------------------------------------
function file_open_menu_Callback(hObject, eventdata, handles)
    [fileName, pathName] = uigetfile('*.fig');
    open(fullfile(pathName, fileName));
    fprintf('File %s%s has been Opened.\n', pathName, fileName);    
end

% --------------------------------------------------------------------
function file_save_menu_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'file'))
        hgsave(handles.eng, handles.file);
        fprintf('Data has been saved.\n')
    else
        fprintf('No existing data file has been found, please Save As...\n')
    end
end

% --------------------------------------------------------------------
function file_saveas_menu_Callback(hObject, eventdata, handles)
    [fileName, pathName] = uiputfile({'*.mat', 'MATLAB File (*.mat)'; '*.fig', 'MATLAB Figure (*.fig)'; '*.eps', 'Encapsulated PostScript (*.eps)'; '*.emf', 'Enhanced Metafile (*.emf)'});
    handles.file = fullfile(pathName, fileName);
    
    %search1 = strfind(fileName, '.mat');
    %search2 = strfind(fileName, '.fig');
    %search3 = strfind(fileName, '.eps');
    %search4 = strfind(fileName, '.emf');
    
    %notEmpty = (~isempty(search3)) || (~isempty(search4));
    %if (~isempty(search1))
    %    save(handles.file);
    %elseif (notEmpty == 1)
    %    saveas(handles.eng, handles.file);
    %elseif (~isempty(search2))
        hgsave(handles.eng, handles.file);
    %else
    %    return
    %end
    fprintf('Current work saved as, %s, in directory, %s\n', fileName, pathName);
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function figure_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function figure_polar_menu_Callback(hObject, eventdata, handles)
    fig = engSelectPlots;
    waitfor(fig);
    plot1 = getappdata(0, 'plot1');
    plot2 = getappdata(0, 'plot2');
    
    switch plot1
        case 1
            firstPlotOnset = handles.cellOnset;
            firstPlotOffset = handles.cellOffset;
        case 2
            firstPlotOnset = handles.rootOnset1;
            firstPlotOffset = handles.rootOffset1;
        case 3
            firstPlotOnset = handles.rootOnset2;
            firstPlotOffset = handles.rootOffset2;
        otherwise
            fprinf('\nInvalid plot, Please choose again.\n')
    end
    
    switch plot2
        case 1
            secondPlotOnset = handles.cellOnset;
            secondPlotOffset = handles.cellOffset;
        case 2
            secondPlotOnset = handles.rootOnset1;
            secondPlotOffset = handles.rootOffset1;
        case 3
            secondPlotOnset = handles.rootOnset2;
            secondPlotOffset = handles.rootOffset2;
        otherwise
            fprinf('\nInvalid plot, Please choose again.\n')
    end
        
    if (numel(firstPlotOnset) ~= numel(secondPlotOnset))
        msg1 = msgbox({'Please select the bursts in the first (reference) plot using left click, then press ENTER when finished.', 'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
        waitfor(msg1);
        [cellX, cellY] = ginput;
        msg2 = msgbox({'Please select the bursts in the second (measurement) plot using left click, then press ENTER when finished.', 'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
        waitfor(msg2);
        [rootX, rootY] = ginput;
        cellOnsetInd = [];
        rootOnsetInd = [];
        cellOffsetInd = [];
        rootOffsetInd = [];
        for i = 1:numel(cellX)
            cellOnsetInd(end+1) = find(firstPlotOnset < cellX(i), 1, 'last');
            rootOnsetInd(end+1) = find(secondPlotOnset < rootX(i), 1, 'last');
            cellOffsetInd(end+1) = find(firstPlotOffset > cellX(i), 1, 'first');
            rootOffsetInd(end+1) = find(secondPlotOffset > rootX(i), 1, 'first');
        end
        cellOnset = firstPlotOnset(cellOnsetInd);
        rootOnset = secondPlotOnset(rootOnsetInd);
        cellOffset = firstPlotOffset(cellOffsetInd);
        rootOffset = secondPlotOffset(rootOffsetInd);
        [timeOnsetDiff, timeOnsetDiffArray] = delta(cellOnset, rootOnset);
        referencePeriod = diff(firstPlotOnset(cellOnsetInd));
    else
        msg3 = msgbox('Equal amount of bursts between both (reference and measurement) plots. Press O.K. to get result.');
        waitfor(msg3);
        [timeOnsetDiff, timeOnsetDiffArray] = delta(firstPlotOnset, secondPlotOnset);
        referencePeriod = diff(firstPlotOnset);
    end
    
    timeOnsetDiffArray(end) = [];
    theta = (-2*pi*(timeOnsetDiffArray./referencePeriod)) + (pi/2);
    radius = ones(1, numel(theta));
    yBar = mean(sin(theta));
    xBar = mean(cos(theta));
    radiusBar = [0, sqrt((xBar^2) + (yBar^2))];
    quadrant1 = ((xBar > 0) && (yBar > 0));
    quadrant2 = ((xBar < 0) && (yBar > 0));
    quadrant3 = ((xBar < 0) && (yBar < 0));
    quadrant4 = ((xBar > 0) && (yBar < 0));
    if (quadrant1 == 1)
        thetaBar = [0, atan(yBar/xBar)];
        angle = 90 - (thetaBar(:,2) * 180/pi);
    elseif (quadrant2 == 1)
        thetaBar = [0, atan(yBar/xBar) + pi];
        angle = 360 - (thetaBar(:,2) * 180/pi) + 90;
    elseif (quadrant3 == 1)
        thetaBar = [0, atan(yBar/xBar) + pi];
        angle = 360 - (thetaBar(:,2) * 180/pi) + 90;
    elseif (quadrant4 == 1)
        thetaBar = [0, atan(yBar/xBar)];
        angle = abs(thetaBar(:,2) * 180/pi) + 90;
    end
    figure(99);

    polar(theta, radius, 'r*');
    hold on;
    polar(thetaBar, radiusBar, '-ob');
    
    % Re-labling polar plot axis.
    polarHandle = findall(gca, 'Type', 'Text');
    polarString = get(polarHandle, 'String');
    polarString(3:15) = {
        'Polar Plot'
        '90'
        '270'
        '120'
        '300'
        '150'
        '330'
        '180'
        '0'
        '210'
        '30'
        '240'
        '60'
        };
    set(polarHandle, {'String'}, polarString);
    txt = {'Reference Plot:', num2str(plot1), '', 'Measurement Plot:', num2str(plot2), '', 'Angle of vector in degrees:', num2str(angle), '', 'Length of vector (Maximum = 1):' num2str(radiusBar(:,2))};
    annotation('textbox', [0 0 0.17 0.3], 'String', txt);
    %-------
    hold off;
end

% --------------------------------------------------------------------
function [timeOnsetDiff, timeOffsetDiff] = set_time_diff (handles)    
    fig = engSelectPlots;
    waitfor(fig);
    plot1 = getappdata(0, 'plot1');
    plot2 = getappdata(0, 'plot2');
    
    switch plot1
        case 1
            firstPlotOnset = handles.cellOnset;
            firstPlotOffset = handles.cellOffset;
        case 2
            firstPlotOnset = handles.rootOnset1;
            firstPlotOffset = handles.rootOffset1;
        case 3
            firstPlotOnset = handles.rootOnset2;
            firstPlotOffset = handles.rootOffset2;
        otherwise
            fprinf('\nInvalid plot, Please choose again.\n')
    end
    
    switch plot2
        case 1
            secondPlotOnset = handles.cellOnset;
            secondPlotOffset = handles.cellOffset;
        case 2
            secondPlotOnset = handles.rootOnset1;
            secondPlotOffset = handles.rootOffset1;
        case 3
            secondPlotOnset = handles.rootOnset2;
            secondPlotOffset = handles.rootOffset2;
        otherwise
            fprinf('\nInvalid plot, Please choose again.\n')
    end
        
    if (numel(firstPlotOnset) ~= numel(secondPlotOnset))
        msg1 = msgbox({'Please select the bursts in the first (reference) plot using left click, then press ENTER when finished.', 'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
        waitfor(msg1);
        [cellX, cellY] = ginput;
        msg2 = msgbox({'Please select the bursts in the second (measurement) plot using left click, then press ENTER when finished.', 'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
        waitfor(msg2);
        [rootX, rootY] = ginput;
        cellOnsetInd = [];
        rootOnsetInd = [];
        cellOffsetInd = [];
        rootOffsetInd = [];
        for i = 1:numel(cellX)
            cellOnsetInd(end+1) = find(firstPlotOnset < cellX(i), 1, 'last');
            rootOnsetInd(end+1) = find(secondPlotOnset < rootX(i), 1, 'last');
            cellOffsetInd(end+1) = find(firstPlotOffset > cellX(i), 1, 'first');
            rootOffsetInd(end+1) = find(secondPlotOffset > rootX(i), 1, 'first');
        end
        cellOnset = firstPlotOnset(cellOnsetInd);
        rootOnset = secondPlotOnset(rootOnsetInd);
        cellOffset = firstPlotOffset(cellOffsetInd);
        rootOffset = secondPlotOffset(rootOffsetInd);
        [timeOnsetDiff, timeOnsetDiffArray] = delta(cellOnset, rootOnset);
        [timeOffsetDiff] = delta(cellOffset, rootOffset);
    else
        msg3 = msgbox('Equal amount of bursts between both (reference and measurement) plots. Press O.K. to get result.');
        waitfor(msg3);
        [timeOnsetDiff, timeOnsetDiffArray] = delta(firstPlotOnset, secondPlotOnset);
        [timeOffsetDiff] = delta(firstPlotOffset, secondPlotOffset);
    end
end

% -------------------------------------------------------------------------
% PLOT/RESET BUTTON
% -------------------------------------------------------------------------

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
    defaultHandles = getappdata(0, 'defaultHandles');
    engPlotButton;
end

% -------------------------------------------------------------------------
% CELL INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in cursor_cell_button.
function cursor_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootCursorButton;
end

% --- Executes on button press in manual_cell_button.
function manual_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootManualButton;
end

% --- Executes on button press in erase_cell_button.
function erase_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootEraseButton;
end

% --- Executes on button press in time_diff_button.
function time_diff_button_Callback(hObject, eventdata, handles)
    [handles.onsetDiff, handles.offsetDiff] = set_time_diff(handles);
    set(handles.onset_diff_edit, 'String', handles.onsetDiff);
    set(handles.offset_diff_edit, 'String', handles.offsetDiff);
    guidata(hObject, handles);
end

% --- Executes on button press in cell_reset_button.
function cell_reset_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engResetButtons;
end

% -------------------------------------------------------------------------
% CELL INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function thresh_cell_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_cell_edit_CreateFcn(hObject, eventdata, handles)
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

function onset_diff_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function onset_diff_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function offset_diff_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function offset_diff_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT 1 PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root1_button.
function set_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootSetButton;
end

% --- Executes on button press in cursor_root1_button.
function cursor_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootCursorButton;
end

% --- Executes on button press in manual_root1_button.
function manual_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootManualButton;
end

% --- Executes on button press in erase_root1_button.
function erase_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootEraseButton;
end

% --- Executes on button press in baseline1_button.
function baseline1_button_Callback(hObject, eventdata, handles)
    [x, y, button] = ginput(1);
    if (button == 1)
        try
            delete(handles.base1);
        catch err
        end
        set(handles.baseline1_edit, 'String', y);
        handles.baseline1 = str2double(get(handles.baseline1_edit, 'String'));
        hold on;
        handles.base1 = refline(0, handles.baseline1);
        set(handles.base1, 'Color', 'r');
        hold off;
        guidata(hObject, handles);
    end
end

% --- Executes on button press in view_baseline1.
function view_baseline1_Callback(hObject, eventdata, handles)
    axes(handles.axes2);
    handles.base1 = refline(0, handles.baseline1);
    set(handles.base1, 'Color', 'r');
end

% --- Executes on button press in root1_reset_button.
function root1_reset_button_Callback(hObject, eventdata, handles)
identity = 1;
engResetButtons;
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

function root1_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root1_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
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


%--------------------------------------------------------------------------
% ROOT 2 INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root2_button.
function set_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootSetButton;
end

% --- Executes on button press in cursor_root2_button.
function cursor_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootCursorButton;
end

% --- Executes on button press in manual_root2_button.
function manual_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootManualButton;
end

% --- Executes on button press in erase_root2_button.
function erase_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootEraseButton;
end

% --- Executes on button press in baseline2_button.
function baseline2_button_Callback(hObject, eventdata, handles)
    [x, y, button] = ginput(1);
    if (button == 1)
        try
            delete(handles.base2)
        catch err
        end
        set(handles.baseline2_edit, 'String', y);
        handles.baseline2 = str2double(get(handles.baseline2_edit, 'String'));
        hold on;
        handles.base2 = refline(0, handles.baseline2);
        set(handles.base2, 'Color', 'r');
        hold off;
        guidata(hObject, handles);
    end
end


% --- Executes on button press in view_baseline2.
function view_baseline2_Callback(hObject, eventdata, handles)
    axes(handles.axes4);
    handles.base2 = refline(0, handles.baseline2);
    set(handles.base2, 'Color', 'r');
end

% --- Executes on button press in root2_reset_button.
function root2_reset_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engResetButtons;
end

% -------------------------------------------------------------------------
% ROOT 2 INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function thresh_root2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_root2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
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

% -------------------------------------------------------------------------
% ROOT 2 OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
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

% --- Executes on button press in settings0_GUI_button.
function settings0_GUI_button_Callback(hObject, eventdata, handles)
    engSettings0;
end
