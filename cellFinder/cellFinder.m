function varargout = cellFinder(varargin)
% CELLFINDER MATLAB code for cellFinder.fig
%      CELLFINDER, by itself, creates a new CELLFINDER or raises the existing
%      singleton*.
%
%      H = CELLFINDER returns the handle to a new CELLFINDER or the handle to
%      the existing singleton*.
%
%      CELLFINDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLFINDER.M with the given input arguments.
%
%      CELLFINDER('Property','Value',...) creates a new CELLFINDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellFinder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellFinder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellFinder

% Last Modified by GUIDE v2.5 26-Mar-2014 15:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellFinder_OpeningFcn, ...
                   'gui_OutputFcn',  @cellFinder_OutputFcn, ...
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

% --- Executes just before cellFinder is made visible.
function cellFinder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellFinder (see VARARGIN)

% Choose default command line output for cellFinder
handles.output = hObject;
handles.overlayColor = [1 1 1];
set(handles.white_menu, 'Checked', 'on');
set(handles.click_menu, 'Checked', 'on');
handles.eraseMethod = 'click';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cellFinder wait for user response (see UIRESUME)
% uiwait(handles.cellFinder);
set(handles.axes1, 'XTickLabel', []);
set(handles.axes1, 'XTick', []);
set(handles.axes1, 'YTickLabel', []);
set(handles.axes1, 'YTick', []);
radius = {1:200};
set(handles.mask_pop, 'String', radius);
end
% --- Outputs from this function are returned to the command line.
function varargout = cellFinder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --------------------------------------------------------------------
function tool_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function restart_menu_Callback(hObject, eventdata, handles)
    answer = questdlg({'Are you sure you want to restart?' 'All progress will be lost!'});
    if (strcmp(answer, 'Yes'))
        close(handles.cellFinder);
        cellFinder;
    elseif (strcmp(answer, 'No'))
        return
    elseif (strcmp(answer, 'Cancel'))
        return
    end
end

% --------------------------------------------------------------------
function section_menu_Callback(hObject, eventdata, handles)
    imageSize = size(handles.img);
    grid = meshgrid(1:imageSize(2), 1:imageSize(1));
    hbox1 = msgbox('Please section the image vertically');
    waitfor(hbox1);
    yValues = [];
    vert;
    function vert
        [x, y, button] = ginput(1);
        if (button == 1)
            yValues(end + 1) = y;
            line([1, imageSize(2)], [y, y], 'Color', 'w');
            vert;
        end
    end
    hbox2 = msgbox('Please section the image horizontally');
    waitfor(hbox2);
    xValues = [];
    horz;
    function horz
        [x, y, button] = ginput(1);
        if (button == 1)
            xValues(end + 1) = x;
            line([x, x], [1, imageSize(1)], 'Color', 'w');
            horz;
        end
    end
    
    for i = 1:numel(yValues)
        grid(round(yValues(i)), :, :) = 0;
    end
    
    for j = 1:numel(xValues)
        grid(:, round(xValues(j)), :) = 0;
    end
    
    handles.imgGrid = imcomplement(grid);
    handles.gridRows = sort(yValues, 'ascend');
    handles.gridCols = sort(xValues, 'ascend');
    guidata(hObject, handles);
end 

% --------------------------------------------------------------------
function settings_menu_Callback(hObject, eventdata, handles)
% hObject    handle to settings_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function overlayColor_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overlayColor_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function white_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 1 1];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function red_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.white_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 0 0];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function orange_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.white_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 0.5 0];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function green_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.white_menu, 'Checked', 'off');
    handles.overlayColor = [0 1 0];
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function erase_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function click_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.draw_menu, 'Checked', 'off');
    handles.eraseMethod = 'click';
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function draw_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.click_menu, 'Checked', 'off');
    handles.eraseMethod = 'draw';
    guidata(hObject, handles);
    
end

%---------------------------------------------------------------------

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
    [filename, pathname] = uigetfile('*.png');
    full = fullfile(pathname, filename);
    handles.img = imread(full);
    handles.fig = handles.img;
    axes(handles.axes1)
    imshow(handles.img, 'InitialMagnification', 'fit');
    set(handles.axes1, 'NextPlot', 'ReplaceChildren');
    guidata(hObject, handles);
end
    
% --- Executes on button press in gray_button.
function gray_button_Callback(hObject, eventdata, handles)
    handles.imgGray = rgb2gray(handles.img);
    handles.fig = handles.imgGray;
    imshow(handles.imgGray);
    guidata(hObject, handles);
end

% --- Executes on button press in contrast_button.
function contrast_button_Callback(hObject, eventdata, handles)
    handles.imgGray = rgb2gray(handles.img);
    handles.imgGrayContrast = adapthisteq(handles.imgGray);
    handles.fig = handles.imgGrayContrast;
    imshow(handles.imgGrayContrast);
    guidata(hObject, handles);
end

% --- Executes on button press in auto_radio.
function auto_radio_Callback(hObject, eventdata, handles)
    set(handles.hist_radio, 'Value', 0);
end

% --- Executes on button press in hist_radio.
function hist_radio_Callback(hObject, eventdata, handles)
    set(handles.auto_radio, 'Value', 0);
    if (get(handles.hist_radio, 'Value') == 1)
        figure(45);
        hold on;
        imhist(handles.fig);
        hold off;
    end
end

% --- Executes on button press in bw_button.
function bw_button_Callback(hObject, eventdata, handles)
    if (get(handles.auto_radio, 'Value') == 1)
        threshold = graythresh(handles.fig);
        handles.imgBW = im2bw(handles.fig, threshold);
        imshow(handles.imgBW);
        set(handles.threshold_edit, 'String', threshold * 255);
        set(handles.bw_slider, 'Value', threshold * 255);
        
    elseif (get(handles.hist_radio, 'Value') == 1)
        threshold = str2double(get(handles.threshold_edit, 'String'));
        handles.imgBW = handles.fig > threshold;
        imshow(handles.imgBW);
        set(handles.bw_slider, 'Value', threshold);
    end
    
    guidata(hObject, handles);
end
    



function threshold_edit_Callback(hObject, eventdata, handles)
    threshold = str2double(get(handles.threshold_edit, 'String'));
    set(handles.bw_slider, 'Value', threshold);
end
    
% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function bw_slider_Callback(hObject, eventdata, handles)
    threshold = get(handles.bw_slider, 'Value');
    set(handles.threshold_edit, 'String', threshold);
    handles.imgBW = handles.fig > threshold;
    imshow(handles.imgBW, 'InitialMagnification', 'fit'); 
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function bw_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in noise_button.
function noise_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgBW'))
        area = str2double(get(handles.pixel_edit, 'String'));
        handles.imgCleaned = imfill(handles.imgBW, 'holes');
        handles.imgCleaned = bwareaopen(handles.imgCleaned, area);
        imshow(handles.imgCleaned);
        guidata(hObject, handles);
    end
end


function pixel_edit_Callback(hObject, eventdata, handles)
    area = str2double(get(handles.pixel_edit, 'String'));
    set(handles.noise_slider, 'Value', area);
end
    
% --- Executes during object creation, after setting all properties.
function pixel_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function noise_slider_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBW'))
        area = get(handles.noise_slider, 'Value');
        set(handles.pixel_edit, 'String', area);
        handles.imgCleaned = imfill(handles.imgBW, 'holes');
        handles.imgCleaned = bwareaopen(handles.imgCleaned, area);
        imshow(handles.imgCleaned);
        guidata(hObject, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function noise_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in refine_button.
function refine_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    radius = str2double(get(handles.disk_edit, 'String'));
    se = strel('disk', radius);
    handles.imgRefined = imopen(image, se);
    handles.imgRefined = imdilate(handles.imgRefined, se);
    imshow(handles.imgRefined);
    guidata(hObject, handles);
end


function disk_edit_Callback(hObject, eventdata, handles)
    radius = str2double(get(handles.disk_edit, 'String'));
    set(handles.refine_slider, 'Value', radius);
end


% --- Executes during object creation, after setting all properties.
function disk_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function refine_slider_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    radius = get(handles.refine_slider, 'Value');
    set(handles.disk_edit, 'String', radius);
    se = strel('disk', radius);
    handles.imgRefined = imopen(image, se);
    handles.imgRefined = imdilate(handles.imgRefined, se);
    imshow(handles.imgRefined);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function refine_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in overlaybw_button.
function overlaybw_button_Callback(hObject, eventdata, handles)
    overlayBW = imoverlay(handles.img, handles.imgBW, handles.overlayColor);
    imshow(overlayBW);
end

% --- Executes on button press in overlayNoise_button.
function overlayNoise_button_Callback(hObject, eventdata, handles)
    overlayCleaned = imoverlay(handles.img, handles.imgCleaned, handles.overlayColor);
    imshow(overlayCleaned);
end


% --- Executes on button press in overlayRefine_button.
function overlayRefine_button_Callback(hObject, eventdata, handles)
    overlayRefined = imoverlay(handles.img, handles.imgRefined, handles.overlayColor);
    imshow(overlayRefined);
end


% --- Executes on button press in overlayEdit_button.
function overlayEdit_button_Callback(hObject, eventdata, handles)
    overlayEdit = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
    imshow(overlayEdit);
end
    
% --- Executes on button press in draw_button.
function draw_button_Callback(hObject, eventdata, handles)
    
    if (~isfield(handles, 'imgEdit'))
        if (isfield(handles, 'imgRefined'))
            handles.imgEdit = handles.imgRefined;
        elseif (isfield(handles, 'imgCleaned'))
            handles.imgEdit = handles.imgCleaned;
        elseif (isfield(handles, 'imgBW'))
            handles.imgEdit = handles.imgBW;
        end
    end
    
    [x, y, button] = ginput(1);
    if (button == 1)
        imageSize = size(handles.img);
        radius = get(handles.mask_pop, 'Value');

        [imgX, imgY] = meshgrid(1:imageSize(2), 1:imageSize(1));
        mask = sqrt((imgX - x).^2 + (imgY - y).^2) <= radius;
        handles.imgEdit(mask == 1) = 1;
        overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
        imshow(overlay);
        guidata(hObject, handles);
        draw_button_Callback(hObject, eventdata, handles);
    end
end    
    
    
    
% --- Executes on button press in remove_button.
function remove_button_Callback(hObject, eventdata, handles)
    if (~isfield(handles, 'imgEdit'))
        if (isfield(handles, 'imgRefined'))
            handles.imgEdit = handles.imgRefined;
        elseif (isfield(handles, 'imgCleaned'))
            handles.imgEdit = handles.imgCleaned;
        elseif (isfield(handles, 'imgBW'))
            handles.imgEdit = handles.imgBW;
        end
    end
    handles.imgLabeled = bwlabel(handles.imgEdit);
    switch handles.eraseMethod
        case 'click'
            [x, y, button] = ginput(1);
            if (button == 1)
                blob = handles.imgLabeled(round(y), round(x));
                handles.imgEdit(handles.imgLabeled == blob) = 0;
                handles.imgLabeled = bwlabel(handles.imgEdit);
                overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
                imshow(overlay);
                guidata(hObject, handles);
                remove_button_Callback(hObject, eventdata, handles);
            end
            
        case 'draw'
            freehand = imfreehand();
            imgBinary = freehand.createMask();
            handles.imgEdit(imgBinary) = 0;
            handles.imgLabeled = bwlabel(handles.imgEdit);
            overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
            imshow(overlay);
            guidata(hObject, handles);                   
    end
    
end


% --- Executes on selection change in mask_pop.
function mask_pop_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function mask_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in view_button.
function view_button_Callback(hObject, eventdata, handles)
    imshow(handles.img);
end

% --- Executes on button press in bw1_button.
function bw1_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgBW);
end

% --- Executes on button press in bw2_button.
function bw2_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgCleaned);
end


% --- Executes on button press in bw3_button.
function bw3_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgRefined);
end

% --- Executes on button press in bw4_button.
function bw4_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgEdit);
end

% --- Executes on button press in count_button.
function count_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgEdit'))
        image = handles.imgEdit;
    elseif (isfield(handles, 'imgRefined'))
        image = handles.imgRefined;
    elseif (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    label = logical(image);
    stats = regionprops(label, 'Centroid');
    set(handles.count_edit, 'String', numel(stats));
       
    if (isfield(handles, 'gridRows') || isfield(handles, 'gridCols'))
        imageSize = size(handles.img);
        gridRows = [0, handles.gridRows, imageSize(1)];
        gridCols = [0, handles.gridCols, imageSize(2)];
        height = diff(gridRows);
        width = diff(gridCols);
        sections = 1:(numel(width) * numel(height));

        gridCols2 = gridCols(1:end - 1);
        gridCols3 = gridCols(2:end);
        gridRows2 = gridRows(1:end - 1);
        gridRows3 = gridRows(2:end);

        multiple1 = numel(sections) / numel(gridCols2);
        xMin = cell(1, multiple1);
        xMax = cell(1, multiple1);
        for i = 1:numel(xMin)
            xMin{i} = gridCols2;
            xMax{i} = gridCols3;
        end
        xMin = cell2mat(xMin);
        xMax = cell2mat(xMax);

        multiple2 = numel(sections) / numel(gridRows2);
        yMin = cell(1, multiple2);
        yMax = cell(1, multiple2);
        for i = 1:numel(yMin)
            yMin{i} = gridRows2;
            yMax{i} = gridRows3;        
        end
        yMin = cell2mat(yMin);  
        yMin = sort(yMin, 'ascend');
        yMax = cell2mat(yMax);
        yMax = sort(yMax, 'ascend');

        allocateCell = cell(1, numel(sections)); 
        block = struct('blockNumber', allocateCell,...
            'xMinimum', allocateCell, 'xMaximum', allocateCell,...
            'yMinimum', allocateCell, 'yMaximum', allocateCell,...
            'cellCount', allocateCell);

        for i = 1:numel(sections)
            block(i).blockNumber = i;
            block(i).xMinimum = xMin(i);
            block(i).xMaximum = xMax(i);
            block(i).yMinimum = yMin(i);
            block(i).yMaximum = yMax(i);
            block(i).cellCount = 0;
        end

        for i = 1:numel(stats)
            centroid = stats(i).Centroid;
            xx = centroid(1);
            yy = centroid(2);
            for j = 1:numel(block)
                cond1 = (xx > block(j).xMinimum) && (xx < block(j).xMaximum);
                cond2 = (yy > block(j).yMinimum) && (yy < block(j).yMaximum);
                cellCount = block(j).cellCount;
                if ( (cond1 == 1) && (cond2 == 1))
                    block(j).cellCount = cellCount + 1;
                end
            end     
        end

        for i = 1:numel(block);
            fprintf('Block: %d\t-\tCell Count: %d\n', block(i).blockNumber, block(i).cellCount); 
        end
        fprintf('\n');
    end  
end
    
function count_edit_Callback(hObject, eventdata, handles)
end
    
% --- Executes during object creation, after setting all properties.
function count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in grid1_button.
function grid1_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    for i = 1:numel(handles.gridRows)
        currentFig(round(handles.gridRows(i)), :, :) = 255;
    end
    
    for j = 1:numel(handles.gridCols)
        currentFig(:, round(handles.gridCols(j)), :) = 255;
    end
    imshow(currentFig);
end

% --- Executes on button press in grid2_button.
function grid2_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    for i = 1:numel(handles.gridRows)
        currentFig(round(handles.gridRows(i)), :, :) = 255;
    end
    
    for j = 1:numel(handles.gridCols)
        currentFig(:, round(handles.gridCols(j)), :) = 255;
    end
    imshow(currentFig);
end

% --- Executes on button press in grid3_button.
function grid3_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    for i = 1:numel(handles.gridRows)
        currentFig(round(handles.gridRows(i)), :, :) = 255;
    end
    
    for j = 1:numel(handles.gridCols)
        currentFig(:, round(handles.gridCols(j)), :) = 255;
    end
    imshow(currentFig);
end

% --- Executes on button press in grid4_button.
function grid4_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    for i = 1:numel(handles.gridRows)
        currentFig(round(handles.gridRows(i)), :, :) = 255;
    end
    
    for j = 1:numel(handles.gridCols)
        currentFig(:, round(handles.gridCols(j)), :) = 255;
    end
    imshow(currentFig);
end
