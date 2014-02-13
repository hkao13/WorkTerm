function engRootManualMode( hObject, handles, mm1, x, y, button )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if (button == 1)
    mm1.appendOnset(x, y);
    mm1.plotOnset(x, y);
end
 
if (button == 3)
    mm1.appendOffset(x, y);
    mm1.plotOffset(x, y);
end
if (button == 8)
    try
        mm1.deleteOnset;
        mm1.deleteOnsetMarker;
        mm1.deleteOffset;
        mm1.deleteOffsetMarker;
    catch err
        disp(err);
    end
end

if (isempty(button))
    button = NaN;
    [duration, count] = mm1.averageDuration;
    amp = mm1.averageAmplitude;
    actualAmp = amp - handles.baseline1;
    set(handles.root1_count_edit, 'String', count);
    set(handles.root1_avg_dur_edit, 'String', duration);
    set(handles.root1_avg_per_edit, 'String', mm1.averagePeriod);
    set(handles.root1_avg_amp_edit, 'String', actualAmp);
    mm1.plotThreshold;
    mm1.plotAmplitude(amp);
    handles.rootOnset1 = mm1.returnOnset;
    guidata(hObject, handles);
end
    
if ((button == 1) || (button == 3) || (button == 8))
    [x, y, button] = ginput(1);
    engRootManualMode(hObject, handles, mm1, x, y, button);
end
end

