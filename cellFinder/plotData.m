function varargout = plotData(varargin)
% PLOTDATA MATLAB code for plotData.fig
%      PLOTDATA, by itself, creates a new PLOTDATA or raises the existing
%      singleton*.
%
%      H = PLOTDATA returns the handle to a new PLOTDATA or the handle to
%      the existing singleton*.
%
%      PLOTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTDATA.M with the given input arguments.
%
%      PLOTDATA('Property','Value',...) creates a new PLOTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotData

% Last Modified by GUIDE v2.5 08-Apr-2014 11:04:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotData_OpeningFcn, ...
                   'gui_OutputFcn',  @plotData_OutputFcn, ...
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


% --- Executes just before plotData is made visible.
function plotData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotData (see VARARGIN)

% Choose default command line output for plotData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in directory_button.
function directory_button_Callback(hObject, eventdata, handles)
    folder = uigetdir();
    dirListing = dir(folder);
    handles.data = [];
    for i = 1:length(dirListing)
        if (~dirListing(i).isdir)
            fileName = fullfile(folder, dirListing(i).name);
            handles.data = vertcat(handles.data, importdata(fileName));
        end
    end
    guidata(hObject, handles);

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
    % x coordinate of centroid in first column.
    xx = handles.data(:, 1);
    % y cooordinate of centroid in second column.
    yy = handles.data(:, 2);
    % color code of coordinate in third column.
    color = handles.data(:, 3);
    
    figure(101);
    hold on
    axis ij;
    % For loop to plot data.
    CircleSize = 5; % Change number for size of the Markers.
    for i = 1:numel(xx)
        x = xx(i);
        y = yy(i);
        c = color(i);
        switch c
            case 1 
                c = [1 0 0];        % Red Cells
            case 2
                c = [0 1 0];        % Green Cells
            case 3
                c = [0 0 1];        % Blue Cells
            case 12
                c = [1 0.6 .2];     % Red/Green (Yellow) Cells
            case 13
                c = [1 0 1];        % Red/Blue (Magenta) Cells
            case 23
                c = [0 1 1];        % Blue/Green (Cyan) Cells
            case 123
                c = [0 0 0];        % Red/Green/Blue (Black, actually supposed to be White) Cells
        end
        plot(x, y, 'o', 'MarkerEdgeColor', c, 'MarkerFaceColor', c, 'MarkerSize', CircleSize);   
    end
    xlabel('X-Axis');
    ylabel('Y-Axis');
    hold off
    
%     % End of plotting the data.
%     n = 5;
%     xxi = linspace(min(xx(:)), max(xx(:)), n);
%     yyi = linspace(min(yy(:)), max(yy(:)), n);
% 
%     % Groups data.
%     xxr = interp1(xxi, 1:numel(xxi), xx, 'nearest');
%     yyr = interp1(yyi, 1:numel(yyi), yy, 'nearest');
% 
%     % Makes matrix.
%     zz = accumarray([xxr yyr], 1, [n n]);
%     figure(104)
%     hold on
%     % Creates Heat/Density Map.
%     surf(zz)
%     camroll(270);
%     xlabel('X-Axis');
%     ylabel('Y-Axis');
%     hold off
%     
%    % Sets subplot 3 of figure(2) to current axes.
%     figure(105)
%     hold on
%     % Creates contour plot.
%     contour(zz);
%     camroll(270);
%     hold off
    
    figure(102)
    axis ij
    hold on
    smoothhist2D([xx yy], 0.5, [50,50], [], 'surf');
    hold off
    
    figure(103)
    axis ij
    hold on
    smoothhist2D([xx yy], 0.5, [50,50], [], 'contour');
    hold off
    
    
