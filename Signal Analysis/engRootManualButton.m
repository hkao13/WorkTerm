switch identity
    case 1
        ax = handles.axes2;
        baseline = handles.baseline1;
        time = getappdata(0, 'time');
        potential = getappdata(0, 'root1');
        threshold = str2double(get(handles.thresh_root1_edit, 'String')); 
        try
            mm = root(time, potential, threshold, handles.rootOnset1, handles.rootOffset1);

        catch err 
            mm = root(time, potential, threshold);
        end

    case 2
        ax = handles.axes4;
        baseline = handles.baseline2;
        time = getappdata(0, 'time');
        potential = getappdata(0, 'root2');
        threshold = str2double(get(handles.thresh_root2_edit, 'String')); 
        try
            mm = root(time, potential, threshold, handles.rootOnset2, handles.rootOffset2);

        catch err 
            mm = root(time, potential, threshold);
        end
end

axes(ax);
engRootManualMode( hObject, handles, identity, mm, baseline);
