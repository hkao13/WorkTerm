switch identity
    case 0
        ax = handles.axes3;
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'cell');
        threshold   = NaN;
        baseline    = NaN;
        try
            mm = cel(time, potential, threshold, handles.cellOnset, handles.cellOffset);
        catch err
            mm = cel(time, potential, threshold);
        end
        
    case 1
        ax = handles.axes2;
        if (~isfield(handles, 'baseline1'))
            errordlg('Please select a baseline for Root 1.');
            return;
        else
            baseline = handles.baseline1;
        end
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root1');
        threshold = str2double(get(handles.thresh_root1_edit, 'String')); 
        try
            mm = root(time, potential, threshold, handles.rootOnset1, handles.rootOffset1);
        catch err 
            mm = root(time, potential, threshold);
        end

    case 2
        ax = handles.axes4;
        if (~isfield(handles, 'baseline2'))
           errordlg('Please select a baseline for Root 2.');
           return;
        else
            baseline = handles.baseline2;
        end
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root2');
        threshold = str2double(get(handles.thresh_root2_edit, 'String')); 
        try
            mm = root(time, potential, threshold, handles.rootOnset2, handles.rootOffset2);
        catch err 
            mm = root(time, potential, threshold);
        end
end
evenHandle = 0;
oddHandle = 1;
clickHistory = [];
axes(ax);
engRootManualMode( hObject, handles, identity, mm, baseline, clickHistory, evenHandle, oddHandle);
