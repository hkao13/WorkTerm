try
    mm = cel(handles.time, handles.cell, NaN, handles.cellOnset, handles.cellOffset);
catch err
    mm = cel(handles.time, handles.cell, NaN);
end
axes(handles.axes3);
engCellManualMode( hObject, handles, mm );
