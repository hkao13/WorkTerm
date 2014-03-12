threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
time = getappdata(0, 'time');
root1 = getappdata(0, 'root1');
span = getappdata(0, 'span');
handles.spike = getappdata(0, 'spike');
handles.trough = getappdata(0, 'trough');
handles.burst = getappdata(0, 'burst');
handles.percent = getappdata(0, 'percent');
guidata(hObject, handles);
if ( isnan(threshold1) )
    set(handles.thresh_root1_edit, 'String', 'Please enter a value.')
else
    del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items);
    handles.spike = getappdata(0, 'spike');
    handles.trough = getappdata(0, 'trough');
    handles.burst = getappdata(0, 'burst');
    guidata(hObject, handles);
    axes(handles.axes2);
    ro1 = root(time, root1, threshold1);
    ro1.bandpass;
    ro1.filterData(span);
    ro1.aboveThreshold;
    ro1.isBurst(handles.spike, handles.trough, handles.burst);
    ro1.indexToTime;
    [duration, count] = ro1.averageDuration;
    period = ro1.averagePeriod;
    amp = ro1.averageAmplitude(handles.baseline1);
    actualAmp = amp - handles.baseline1;
    ro1.plotMarkers;
    root.plotAmplitude(amp);
    ro1.findDeletion(handles.percent, amp, period);
    set(handles.root1_count_edit, 'String', count);
    set(handles.root1_avg_dur_edit, 'String', duration);
    set(handles.root1_avg_per_edit, 'String', period);
    set(handles.root1_avg_amp_edit, 'String', actualAmp);

    handles.rootOnset1 = ro1.returnOnset;
    handles.rootOffset1 = ro1.returnOffset;
    guidata(hObject, handles);
end