function engRootManualMode( hObject, handles, identity, mm, baseline)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    [x, y, button] = ginput(1);
    if (button == 1)
        mm.addBurstOnset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    end
    if (button == 3)
        mm.addBurstOffset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    end
    if (isempty(button))
        [duration, count] = mm.averageDuration;
        amp = mm.averageAmplitude(baseline);
        actualAmp = amp - baseline;
        mm.plotAmplitude(amp);
        
        
        switch identity
            case 1
                set(handles.root1_count_edit, 'String', count);
                set(handles.root1_avg_dur_edit, 'String', duration);
                set(handles.root1_avg_per_edit, 'String', mm.averagePeriod);
                set(handles.root1_avg_amp_edit, 'String', actualAmp);
                [handles.rootOnset1, handles.rootOffset1] = mm.returnBurstInfo;
            case 2
                set(handles.root2_count_edit, 'String', count);
                set(handles.root2_avg_dur_edit, 'String', duration);
                set(handles.root2_avg_per_edit, 'String', mm.averagePeriod);
                set(handles.root2_avg_amp_edit, 'String', actualAmp);
                [handles.rootOnset2, handles.rootOffset2] = mm.returnBurstInfo;

        end
        guidata(hObject, handles);
    end
end



