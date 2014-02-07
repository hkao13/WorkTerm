function engRootManualMode( hObject, handles, mm, x, y, button )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if (button == 1)
    mm.appendOnset(x, y);
    mm.plotOnset(x, y);
end
 
    if (button == 3)
        mm.appendOffset(x, y);
        mm.plotOffset(x, y);
    end

    if (button == 8)
        try
            mm.deleteOnset;
            mm.deleteOnsetMarker;
            mm.deleteOffset;
            mm.deleteOffsetMarker;
        catch err
            disp(err);
        end
    end
    
    if (isempty(button))
        button = NaN;
        amp = mm.averageAmplitude;
        set(handles.root_avg_dur_edit, 'String', mm.averageDuration);
        set(handles.root_avg_per_edit, 'String', mm.averagePeriod);
        set(handles.root_avg_amp_edit, 'String', amp);
        mm.plotThreshold;
        mm.plotAmplitude(amp);
        handles.rootOnset = mm.returnOnset;
        guidata(hObject, handles);
        
    end
    
    if ((button == 1) || (button == 3) || (button == 8))
        [x, y, button] = ginput(1);
        engRootManualMode(hObject, handles, mm, x, y, button);
    end
end

