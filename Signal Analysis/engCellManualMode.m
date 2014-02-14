function engCellManualMode( hObject, handles, mm )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    [x, y, button] = ginput(1);
    if (button == 1)
        mm.addBurstOnset(x, y);
        engCellManualMode(hObject, handles, mm);
    end
    if (button == 3)
        mm.addBurstOffset(x, y);
        engCellManualMode(hObject, handles, mm);
    end
    if (isempty(button))
        [duration, count] = mm.averageDuration;
        set(handles.cell_count_edit, 'String', count);
        set(handles.cell_avg_dur_edit, 'String', duration);
        set(handles.cell_avg_per_edit, 'String', mm.averagePeriod);
        [handles.cellOnset, handles.cellOffset] = mm.returnBurstInfo;
        guidata(hObject, handles);
    end

end

