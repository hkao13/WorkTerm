time = getappdata(0, 'time');
root2 = getappdata(0, 'root2');
threshold2 = str2double(get(handles.thresh_root2_edit, 'String')); 
try
    mm2 = root(time, root2, threshold2, handles.rootOnset2, handles.rootOffset2);

catch err 
    mm2 = root(time, root2, threshold2);
end

axes(handles.axes4);
engRootManualMode2(hObject, handles, mm2);