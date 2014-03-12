switch identity
    
    case 1
        ax = handles.axes2;
        if (~isfield(handles, 'baseline1'))
            errordlg('Please select a baseline for Root 1.');
            return;
        else
            baseline = handles.baseline1;
        end
        handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root1');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike');
        trough      = getappdata(0, 'trough');
        burst       = getappdata(0, 'burst');
        percent     = getappdata(0, 'percent');
        if ( isnan(handles.threshold1) )
            fprintf('\nPlease enter a value into the threshold edit box, then press SET.\n');
        else
            ro = root(time, potential, handles.threshold1);
        end
                
    case 2
        ax = handles.axes4;
        if (~isfield(handles, 'baseline2'))
            errordlg('Please select a baseline for Root 2.');
            return;
        else
            baseline = handles.baseline2;
        end
        handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root2');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike2');
        trough      = getappdata(0, 'trough2');
        burst       = getappdata(0, 'burst2');
        percent     = getappdata(0, 'percent2');
        if ( isnan(handles.threshold2) )
            fprintf('\nPlease enter a value into the threshold edit box, then press SET.\n');
        else
            ro = root(time, potential, handles.threshold2);
        end
end

del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
    '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
    'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
delete(del_items);
axes(ax);
ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
ro.downsample(factor);
ro.filterData(span);
ro.aboveThreshold;
ro.isBurst(spike, trough, burst);

switch identity
    case 1
        [handles.root1Duration, handles.root1Count] = ro.averageDuration;
        handles.root1Period = ro.averagePeriod;
        amp = ro.averageAmplitude(baseline);
        handles.root1Amp = amp - baseline;
        ro.plotMarkers;
        handles.line1 = root.plotAmplitude(amp);
        ro.findDeletion(percent, amp, handles.root1Period);
        set(handles.root1_count_edit, 'String', handles.root1Count);
        set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
        set(handles.root1_avg_per_edit, 'String', handles.root1Period);
        set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
        [handles.rootOnset1, handles.rootOffset1] = ro.returnBurstInfo;
    
    case 2
        [handles.root2Duration, handles.root2Count] = ro.averageDuration;
        handles.root2Period = ro.averagePeriod;
        amp = ro.averageAmplitude(baseline);
        handles.root2Amp = amp - baseline;
        ro.plotMarkers;
        handles.line2 = root.plotAmplitude(amp);
        ro.findDeletion(percent, amp, handles.root2Period);
        set(handles.root2_count_edit, 'String', handles.root2Count);
        set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
        set(handles.root2_avg_per_edit, 'String', handles.root2Period);
        set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
        [handles.rootOnset2, handles.rootOffset2] = ro.returnBurstInfo;
end
guidata(hObject, handles);
