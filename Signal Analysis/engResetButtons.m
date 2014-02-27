switch identity
    case 0
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
        
    case 1
        disp('Reseting Root 1 Data');
        set(handles.baseline1_edit, 'String', '');
        set(handles.thresh_root1_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        set(handles.root1_avg_dur_edit, 'String', '');
        set(handles.root1_avg_per_edit, 'String', '');
        set(handles.root1_avg_amp_edit, 'String', '');
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        span = getappdata(0, 'span');
        time = getappdata(0, 'time');
        root1 = getappdata(0, 'root1');
        axes(handles.axes2);
        cla;
        if(~isnan(root1))
        ro1 = root(time, root1, threshold1);
        ro1.bandpass;
        ro1.filterData(span);
        ro1.plotData;
        end
        
    case 2
        disp('Reseting Root 2 Data');
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.baseline2_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        set(handles.root2_avg_dur_edit, 'String', '');
        set(handles.root2_avg_per_edit, 'String', '');
        set(handles.root2_avg_amp_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        span = getappdata(0, 'span');
        time = getappdata(0, 'time');
        root2 = getappdata(0, 'root2');
        axes(handles.axes4);
        cla;
        if(~isnan(root2))
        ro2 = root(time, root2, threshold2);
        ro2.bandpass;
        ro2.filterData(span);
        ro2.plotData
        end
end

warning OFF;
ax(1) = handles.axes2;
ax(2) = handles.axes3;
ax(4) = handles.axes4;
linkaxes(ax, 'x');