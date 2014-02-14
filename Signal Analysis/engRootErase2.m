function engRootErase2( hObject, handles, ro2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[x, y, button] = ginput(1);
if (button == 1)
    del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items); 
    ro2.deleteBurst(x);
    [duration, count] = ro2.averageDuration;
    period = ro2.averagePeriod;
    amp = ro2.averageAmplitude(handles.baseline2);
    actualAmp = amp - handles.baseline2;
    ro2.plotMarkers;
    root.plotAmplitude(amp);
    ro2.findDeletion(handles.percent, amp, period);
    set(handles.root2_count_edit, 'String', count);
    set(handles.root2_avg_dur_edit, 'String', duration);
    set(handles.root2_avg_per_edit, 'String', period);
    set(handles.root2_avg_amp_edit, 'String', actualAmp);
    [handles.rootOnset2, handles.rootOffset2] = ro2.returnBurstInfo;
    guidata(hObject, handles);
    engRootErase2(hObject, handles, ro2);
end

end

