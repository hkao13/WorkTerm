function engRootErase( hObject, handles, ro1 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[x, y, button] = ginput(1);
if (button == 1)
    del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items); 
    ro1.deleteBurst(x);
    [duration, count] = ro1.averageDuration;
    period = ro1.averagePeriod;
    amp = ro1.averageAmplitude(handles.baseline1);
    actualAmp = amp - handles.baseline1;
    ro1.plotMarkers;
    root.plotAmplitude(amp);
    ro1.findDeletion(handles.percent, amp, period);
    set(handles.root1_count_edit, 'String', count);
    set(handles.root1_avg_dur_edit, 'String', duration);
    set(handles.root1_avg_per_edit, 'String', period);
    set(handles.root1_avg_amp_edit, 'String', actualAmp);
    [handles.rootOnset1, handles.rootOffset1] = ro1.returnBurstInfo;
    guidata(hObject, handles);
    engRootErase(hObject, handles, ro1);
end

end

