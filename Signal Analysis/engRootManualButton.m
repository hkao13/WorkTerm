del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue' ,...
    '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
    'Marker', '<');
delete(del_items);
time = getappdata(0, 'time');
root1 = getappdata(0, 'root1');
mm1 = manualmode(time, root1);
[x, y, button] = ginput(1);
axes(handles.axes2);
engRootManualMode(hObject, handles, mm1, x, y, button);