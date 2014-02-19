[x, y, button] = ginput(1);
time = getappdata(0, 'time');
root2 = getappdata(0, 'root2');
span = getappdata(0, 'span');
handles.spike2 = getappdata(0, 'spike2');
handles.trough2 = getappdata(0, 'trough2');
handles.burst2 = getappdata(0, 'burst2');
handles.percent2 = getappdata(0, 'percent2');
if (button == 1)
    del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');

    delete(del_items);
    set(handles.thresh_root2_edit, 'String', y);
    threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
    axes(handles.axes4);
    ro = root(time, root2, threshold2);
    ro.bandpass;
    ro.filterData(span);
    ro.aboveThreshold;
    ro.isBurst(handles.spike2, handles.trough2, handles.burst2);
    ro.indexToTime;
    [duration, count] = ro.averageDuration;
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(handles.baseline2);
    actualAmp = amp - handles.baseline2;
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(handles.percent2, amp, period);
    set(handles.root2_count_edit, 'String', count);
    set(handles.root2_avg_dur_edit, 'String', duration);
    set(handles.root2_avg_per_edit, 'String', period);
    set(handles.root2_avg_amp_edit, 'String', actualAmp);
    [handles.rootOnset2, handles.rootOffset2] = ro.returnBurstInfo;
    guidata(hObject, handles);
    cursor_root2_button_Callback(hObject, eventdata, handles);
end