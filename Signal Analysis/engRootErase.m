function engRootErase( hObject, handles, ro, ax, baseline, identity, percent )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[x, y, button] = ginput(1);
if (button == 1)
    del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
        '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
        'Marker', '<', '-or', 'Marker', 's');
    delete(del_items); 
    ro.deleteBurst(x);
    [duration, count] = ro.averageDuration;
    period = ro.averagePeriod;
    amp = ro.averageAmplitude(baseline);
    actualAmp = amp - baseline;
    ro.plotMarkers;
    root.plotAmplitude(amp);
    ro.findDeletion(percent, amp, period);
    switch identity
        case 1
            set(handles.root1_count_edit, 'String', count);
            set(handles.root1_avg_dur_edit, 'String', duration);
            set(handles.root1_avg_per_edit, 'String', period);
            set(handles.root1_avg_amp_edit, 'String', actualAmp);
            [handles.rootOnset1, handles.rootOffset1] = ro.returnBurstInfo;
        case 2
            set(handles.root2_count_edit, 'String', count);
            set(handles.root2_avg_dur_edit, 'String', duration);
            set(handles.root2_avg_per_edit, 'String', period);
            set(handles.root2_avg_amp_edit, 'String', actualAmp);
            [handles.rootOnset2, handles.rootOffset2] = ro.returnBurstInfo;
    end
    guidata(hObject, handles);
    engRootErase(hObject, handles, ro, ax, baseline, identity, percent);
end

end

