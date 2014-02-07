del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue' ,...
    '-or', 'Color', 'green', '-or', 'Marker', '>', '-or',...
    'Marker', '<');
delete(del_items);
mm = manualmode(handles.time, handles.root);
[x, y, button] = ginput(1);
axes(handles.axes2);
engRootManualMode(hObject, handles, mm, x, y, button);