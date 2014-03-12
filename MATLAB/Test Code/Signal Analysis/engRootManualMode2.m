function engRootManualMode2( hObject, handles, mm2, x, y, button )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if (button == 1)
    mm2.appendOnset(x, y);
    mm2.plotOnset(x, y);
end
 
if (button == 3)
    mm2.appendOffset(x, y);
    mm2.plotOffset(x, y);
end
if (button == 8)
    try
        mm2.deleteOnset;
        mm2.deleteOnsetMarker;
        mm2.deleteOffset;
        mm2.deleteOffsetMarker;
    catch err
        disp(err);
    end
end

if (isempty(button))
    button = NaN;
    amp = mm2.averageAmplitude;
    actualAmp = amp - handles.baseline2;
    [duration, count] = mm2.averageDuration;
    set(handles.root2_count_edit, 'String', count);
    set(handles.root2_avg_dur_edit, 'String', duration);
    set(handles.root2_avg_per_edit, 'String', mm2.averagePeriod);
    set(handles.root2_avg_amp_edit, 'String', actualAmp);
    mm2.plotThreshold;
    mm2.plotAmplitude(amp);
    handles.rootOnset2 = mm2.returnOnset;
    guidata(hObject, handles);
end
    
if ((button == 1) || (button == 3) || (button == 8))
    [x, y, button] = ginput(1);
    engRootManualMode2(hObject, handles, mm2, x, y, button);
end
end

