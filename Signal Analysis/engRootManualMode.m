function engRootManualMode( hObject, handles, identity, mm, baseline)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    [x, y, button] = ginput(1);
    if (button == 2)
        disp('Manual Starting');
        engRootManualMode(hObject, handles, identity, mm, baseline);
    end
    if (button == 118)
        mm.addBurstOnset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    
    elseif (button == 98)
        mm.addBurstOffset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    
    elseif (isempty(button))
        try
            delete(handles.line);
        catch err
        end
        [duration, count] = mm.averageDuration;
        amp = mm.averageAmplitude(baseline);
        actualAmp = amp - baseline;
        handles.line = mm.plotAmplitude(amp);
        
        
        switch identity
            case 1
                set(handles.root1_count_edit, 'String', count);
                set(handles.root1_avg_dur_edit, 'String', duration);
                set(handles.root1_avg_per_edit, 'String', mm.averagePeriod);
                set(handles.root1_avg_amp_edit, 'String', actualAmp);
                [rootOnset1, rootOffset1] = mm.returnBurstInfo;
                handles.rootOnset1 = rootOnset1';
                handles.rootOffset1 = rootOffset1';
            case 2
                set(handles.root2_count_edit, 'String', count);
                set(handles.root2_avg_dur_edit, 'String', duration);
                set(handles.root2_avg_per_edit, 'String', mm.averagePeriod);
                set(handles.root2_avg_amp_edit, 'String', actualAmp);
                [rootOnset2, rootOffset2] = mm.returnBurstInfo;
                handles.rootOnset2 = rootOnset2';
                handles.rootOffset2 = rootOffset2';
        end
        guidata(hObject, handles);
    else
        disp('Manual Canceled');        
    end
end



