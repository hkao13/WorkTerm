function engRootManualMode( hObject, handles, mm1)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    [x, y, button] = ginput(1);
    if (button == 1)
        mm1.addBurstOnset(x, y);
        engRootManualMode(hObject, handles, mm1);
    end
    if (button == 3)
        mm1.addBurstOffset(x, y);
        engRootManualMode(hObject, handles, mm1);
    end
    if (isempty(button))
        [duration, count] = mm1.averageDuration;
        amp = mm1.averageAmplitude(handles.baseline1);
        actualAmp = amp - handles.baseline1;
        set(handles.root1_count_edit, 'String', count);
        set(handles.root1_avg_dur_edit, 'String', duration);
        set(handles.root1_avg_per_edit, 'String', mm1.averagePeriod);
        set(handles.root1_avg_amp_edit, 'String', actualAmp);
        mm1.plotAmplitude(amp);
        [handles.rootOnset1, handles.rootOffset1] = mm1.returnBurstInfo;
        guidata(hObject, handles);
    end

end



