[x, y, button] = ginput(1);
if (button == 1)

    switch identity
        case 1
            ax = handles.axes2;
            baseline = handles.baseline1;
            time = getappdata(0, 'time');
            potential = getappdata(0, 'root1');
            span = getappdata(0, 'span');
            spike = getappdata(0, 'spike');
            trough = getappdata(0, 'trough');
            burst = getappdata(0, 'burst');
            percent = getappdata(0, 'percent');
            set(handles.thresh_root1_edit, 'String', y);
            threshold = str2double(get(handles.thresh_root1_edit, 'String'));
            ro = root(time, potential, threshold);
        
        case 2
            ax = handles.axes4;
            baseline = handles.baseline2;
            time = getappdata(0, 'time');
            potential = getappdata(0, 'root2');
            span = getappdata(0, 'span');
            spike = getappdata(0, 'spike2');
            trough = getappdata(0, 'trough2');
            burst = getappdata(0, 'burst2');
            percent = getappdata(0, 'percent2');
            set(handles.thresh_root2_edit, 'String', y);
            threshold = str2double(get(handles.thresh_root2_edit, 'String'));
            ro = root(time, potential, threshold);
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
    [duration, count] = ro.averageDuration;
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(baseline);
    actualAmp = amp - baseline;
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(percent, amp, period);
    
    switch identity
        case 1
            set(handles.root1_count_edit, 'String', count);
            set(handles.root1_avg_dur_edit, 'String', duration);
            set(handles.root1_avg_per_edit, 'String', period);
            set(handles.root1_avg_amp_edit, 'String', actualAmp);
            [handles.rootOnset1, handles.rootOffset1] = ro.returnBurstInfo;
            cursor_root1_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
    
        case 2
            set(handles.root2_count_edit, 'String', count);
            set(handles.root2_avg_dur_edit, 'String', duration);
            set(handles.root2_avg_per_edit, 'String', period);
            set(handles.root2_avg_amp_edit, 'String', actualAmp);
            [handles.rootOnset2, handles.rootOffset2] = ro.returnBurstInfo;
            cursor_root2_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
    end
    
    
end