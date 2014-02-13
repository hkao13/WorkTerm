del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue' ,...
    '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
    'Marker', '<');
delete(del_items);
time = getappdata(0, 'time');
root2 = getappdata(0, 'root2');
mm2 = manualmode(time, root2);
[x, y, button] = ginput(1);
axes(handles.axes4);
engRootManualMode2(hObject, handles, mm2, x, y, button);