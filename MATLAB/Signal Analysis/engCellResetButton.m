disp('Reseting Cell Data...');
set(handles.cell_count_edit, 'String', '');
set(handles.cell_avg_dur_edit, 'String', '');
set(handles.cell_avg_per_edit, 'String', '');
set(handles.onset_diff_edit, 'String', '');
set(handles.offset_diff_edit, 'String', '');
time = getappdata(0, 'time');
cell = getappdata(0, 'cell');
axes(handles.axes3);
cla;
if (~isnan(cell))
    ce = cel(time, cell, NaN);
    ce.plotData;
end