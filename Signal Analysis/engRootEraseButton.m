threshold = str2double(get(handles.thresh_root_edit, 'String'));
handles.spike = getappdata(0, 'spike');
handles.trough = getappdata(0, 'trough');
handles.burst = getappdata(0, 'burst');
handles.percent = getappdata(0, 'percent');
guidata(hObject, handles);

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

engRootErase(hObject, handles, ro)
