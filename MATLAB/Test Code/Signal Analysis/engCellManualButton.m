time = getappdata(0, 'time');
cell = getappdata(0, 'cell');
del_items = findobj(handles.axes3, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
delete(del_items);
mm = manualmode(time, cell);
[x, y, button] = ginput(1);
axes(handles.axes3);
engCellManualMode( hObject, handles, mm, x, y, button );