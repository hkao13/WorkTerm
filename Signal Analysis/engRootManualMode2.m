function engRootManualMode2( hObject, handles, mm2)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    [x, y, button] = ginput(1);
    if (button == 1)
        mm2.addBurstOnset(x, y);
        engRootManualMode2(hObject, handles, mm2);
    end
    if (button == 3)
        mm2.addBurstOffset(x, y);
        engRootManualMode2(hObject, handles, mm2);
    end
    if (isempty(button))
        [duration, count] = mm2.averageDuration;
        amp = mm2.averageAmplitude(handles.baseline2);
        actualAmp = amp - handles.baseline2;
        set(handles.root2_count_edit, 'String', count);
        set(handles.root2_avg_dur_edit, 'String', duration);
        set(handles.root2_avg_per_edit, 'String', mm2.averagePeriod);
        set(handles.root2_avg_amp_edit, 'String', actualAmp);
        mm2.plotAmplitude(amp);
        [handles.rootOnset2, handles.rootOffset2] = mm2.returnBurstInfo;
        guidata(hObject, handles);
    end

end

