threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
handles.spike2 = getappdata(0, 'spike2');
handles.trough2 = getappdata(0, 'trough2');
handles.burst2 = getappdata(0, 'burst2');
handles.percent2 = getappdata(0, 'percent2');
time = getappdata(0, 'time');
root2 = getappdata(0, 'root2');
span = getappdata(0, 'span');
guidata(hObject, handles);

axes(handles.axes4);
try
    ro2 = root(time, root2, threshold2, handles.rootOnset2, handles.rootOffset2);
catch err
    ro2 = root(time, root2, threshold2);
    ro2.bandpass;
    ro2.filterData(span);
    ro2.aboveThreshold;
    ro2.isBurst(handles.spike2, handles.trough2, handles.burst2);
    ro2.indexToTime;
end
engRootErase2(hObject, handles, ro2)
