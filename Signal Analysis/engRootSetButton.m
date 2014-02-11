threshold = str2double(get(handles.thresh_root_edit, 'String'));
handles.spike = getappdata(0, 'spike');
handles.trough = getappdata(0, 'trough');
handles.burst = getappdata(0, 'burst');
handles.percent = getappdata(0, 'percent');
guidata(hObject, handles);
if ( isnan(threshold) )
    set(handles.thresh_root_edit, 'String', 'Please enter a value.')
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
    ro = root(handles.time, handles.root, threshold);
    ro.bandpass;
    ro.filterData(handles.span);
    ro.aboveThreshold;
    ro.isBurst(handles.spike, handles.trough, handles.burst);
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(handles.baseline);
    actualAmp = amp - handles.baseline;
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(handles.percent, amp, period);
    
    set(handles.root_avg_dur_edit, 'String', ro.averageDuration);
    set(handles.root_avg_per_edit, 'String', period);
    set(handles.root_avg_amp_edit, 'String', actualAmp);

    handles.rootOnset = ro.returnOnset;
    guidata(hObject, handles);
end