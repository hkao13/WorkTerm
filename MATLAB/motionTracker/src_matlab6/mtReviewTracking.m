function mtReviewTracking;
% mtAutoTracker;
% by: Doug Weber
% last edit: 11/27/2004
% location: motionTracker toolbox
% purpose: function that loops through frames to review tracking; also
% provides option to generate video of tracking

global gv;
global trak;
global guiH;
global RUNNING;
global captureFile;
global curImage;

%Rewind to beginning of file?
yesNo = questdlg('Would you like to rewind the file to the beginning?', 'Rewind', 'Yes','No','Yes');
if strcmp(yesNo, 'Yes'),
    trak.iFrame = 0;
end

%make video?
MAKEMOVIE = questdlg('Would you like to record a video of the tracking?', 'Make a movie?', 'Yes', 'No', 'Yes');
if strcmp(MAKEMOVIE, 'Yes'),
    if exist('aviobj'),
        if ~isempty(aviobj),
            if strcmp(aviobj.CurrentState, 'Open'),
                aviobj = close(aviobj);
            end;
        end
    end
    [filename, pathname] = uiputfile('*.avi', 'Save Tracking video as?');
    aviobj=avifile(sprintf('%s%s', pathname, filename), ...
        'compression', 'Indeo5', 'fps', gv.fps);
end

RUNNING = 1;
set(guiH.stopButn, 'Enable','On');

while (trak.iFrame < trak.nF*gv.fpf) & (RUNNING == 1),
    %update instructional comment
    set(guiH.commentTxt,'String','Click "STOP" to halt playback');
    trak.iFrame = trak.iFrame + 1;
    trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
    trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;    
    mtGUI('updateDisplay');

    if strcmp(MAKEMOVIE, 'Yes'),
        set(guiH.ax, 'DataAspectRatio',[1 1 1]);
        m = getframe(guiH.ax);
        aviobj = addframe(aviobj, m);
    end
    
    %abort tracking at last frame
    if trak.iFrame == trak.nF*gv.fpf,
        msgbox('END OF FILE');
        RUNNING == 0;
    end
    pause(.001);
    
end
mtGUI('stop');

if exist('aviobj'),
    if ~isempty(aviobj),
        if strcmp(aviobj.CurrentState, 'Open'),
            aviobj = close(aviobj);
        end;
    end
end



