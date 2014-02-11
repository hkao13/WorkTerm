function engRootErase( hObject, handles, ro )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[x, y, button] = ginput(1);
if (button == 1)
    del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items); 
    ro.deleteBurst(x);
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(handles.baseline);
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(handles.percent, amp, period);
    set(handles.root_avg_dur_edit, 'String', ro.averageDuration);
    set(handles.root_avg_per_edit, 'String', period);
    set(handles.root_avg_amp_edit, 'String', amp);
    handles.rootOnset = ro.returnOnset;
    guidata(hObject, handles);
    engRootErase(hObject, handles, ro);
end

end

