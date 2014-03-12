clc;
disp('Initializing/Reseting Data');

handles = defaultHandles;

handles.filtOrder       = getappdata(0, 'filtOrder');
handles.sampFrequency   = getappdata(0, 'sampFrequency');
handles.passFrequency   = getappdata(0, 'passFrequency');
handles.cellSpike       = getappdata(0, 'cellSpike');
handles.cellTrough      = getappdata(0, 'cellTrough');
handles.cellBurst       = getappdata(0, 'cellBurst');
handles.spike           = getappdata(0, 'spike');
handles.trough          = getappdata(0, 'trough');
handles.burst           = getappdata(0, 'burst');
handles.percent         = getappdata(0, 'percent');
handles.spike2          = getappdata(0, 'spike2');
handles.trough2         = getappdata(0, 'trough2');
handles.burst2          = getappdata(0, 'burst2');
handles.percent2        = getappdata(0, 'percent2');
handles.span            = getappdata(0, 'span');
handles.factor          = getappdata(0, 'factor');
handles.time            = getappdata(0, 'time');
handles.cell            = getappdata(0, 'cell');
handles.root1           = getappdata(0, 'root1');
handles.root2           = getappdata(0, 'root2');

set(handles.baseline1_edit,     'String', '');
set(handles.thresh_root1_edit,  'String', '');
set(handles.root1_count_edit,   'String', '');
set(handles.root1_avg_dur_edit, 'String', '');
set(handles.root1_avg_per_edit, 'String', '');
set(handles.root1_avg_amp_edit, 'String', '');
set(handles.thresh_root2_edit,  'String', '');
set(handles.baseline2_edit,     'String', '');
set(handles.root2_count_edit,   'String', '');
set(handles.root2_avg_dur_edit, 'String', '');
set(handles.root2_avg_per_edit, 'String', '');
set(handles.root2_avg_amp_edit, 'String', '');
set(handles.root1_count_edit,   'String', '');
set(handles.root2_count_edit,   'String', '');
set(handles.thresh_cell_edit,   'String', '');
set(handles.cell_count_edit,    'String', '');
set(handles.cell_avg_dur_edit,  'String', '');
set(handles.cell_avg_per_edit,  'String', '');
set(handles.onset_diff_edit,    'String', '');
set(handles.offset_diff_edit,   'String', '');

threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
span = getappdata(0, 'span');
factor = getappdata(0, 'factor');

disp('Plotting Data...')

warning OFF;
ax(1) = handles.axes2;
ax(2) = handles.axes3;
ax(4) = handles.axes4;
linkaxes(ax, 'x');

axes(handles.axes3);
cla;
if (~isnan(handles.cell))
    ce = cel(handles.time, handles.cell, NaN);
    ce.plotData;
end

axes(handles.axes2);
cla;
if(~isnan(handles.root1))
    ro1 = root(handles.time, handles.root1, threshold1);
    ro1.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
    ro1.downsample(factor);
    ro1.filterData(span);
    ro1.plotData;
end

axes(handles.axes4);
cla;
if(~isnan(handles.root2))
    ro2 = root(handles.time, handles.root2, threshold2);
    ro2.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
    ro2.downsample(factor);
    ro2.filterData(span);
    ro2.plotData
end

disp('Plotting Finished')

try
    handles = rmfield(handles, 'rootOnset1');
    handles = rmfield(handles, 'rootOffset1');
    guidata(hObject, handles);
catch err
end

try
    handles = rmfield(handles, 'rootOnset2');
    handles = rmfield(handles, 'rootOffset2');
    guidata(hObject, handles);
catch err
end
guidata(hObject, handles);