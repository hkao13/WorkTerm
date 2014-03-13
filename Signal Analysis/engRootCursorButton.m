[x, y, button] = ginput(1);
if (button == 1)

    switch identity
        case 0
            ax = handles.axes3;
            time        = getappdata(0, 'time');
            potential   = getappdata(0, 'cell');
            spike       = getappdata(0, 'cellSpike');
            trough      = getappdata(0, 'cellTrough');
            burst       = getappdata(0, 'cellBurst');
            set(handles.thresh_cell_edit, 'String', y);
            handles.threshold0 = str2double(get(handles.thresh_cell_edit, 'String'));
            ce = cel(time, potential, handles.threshold0);
            axes(ax);
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items);
            ce.aboveThreshold
            ce.isBurst(spike, trough, burst);
            [handles.cellDuration, handles.cellCount] = ce.averageDuration;
            handles.cellPeriod = ce.averagePeriod;
            ce.plotMarkers;
            set(handles.cell_count_edit, 'String', handles.cellCount);
            set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
            set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
            [cellOnset, cellOffset] = ce.returnBurstInfo;
            handles.cellOnset = cellOnset';
            handles.cellOffset = cellOffset';
            cursor_cell_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
            
        case 1
            ax = handles.axes2;
            if (~isfield(handles, 'baseline1'))
                errordlg('Please select a baseline for Root 1.');
                return;
            else
                baseline = handles.baseline1;
            end
            time        = getappdata(0, 'time');
            potential   = getappdata(0, 'root1');
            span        = getappdata(0, 'span');
            factor      = getappdata(0, 'factor');
            spike       = getappdata(0, 'spike');
            trough      = getappdata(0, 'trough');
            burst       = getappdata(0, 'burst');
            percent     = getappdata(0, 'percent');
            set(handles.thresh_root1_edit, 'String', y);
            handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
            ro = root(time, potential, handles.threshold1);
            axes(ax);
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items); 
            ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
            ro.downsample(factor);
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            [handles.root1Duration, handles.root1Count] = ro.averageDuration;
            handles.root1Period = ro.averagePeriod;
            amp = ro.averageAmplitude(baseline);
            handles.root1Amp = amp - baseline;
            ro.plotMarkers;
            handles.line1 = root.plotAmplitude(amp);
            ro.findDeletion(percent, amp, handles.root1Period);
            set(handles.root1_count_edit, 'String', handles.root1Count);
            set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
            set(handles.root1_avg_per_edit, 'String', handles.root1Period);
            set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
            [rootOnset1, rootOffset1] = ro.returnBurstInfo;
            handles.rootOnset1 = rootOnset1';
            handles.rootOffset1 = rootOffset1';
            cursor_root1_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
            
        case 2
            ax = handles.axes4;
            if (~isfield(handles, 'baseline2'))
                errordlg('Please select a baseline for Root 2.');
                return;
            else
                baseline = handles.baseline2;
            end
            time        = getappdata(0, 'time');
            potential   = getappdata(0, 'root2');
            span        = getappdata(0, 'span');
            factor      = getappdata(0, 'factor');
            spike       = getappdata(0, 'spike2');
            trough      = getappdata(0, 'trough2');
            burst       = getappdata(0, 'burst2');
            percent     = getappdata(0, 'percent2');
            set(handles.thresh_root2_edit, 'String', y);
            handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
            ro = root(time, potential, handles.threshold2);
            axes(ax);
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items); 
            ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
            ro.downsample(factor);
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            [handles.root2Duration, handles.root2Count] = ro.averageDuration;
            handles.root2Period = ro.averagePeriod;
            amp = ro.averageAmplitude(baseline);
            handles.root2Amp = amp - baseline;
            ro.plotMarkers;
            handles.line2 = root.plotAmplitude(amp);
            ro.findDeletion(percent, amp, handles.root2Period);
            set(handles.root2_count_edit, 'String', handles.root2Count);
            set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
            set(handles.root2_avg_per_edit, 'String', handles.root2Period);
            set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
            [rootOnset2, rootOffset2] = ro.returnBurstInfo;
            handles.rootOnset2 = rootOnset2';
            handles.rootOffset2 = rootOffset2';
            cursor_root2_button_Callback(hObject, eventdata, handles);
            guidata(hObject, handles);
    end
end