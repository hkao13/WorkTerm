[x, y, button] = ginput(1);
time = getappdata(0, 'time');
root1 = getappdata(0, 'root1');
span = getappdata(0, 'span');
handles.spike = getappdata(0, 'spike');
handles.trough = getappdata(0, 'trough');
handles.burst = getappdata(0, 'burst');
handles.percent = getappdata(0, 'percent');
guidata(hObject, handles);
if (button == 1)
    del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');

    delete(del_items);
    set(handles.thresh_root1_edit, 'String', y);
    threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
    axes(handles.axes2);
    ro = root(time, root1, threshold1);
    ro.bandpass;
    ro.filterData(span);
    ro.aboveThreshold;
    ro.isBurst(handles.spike, handles.trough, handles.burst);
    ro.indexToTime;
    [duration, count] = ro.averageDuration;
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(handles.baseline1);
    actualAmp = amp - handles.baseline1;
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(handles.percent, amp, period);
    set(handles.root1_count_edit, 'String', count);
    set(handles.root1_avg_dur_edit, 'String', ro.averageDuration);
    set(handles.root1_avg_per_edit, 'String', period);
    set(handles.root1_avg_amp_edit, 'String', actualAmp);
    handles.rootOnset1 = ro.returnOnset;
    handles.rootOffset1 = ro.returnOffset;
    guidata(hObject, handles);
    cursor_root1_button_Callback(hObject, eventdata, handles);
end