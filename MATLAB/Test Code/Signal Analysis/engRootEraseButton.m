threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
handles.spike = getappdata(0, 'spike');
handles.trough = getappdata(0, 'trough');
handles.burst = getappdata(0, 'burst');
handles.percent = getappdata(0, 'percent');
time = getappdata(0, 'time');
root1 = getappdata(0, 'root1');
span = getappdata(0, 'span');
guidata(hObject, handles);

axes(handles.axes2);
try
    ro1 = root(time, root1, threshold1, handles.rootOnset1, handles.rootOffset1);
catch err
    ro1 = root(time, root1, threshold1);
    ro1.bandpass;
    ro1.filterData(span);
    ro1.aboveThreshold;
    ro1.isBurst(handles.spike, handles.trough, handles.burst);
    ro1.indexToTime;
end
engRootErase(hObject, handles, ro1)