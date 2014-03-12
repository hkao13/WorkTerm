time = getappdata(0, 'time');
root1 = getappdata(0, 'root1');
threshold1 = str2double(get(handles.thresh_root1_edit, 'String')); 
try
    mm1 = root(time, root1, threshold1, handles.rootOnset1, handles.rootOffset1);

catch err 
    mm1 = root(time, root1, threshold1);
end

axes(handles.axes2);
engRootManualMode(hObject, handles, mm1);