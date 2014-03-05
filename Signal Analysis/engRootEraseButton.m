switch identity
    case 1
        ax = handles.axes2;
        baseline = handles.baseline1;
        handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        time = handles.time;
        potential = handles.root1;
        span = handles.span;
        spike = handles.spike;
        trough = handles.trough;
        burst = handles.burst;
        percent = handles.percent;
        try
            mm = root(time, potential, handles.threshold1, handles.rootOnset1, handles.rootOffset1);
        catch err
            mm = root(time, potential, handles.threshold1);
            mm.bandpass;
            mm.filterData(span);
            mm.aboveThreshold;
            mm.isBurst(spike, trough, burst);
            mm.indexToTime;
        end

    case 2
        ax = handles.axes4;
        baseline = handles.baseline2;
        handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        time = handles.time;
        potential = handles.root2;
        span = handles.span;
        spike = handles.spike2;
        trough = handles.trough2;
        burst = handles.burst2;
        percent = handles.percent2;
        try
            mm = root(time, potential, handles.threshold2, handles.rootOnset2, handles.rootOffset2);
        catch err
            mm = root(time, potential, handles.threshold2);
            mm.bandpass;
            mm.filterData(span);
            mm.aboveThreshold;
            mm.isBurst(spike, trough, burst);
            mm.indexToTime;
        end
end

axes(ax);
engRootErase(hObject, handles, mm, ax, baseline, identity, percent)
