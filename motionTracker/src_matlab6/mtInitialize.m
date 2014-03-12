disp('Initializing motionTracker...');

if exist('controlH'),
    if isfield( controlH, 'fig'),
        if ishandle( controlH.fig ),
            close( controlH.fig );
            controlH = [];
        end
    end
end
if exist('guiH'),
    keep guiH;
else,
    clear all;
end

%mtInitialize;
global gv; %global variables structure contains tracking parameters
global trak; %file-specific variables for tracking
global guiH; %handles to main GUI controls
global controlH; %handles to configuration GUI controls

global curImage;
global fullImage;

global mTraj;
global captureFolder;
global captureFile;
global caldMarkers;

global RUNNING;

trak = [];
gv = [];
mTraj = [];
caldMarkers = [];

%STEP 0: initialize variables to default value
captureFolder = sprintf('%s\\', pwd);
captureFile = '*.avi';
RUNNING = 0;

trak.iFrame = 1;
trak.iKeyFrame = 1;
trak.iField = 1;
trak.strobes = [];
trak.method = 'matchDot';
trak.verbose = 'all';

caldMarkers = [];

labelList =  {'IC', 'Hip', 'Knee', 'Ankle', 'MTP', 'TipToe', ...
                'RefX','Ref0', 'RefY','Ref4', 'Ref5','Ref6', ...
                'Ref7','Ref8', 'Ref9','Ref10', 'Ref11','Ref12', ...
                'Ref13','Ref14', 'Ref15','Ref16', 'Ref17','Ref18'};
gv.nMarkers = [];
gv.side = 'Right';
gv.revInc = 1;

%default image size is 320 x 240
gv.nHp = 720; 
gv.nVp = 480;

%default location for sync strobe
gv.strobeBox = [1, 20, 1, 20]; 
gv.strobeSensitivity = .1;
gv.strobePolarity = -1;

%initialize vector of pixel color population, these numbers indicate the number of pixels in each
%color plane (red, green, blue) that are satuated 
gv.nBaseStrobeOn = [100 100 100];
gv.fpf = 1;
gv.sepFields = [];

%global variables for processing
gv.polyOrder = 2;
gv.polyPts = 8;
gv.predMode = 'Xpoly';
gv.refreshDelay = 0;
gv.videoFormat = 1;
