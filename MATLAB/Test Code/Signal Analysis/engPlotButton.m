threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
span = getappdata(0, 'span');
guidata(hObject, handles);

time = getappdata(0, 'time');
cell = getappdata(0, 'cell');
root1 = getappdata(0, 'root1');
root2 = getappdata(0, 'root2');

axes(handles.axes3);
cla;
ce = cel(time, cell, NaN);
ce.plotData;

axes(handles.axes2);
cla;
ro1 = root(time, root1, threshold1);
ro1.bandpass;
ro1.filterData(span);
ro1.plotData;

axes(handles.axes4);
cla;
ro2 = root(time, root2, threshold2);
ro2.bandpass;
ro2.filterData(span);
ro2.plotData


warning OFF;
ax(1) = handles.axes2;
ax(2) = handles.axes3;
ax(4) = handles.axes4;
linkaxes(ax, 'x');



try
    handles = rmfield(handles, 'rootOnset1');
    handles = rmfield(handles, 'rootOffset1');
    guidata(hObject, handles);
catch err
end
