time = getappdata(0, 'time');
cell = getappdata(0, 'cell');
mm = cel(time, cell, NaN);
axes(handles.axes3);
engCellManualMode( hObject, handles, mm );