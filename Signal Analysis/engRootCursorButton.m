[x, y, button] = ginput(1);
if (button == 1)

    switch identity
        case 1
            ax = handles.axes2;
            baseline = handles.baseline1;
            time = handles.time;
            potential = handles.root1;
            span = handles.span;
            spike = handles.spike;
            trough = handles.trough;
            burst = handles.burst;
            percent = handles.percent;
            set(handles.thresh_root1_edit, 'String', y);
            handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
            ro = root(time, potential, handles.threshold1);
        
        case 2
            ax = handles.axes4;
            baseline = handles.baseline2;
            time = handles.time;
            potential = handles.root2;
            span = handles.span;
            spike = handles.spike2;
            trough = handles.trough2;
            burst = handles.burst2;
            percent = handles.percent2;
            set(handles.thresh_root2_edit, 'String', y);
            handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
            ro = root(time, potential, handles.threshold2);
    end
    del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items); 
    axes(ax); 
    ro.bandpass;
    ro.filterData(span);
    ro.aboveThreshold;
    ro.isBurst(spike, trough, burst);
    ro.indexToTime;

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
            cursor_root1_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
    
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
            cursor_root2_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
    end
end