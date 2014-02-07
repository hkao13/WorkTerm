del_items = findobj(handles.axes3, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
delete(del_items);
mm = manualmode(handles.time, handles.cell);
[x, y, button] = ginput(1);
axes(handles.axes3);
engCellManualMode( hObject, handles, mm, x, y, button );