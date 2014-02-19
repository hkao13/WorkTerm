switch identity
    case 1
        ax = handles.axes2;
        baseline = handles.baseline1;
        threshold = str2double(get(handles.thresh_root1_edit, 'String'));
        spike = getappdata(0, 'spike');
        trough = getappdata(0, 'trough');
        burst = getappdata(0, 'burst');
        percent = getappdata(0, 'percent');
        time = getappdata(0, 'time');
        potential = getappdata(0, 'root1');
        span = getappdata(0, 'span');
        try
            ro = root(time, potential, threshold, handles.rootOnset1, handles.rootOffset1);
        catch err
            ro = root(time, potential, threshold);
            ro.bandpass;
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            ro.indexToTime;
        end

    case 2
        ax = handles.axes4;
        baseline = handles.baseline2;
        threshold = str2double(get(handles.thresh_root2_edit, 'String'));
        spike = getappdata(0, 'spike2');
        trough = getappdata(0, 'trough2');
        burst = getappdata(0, 'burst2');
        percent = getappdata(0, 'percent2');
        time = getappdata(0, 'time');
        potential = getappdata(0, 'root2');
        span = getappdata(0, 'span');
        try
            ro = root(time, potential, threshold, handles.rootOnset2, handles.rootOffset2);
        catch err
            ro = root(time, potential, threshold);
            ro.bandpass;
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            ro.indexToTime;
        end
end

axes(ax);
engRootErase(hObject, handles, ro, ax, baseline, identity, percent)
