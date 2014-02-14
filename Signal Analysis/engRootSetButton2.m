threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
time = getappdata(0, 'time');
root2 = getappdata(0, 'root2');
span = getappdata(0, 'span');
handles.spike2 = getappdata(0, 'spike2');
handles.trough2 = getappdata(0, 'trough2');
handles.burst2 = getappdata(0, 'burst2');
handles.percent2 = getappdata(0, 'percent2');
guidata(hObject, handles);
if ( isnan(threshold2) )
    set(handles.thresh_root2_edit, 'String', 'Please enter a value.')
else
    del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items);
    handles.spike2 = getappdata(0, 'spike2');
    handles.trough2 = getappdata(0, 'trough2');
    handles.burst2 = getappdata(0, 'burst2');
    guidata(hObject, handles);
    axes(handles.axes4);
    ro2 = root(time, root2, threshold2);
    ro2.bandpass;
    ro2.filterData(span);
    ro2.aboveThreshold;
    ro2.isBurst(handles.spike2, handles.trough2, handles.burst2);
    ro2.indexToTime;
    [duration, count] = ro2.averageDuration;
    period = ro2.averagePeriod;
    amp = ro2.averageAmplitude(handles.baseline2);
    actualAmp = amp - handles.baseline2;
    ro2.plotMarkers;
    root.plotAmplitude(amp);
    ro2.findDeletion(handles.percent, amp, period);
    set(handles.root2_count_edit, 'String', count);
    set(handles.root2_avg_dur_edit, 'String', duration);
    set(handles.root2_avg_per_edit, 'String', period);
    set(handles.root2_avg_amp_edit, 'String', actualAmp);

    [handles.rootOnset2, handles.rootOffset2] = ro2.returnBurstInfo;
    guidata(hObject, handles);
end