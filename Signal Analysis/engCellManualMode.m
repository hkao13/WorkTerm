function engCellManualMode( hObject, handles, mm )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    [x, y, button] = ginput(1);
    if (button == 1)
        fprintf('Manual Starting.\n');
        engCellManualMode(hObject, handles, mm);
    end
    if (button == 118)
        mm.addBurstOnset(x, y);
        engCellManualMode(hObject, handles, mm);
    
    elseif (button == 98)
        mm.addBurstOffset(x, y);
        engCellManualMode(hObject, handles, mm);
    
    elseif (isempty(button))
        [handles.cellDuration, handles.cellCount] = mm.averageDuration;
        handles.cellPeriod = mm.averagePeriod;
        set(handles.cell_count_edit, 'String', handles.cellCount);
        set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
        set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
        [handles.cellOnset, handles.cellOffset] = mm.returnBurstInfo;
        guidata(hObject, handles);
    else
        fprintf('Manual Canceled.\n');
    end

end

