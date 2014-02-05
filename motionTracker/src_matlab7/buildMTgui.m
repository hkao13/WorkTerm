function h = buildMTgui;

global captureFile;
global captureFolder;
global gv;
global trak;

nHpixels = gv.nHp;
nVpixels = gv.nVp;

figH = figure('Color',[0.8 0.8 0.8], ...
	'MenuBar', 'none', ...
	'Name', 'Motion Tracker 2-D', ...
	'NumberTitle', 'off', ...
    'KeyPressFcn', 'mtHotKeyHandler', ...
    'Units', 'normalized',...
	'Position', [0 0.2 1 .72]);
h.fig = figH;

%MENU BAR ITEMS
h.filesMenu = uimenu('Parent', figH, ...
	'Label', 'Files', ...
    'Enable', 'On');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI loadFile', ...
	'Label', 'Load .avi');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI saveFile', ...
	'Label', 'Save Tracking (.mat)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI saveFileAs', ...
	'Label', 'Save Tracking AS (.mat)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI saveCalibrationFile', ...
	'Label', 'Save DLT Calibration File (.mat)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI loadMatFile', ...
	'Label', 'Load Tracking (.mat)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI exportRawData', ...
	'Label', 'Export raw data (pixels) to ascii text (.txt)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'mtGUI exportCaldData', ...
	'Label', 'Export calibrated data (mm) to ascii text (.txt)');
uimenu('Parent', h.filesMenu, ...
	'Callback', 'close([guiH.fig controlH.fig])', ...
	'Label', 'Close Windows');

h.params = uimenu('Parent',figH, ...
	'Label', 'Parameters', ...
    'Enable', 'On', ...
    'ForegroundColor', [1 0 0]);
h2 = uimenu('Parent', h.params, ...
	'Callback', 'mtGUI loadParameters', ...
	'Label', 'Load Parameters');
h2 = uimenu('Parent', h.params, ...h
	'Callback', 'mtGUI saveParameters', ...
	'Label', 'Save Parameters');

%calibration menu
h.calibration = uimenu('Parent',figH, ...
	'Label', 'Calibration', ...
    'Enable', 'On', ...
    'ForegroundColor', [1 0 0]);
h2 = uimenu('Parent', h.calibration, ...
	'Callback', 'mtGUI calWrefMarkers', ...
	'Label', 'Calibrate using Reference Markers');
h2 = uimenu('Parent', h.calibration, ...h
	'Callback', 'mtGUI calWmouse', ...
	'Label', 'Calibrate using mouse');
h2 = uimenu('Parent', h.calibration, ...h
	'Callback', 'mtGUI cal2points', ...
	'Label', '2-point calibration');
h2 = uimenu('Parent', h.calibration, ...h
	'Callback', 'calib2Ddlt', ...
	'Label', '2-D DLT');

%Tracking controls
h.manTrakMenu = uimenu('Parent', h.fig, ...
	'Label', 'Tracking', ...
    'Enable', 'On');
h.menuManTrak = uimenu('Parent', h.manTrakMenu, ...
	'Callback', 'mtTrackingConfig', ...
	'Label', 'Configure Tracking');

h.menuManTrak = uimenu('Parent', h.manTrakMenu, ...
	'Callback', 'manualDigitize allMarkers', ...
	'Label', 'MANUAL');

h.menuAutoTrak = uimenu('Parent', h.manTrakMenu, ...
	'Callback', 'mtGUI start', ...
    'Accelerator', 'a', ...
    'Enable', 'On', ...
	'Label', 'AUTO');
h.menuStopTrak = uimenu('Parent', h.manTrakMenu, ...
	'Callback', 'mtGUI stop', ...
    'Accelerator', 's', ...
	'Label', 'STOP');
uimenu('Parent', h.manTrakMenu, ...
	'Callback', 'mtGUI setStrobeThresh', ...
	'Label', 'Adjust Strobe Threshold');

h.anglesMenu = uimenu('Parent', h.fig, ...
	'Label', 'Joint Angles', ...
    'Enable', 'On');
h.menuDefineAngles = uimenu('Parent', h.anglesMenu, ...
	'Callback', 'mtDefineAngles', ...
    'Accelerator', 'q', ...
	'Label', 'Define Angles');

hAbout = uimenu('Parent', h.fig, ...
	'Label', 'About', ...
    'Enable', 'On');
uimenu('Parent', hAbout, ...
    'Callback', 'mtGUI AboutBox',...
    'Label', 'About');

% uimenu('Parent', h.manTrakMenu, ...
% 	'Label', '----------------');
% 

%************************************************************
%Frame number display
uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Units','Normalized', ...
	'Position',[0.465 .95 .065 .04], ...
	'String', sprintf('Frame:'), ...
    'HorizontalAlignment','right',...
    'FontWeight', 'b',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.frameNumTxt = uicontrol('Parent', figH, ...
    'Style','edit', ...
	'Units','Normalized', ...
	'Position',[0.53 .95 .05 .04], ...
	'String',' ', ...
    'Callback', 'mtGUI setFrame',...
    'HorizontalAlignment','center',...
    'FontWeight', 'b',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.totalFramesTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
	'Units','Normalized', ...
	'Position',[0.58 .95 .08 .04], ...
	'String',' ', ...
    'HorizontalAlignment','center',...
    'FontWeight', 'b',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.frameNumSldr = uicontrol('Parent', figH, ...
    'Style','slider', ...
	'Units','Normalized', ...
	'Position',[0.66 .95 .2 .04], ...
	'String','tsasd', ...
    'Callback', 'mtGUI setFrameSldr',...
    'Max', 1, ...
    'Min', 1, ...
    'Value', 1);
%frame/tracking controls
%******************************************************
%Video format selection
uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
	'Units','Normalized', ...
	'Position',[0.865 .975 .1 .025], ...
	'String','Video Format', ...
    'HorizontalAlignment','Center',...
    'FontWeight', 'normal',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.format = uicontrol('Parent', figH, ...
    'Style', 'popup',...
    'String', 'Select format|30 fps (iBot)|60 fps (DV)|120 fps - WIDE|120 fps - TALL|240 fps|Custom',...
    'Value', gv.videoFormat, ...
    'Units', 'Normalized', ...
    'Position', [.865 .95 .1 .025],...
    'Tooltipstring', 'Video format: fps = fields per second, "normal" camcorder video is 60 fps',...
    'Callback', 'mtGUI setVideoFormat');

%Creat AXES window for movie image
h.ax = axes('Parent', figH, ...
	'Units','Normalized', ...
    'color',[.5 .5 .5],...
	'Position',[0.05 0.05 .75 .89], ...
	'Box','on', ...
    'NextPlot','replacechildren',...
    'Xlim',[1 nHpixels],...
    'Ydir','reverse',...
    'DataAspectRatio', [1 1 1], ...
    'Ylim',[1 nVpixels],...
    'GridLineStyle', ':',...
    'Tag','axesMTgui');

%dialog for file name
h.loadFileButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
	'Position',[0.01 .94 .055 .05], ...
	'Callback','mtGUI loadFile', ...
	'String','FILE', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', 8, ...
	'Tag','pbLoadFile');

h.aviFileTxt = uicontrol('Parent', figH, ...
    'Style','edit', ...
	'Units','Normalized', ...
	'Position',[0.065 .94 .4 .05], ...
	'Callback','mtGUI loadNewFileText', ...
	'String', sprintf('%s%s',captureFolder, captureFile), ...
    'HorizontalAlignment','left',...
    'FontUnits','points', ...
    'FontSize', 8, ...
	'Tag','txtLoadFile');

%*****************************************************
h.stopButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
    'BackgroundColor',[1 0 0],...
    'Enable','On',...
	'Units','Normalized', ...
	'Position',[0.815 .59 .075 .06], ...
	'Callback','mtGUI stop', ...
	'String','STOP', ...
    'FontWeight','b',...
    'FontUnits','Points', ...
    'FontSize', 8);

h.startButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
    'BackgroundColor',[0 1 0],...
    'Enable','On',...
    'Interruptible','on',...
	'Units','Normalized', ...
	'Position',[0.89 .59 .075 .06], ...
	'Callback','mtGUI start', ...
	'String','AUTO', ...
    'FontWeight','b',...
    'FontUnits','Points', ...
    'FontSize', 8);

h.manTrakButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
	'Position',[0.815 .54 .15 .05], ...
    'Enable', 'On', ...
	'Callback','manualDigitize allMarkers', ...
	'String','MANUAL', ...
    'FontWeight','b',...
    'FontUnits','Points', ...
    'FontSize', 8, ...
    'TooltipString','Manual tracking (with mouse) of all markers.');

h.back1Butn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
	'Position',[0.815 .48 .075 .06], ...
	'Callback', 'mtGUI back1', ...
	'String', '< BACK', ...
    'FontWeight', 'b',...
    'FontUnits', 'points', ...
    'FontSize', 8, ...
	'Tag','pbBack1');

h.fwd1Butn = uicontrol('Parent', figH, ...
    'Style', 'pushbutton', ...
	'Units', 'Normalized', ...
	'Position', [0.89 .48 .075 .06], ...
	'Callback', 'mtGUI forward1', ...
	'String', 'FRWD >', ...
    'FontWeight', 'b',...
    'FontUnits', 'points', ...
    'FontSize', 8, ...
	'Tag','pbFwd1');

h.eraserBox = uicontrol('Parent', figH, ...
    'Style', 'check', ...
    'Units', 'Normalized', ...
    'String', 'Eraser ON', ...
    'Position', [.815 .44 .1 .04], ...
    'CallBack', 'mtGUI toggleEraser', ...
    'Value', 0, ...
    'Max', 1, ...        
    'Min', 0, ...
    'FontUnits', 'Points', ...
    'FontWeight', 'b', ...
    'FontSize', 8);

h.invertBox = uicontrol('Parent', figH, ...
    'Style', 'check', ...
    'Units', 'Normalized', ...
    'String', 'Invert Image', ...
    'Position', [.89 .44 .075 .04], ...
    'CallBack', 'mtGUI toggleInverse', ...
    'Value', 0, ...
    'Max', 1, ...        
    'Min', 0, ...
    'FontUnits', 'Points', ...
    'FontWeight', 'b', ...
    'FontSize', 8);

%**************************************************************************


%Strobe controls
uicontrol('Parent', figH, ...
    'Style','text', ...
	'Units','Normalized', ...
	'Position',[0.815 .92 .075 .03], ...
	'String', 'Strobes:', ...
    'HorizontalAlignment', 'right', ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8);

h.strobesTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
	'Units','Normalized', ...
	'Position',[0.89 .92 .075 .03], ...
	'String', '0', ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8);

h.markStrobeButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.815 .89 .075 .03], ...
	'Callback','mtGUI toggleStrobe', ...
	'String', sprintf('OFF'), ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Click this button when strobe is visible!',...
	'Tag','pbMarkStrobe');

uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.6 .6 .6], ...
	'Position',[0.89 .89 .075 .03], ...
	'Callback','mtGUI locateStrobe', ...
	'String', 'Position', ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Use this button to adjust location of strobe in field of view');

%events buttons
uicontrol('Parent', figH, ...
    'Style','text', ...
	'Units','Normalized', ...
	'Position',[0.815 .85 .15 .03], ...
	'String', 'Step Events', ...
    'HorizontalAlignment', 'center', ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8);

h.event1Butn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.815 .82 .075 .03], ...
	'Callback','mtGUI toggleEvent1', ...
	'String', sprintf('LF'), ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Click this button when the Left Front foot touches the ground!');

h.event2Butn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.89 .82 .075 .03], ...
	'Callback','mtGUI toggleEvent2', ...
	'String', sprintf('RF'), ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Click this button when the Right Front foot touches the ground!');

h.event3Butn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.815 .79 .075 .03], ...
	'Callback','mtGUI toggleEvent3', ...
	'String', sprintf('LR'), ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Click this button when the Left Rear foot touches the ground!');

h.event4Butn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.89 .79 .075 .03], ...
	'Callback','mtGUI toggleEvent4', ...
	'String', sprintf('RR'), ...
    'FontWeight','b',...
    'FontUnits','Points',...
    'FontSize', 8,...
    'TooltipString','Click this button when the Right Rear foot touches the ground!');

%segment boundaries popup menu
uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
	'Units','Normalized', ...
	'Position',[0.815 .765 .05 .025], ...
	'String','Segments:', ...
    'HorizontalAlignment','Center',...
    'FontWeight', 'normal',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.segTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [1 1 1], ...
	'Units','Normalized', ...
	'Position',[0.865 .765 .025 .025], ...
	'String',' ', ...
    'HorizontalAlignment','Center',...
    'FontWeight', 'normal',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.segStartTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [1 1 1], ...
	'Units','Normalized', ...
	'Position',[0.895 .765 .03 .025], ...
	'String',' ', ...
    'HorizontalAlignment','right',...
    'FontWeight', 'normal',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.segStopTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
    'BackgroundColor', [1 1 1], ...
	'Units','Normalized', ...
	'Position',[0.925 .765 .035 .025], ...
	'String',' ', ...
    'HorizontalAlignment','left',...
    'FontWeight', 'normal',...
    'FontUnits', 'points',...
    'FontSize', 8);

h.segPopup = uicontrol('Parent', figH, ...
    'Style', 'popup',...
    'Units', 'Normalized', ...
    'String', 'Intermediate|Segment Start|Segment Stop|Clear current event|Clear ALL events',...
    'BackgroundColor', [.5 .5 .5], ...
	'Position',[0.815 .74 .15 .025], ...
    'Tooltipstring', 'Segment Boundaries: Select "Segment Start/Stop at the beginning/end of good motion segments',...
    'Callback', 'mtGUI setSegmentBounds');

%***************************************************************************************

%plot/review controls
bw = .06; bh = .05; fs = 8;

h.plotButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[0.815 .08 bw bh], ...
	'Callback','mtReviewTracking', ...
	'String','Review', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', fs);

h.reviewButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[0.875 .08 bw bh], ...
	'Callback','mtGUI makePlot', ...
	'String','Plot', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', fs);

h.nMarkersButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[0.935 .08 bw bh], ...
	'Callback','mtGUI setNmarkers', ...
	'String','N markers', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', fs);

h.saveFileButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[.815 .03 bw bh], ...
	'Callback','mtGUI saveFile', ...
	'String','SAVE', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', fs);

h.loadMatButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[.875 .03 bw bh], ...
	'Callback','mtGUI loadMatFile', ...
	'String','Load MAT', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', fs);

h.switchViewButn = uicontrol('Parent', figH, ...
    'Style','pushbutton', ...
	'Units','Normalized', ...
    'Enable','on', ...
	'Position',[.935 .03 bw bh], ...
	'Callback','mtGUI flipView', ...
    'String', '<-Flip DX->', ...
    'FontWeight','b',...
    'FontUnits','points', ...
    'FontSize', 8);
%	'String', sprintf('%s side', gv.side), ...

%*********************************************************
h.commentTxt = uicontrol('Parent', figH, ...
    'Style','text', ...
    'backgroundColor', [1 1 1],...
	'Units', 'Normalized', ...
	'Position', [0.815 .65 .15 .09], ...
	'String',  'Start by loading an .avi file', ...
    'FontWeight' ,'n',...
    'FontUnits', 'points',...
    'FontSize', 8);
