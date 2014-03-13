switch identity
    case 0
        ax = handles.axes3;
        baseline = NaN;
        handles.threshold0 = str2double(get(handles.thresh_cell_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'cell');
        spike       = getappdata(0, 'cellSpike');
        trough      = getappdata(0, 'cellTrough');
        burst       = getappdata(0, 'cellBurst');
        percent = NaN;
        try
            mm = cel(time, potential, handles.threshold0, handles.cellOnset, handles.cellOffset);
        catch err
            errordlg('Nothing to erase.');
        end
    
    case 1
        ax = handles.axes2;
        baseline = handles.baseline1;
        handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root1');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike');
        trough      = getappdata(0, 'trough');
        burst       = getappdata(0, 'burst');
        percent     = getappdata(0, 'percent');
        try
            mm = root(time, potential, handles.threshold1, handles.rootOnset1, handles.rootOffset1);
        catch err
            errordlg('Nothing to erase.');
        end

    case 2
        ax = handles.axes4;
        baseline = handles.baseline2;
        handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root2');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike2');
        trough      = getappdata(0, 'trough2');
        burst       = getappdata(0, 'burst2');
        percent     = getappdata(0, 'percent2');
        try
            mm = root(time, potential, handles.threshold2, handles.rootOnset2, handles.rootOffset2);
        catch err
            errordlg('Nothing to erase.');
        end
end

axes(ax);
engRootErase(hObject, handles, mm, ax, baseline, identity, percent)
