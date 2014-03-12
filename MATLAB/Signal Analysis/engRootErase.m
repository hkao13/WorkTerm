function engRootErase( hObject, handles, mm, ax, baseline, identity, percent )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[x, y, button] = ginput(1);
if (button == 1)
    del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
    delete(del_items); 
    mm.deleteBurst(x);
    
    switch identity
        case 0
            [handles.cellDuration, handles.cellCount] = mm.averageDuration;
            handles.cellPeriod = mm.averagePeriod;
            mm.plotMarkers;
            set(handles.cell_count_edit, 'String', handles.cellCount);
            set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
            set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
            [cellOnset, cellOffset] = mm.returnBurstInfo;
            handles.cellOnset = cellOnset;
            handles.cellOffset = cellOffset;
            guidata(hObject, handles);
        case 1
            [handles.root1Duration, handles.root1Count] = mm.averageDuration;
            amp = mm.averageAmplitude(baseline);
            handles.root1Period = mm.averagePeriod;
            handles.root1Amp = amp - baseline;
            mm.plotMarkers;
            handles.line1 = root.plotAmplitude(amp);
            mm.findDeletion(percent, amp, handles.root1Period);
            set(handles.root1_count_edit, 'String', handles.root1Count);
            set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
            set(handles.root1_avg_per_edit, 'String', handles.root1Period);
            set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
            [handles.rootOnset1, handles.rootOffset1] = mm.returnBurstInfo;
        case 2
            [handles.root2Duration, handles.root2Count] = mm.averageDuration;
            amp = mm.averageAmplitude(baseline);
            handles.root2Period = mm.averagePeriod;
            handles.root2Amp = amp - baseline;
            mm.plotMarkers;
            handles.line2 = root.plotAmplitude(amp);
            mm.findDeletion(percent, amp, handles.root2Period);
            set(handles.root2_count_edit, 'String', handles.root2Count);
            set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
            set(handles.root2_avg_per_edit, 'String', handles.root2Period);
            set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
            [handles.rootOnset2, handles.rootOffset2] = mm.returnBurstInfo;
    end
    guidata(hObject, handles);
    engRootErase(hObject, handles, mm, ax, baseline, identity, percent);
end

end

