function engRootManualMode( hObject, handles, identity, mm, baseline)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    [x, y, button] = ginput(1);
    if (button == 1)
        fprintf('Manual Starting.\n');
        engRootManualMode(hObject, handles, identity, mm, baseline);
    end
    if (button == 118)
        mm.addBurstOnset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    
    elseif (button == 98)
        mm.addBurstOffset(x, y);
        engRootManualMode(hObject, handles, identity, mm, baseline);
    
    elseif (isempty(button))
                
        switch identity
            case 1
                try
                    delete(handles.line1);
                catch err
                end
                [handles.root1Duration, handles.root1Count] = mm.averageDuration;
                amp = mm.averageAmplitude(baseline);
                handles.root1Period = mm.averagePeriod;
                handles.root1Amp = amp - baseline;
                handles.line1 = mm.plotAmplitude(amp);
                set(handles.root1_count_edit, 'String', handles.root1Count);
                set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
                set(handles.root1_avg_per_edit, 'String', handles.root1Period);
                set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
                [rootOnset1, rootOffset1] = mm.returnBurstInfo;
                handles.rootOnset1 = rootOnset1';
                handles.rootOffset1 = rootOffset1';
            case 2
                try
                    delete(handles.line2);
                catch err
                end
                [handles.root2Duration, handles.root2Count] = mm.averageDuration;
                amp = mm.averageAmplitude(baseline);
                handles.root2Period = mm.averagePeriod;
                handles.root2Amp = amp - baseline;
                handles.line2 = mm.plotAmplitude(amp);
                set(handles.root2_count_edit, 'String', handles.root2Count);
                set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
                set(handles.root2_avg_per_edit, 'String', handles.root2Period);
                set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
                [rootOnset2, rootOffset2] = mm.returnBurstInfo;
                handles.rootOnset2 = rootOnset2';
                handles.rootOffset2 = rootOffset2';
        end
        guidata(hObject, handles);
    else
        fprintf('Manual Canceled.\n');        
    end
end



