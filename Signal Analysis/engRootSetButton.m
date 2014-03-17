% Switch block to determine which cursor button it was called from. 
% Case 0 ---> cell.
% Case 1 ---> root 1.
% Case 3 ---> root 2.
switch identity
    % Case 1 for root 1.
    case 1
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 1 object 
        % and operations to detect bursts.
        %--------------------------------------------------------------
        % Root 1 data on axes2 of the GUI.
        ax = handles.axes2;
        % Baseline for root 1 must exist before the program can
        % continue, otherwise an error dialouge box pops up to warn
        % user to select a baseline first.
        if (~isfield(handles, 'baseline1'))
            errordlg('Please select a baseline for Root 1.');
            return;
        else
            baseline = handles.baseline1;
        end
        % Gets the time, potential, threshold and the span, factor,
        % spike, trough, burst, percent settings.
        handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root1');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike');
        trough      = getappdata(0, 'trough');
        burst       = getappdata(0, 'burst');
        percent     = getappdata(0, 'percent');
        % If the value within the theshold edit box in root 1 panel is not
        % a number, will prompt to enter a threahold value, else it will
        % create the root object for burst detection.
        if ( isnan(handles.threshold1) )
            fprintf('\nPlease enter a value into the threshold edit box, then press SET.\n');
        else
            ro = root(time, potential, handles.threshold1);
        end
        
    % Case 2 for root 2.
    case 2
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 2 object 
        % and operations to detect bursts.
        %--------------------------------------------------------------
        % Root 2 data on axes4 of the GUI.
        ax = handles.axes4;
        % Baseline for root 2 must exist before the program can
        % continue, otherwise an error dialouge box pops up to warn
        % user to select a baseline first.
        if (~isfield(handles, 'baseline2'))
            errordlg('Please select a baseline for Root 2.');
            return;
        else
            baseline = handles.baseline2;
        end
        % Gets the time, potential, threshold and the span, factor,
        % spike, trough, burst, percent settings.
        handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        time        = getappdata(0, 'time');
        potential   = getappdata(0, 'root2');
        span        = getappdata(0, 'span');
        factor      = getappdata(0, 'factor');
        spike       = getappdata(0, 'spike2');
        trough      = getappdata(0, 'trough2');
        burst       = getappdata(0, 'burst2');
        percent     = getappdata(0, 'percent2');
        % If the value within the theshold edit box in root 2 panel is not
        % a number, will prompt to enter a threahold value, else it will
        % create the root object for burst detection.
        if ( isnan(handles.threshold2) )
            fprintf('\nPlease enter a value into the threshold edit box, then press SET.\n');
        else
            ro = root(time, potential, handles.threshold2);
        end
end

% -------------------------------------------------------------------------
% The following operation apply for both root 1 and root 2.
% -------------------------------------------------------------------------
% Clears the current axes by finding all object on the plot
% with the following prooperties and deletes them.
del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
    '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
    'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
delete(del_items);
axes(ax);
% Butterworth bandpass filters data bases on filter Order, sample frequency
% and passband frequency. Call the bandpass function from signalanalysis
% subclass root.
ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
% Downsamples data by a factor. Calls downsample method in the
% signalanalysis subclass root.
ro.downsample(factor);
% Applys the butterworth filter to the data, full-wave rectifies, and takes
% a moving average given a moving average span. Calls filterData method
% from signalanalysis subclass root.
ro.filterData(span);
% Begins bursts detection by finding all values above a threshold.
% aboveThreshold method in class signalanalysis.
ro.aboveThreshold;
% Detects bursts based on 3 different threshold parameters. isBurst method
% in signalanalysis class.
ro.isBurst(spike, trough, burst);

% Switch block to determine which cursor button it was called from. 
% Case 0 ---> cell.
% Case 1 ---> root 1.
% Case 3 ---> root 2.
switch identity
    
    % Case 1 for root 1.
    case 1
        % Gets burst duration and burst count from averageDuration
        % method in signalanalysis.
        [handles.root1Duration, handles.root1Count] = ro.averageDuration;
        % Gets burst period from averagePeriod method in
        % signalanalysis.
        handles.root1Period = ro.averagePeriod;
        % Gets amp value that is referenced from 0 from
        % averageAmplitude method in signalanalysis.
        amp = ro.averageAmplitude(baseline);
        % True amplitude is amp subtract baseline.
        handles.root1Amp = amp - baseline;
        % Plots markers for burst onsets and offsets. plotMarkers method in
        % signalanalysis.
        ro.plotMarkers;
        % Refreshes the amplitude graphics object in handles.
        handles.line1 = root.plotAmplitude(amp);
        % Searches for deletions given a percent threshold, amplitude of
        % the data, and average period of the data. findDeletion method in
        % signalanalysis class.
        ro.findDeletion(percent, amp, handles.root1Period);
        % Sets the edit boxes to display to result values.
        set(handles.root1_count_edit, 'String', handles.root1Count);
        set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
        set(handles.root1_avg_per_edit, 'String', handles.root1Period);
        set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
        % Creates or refreshes the *Onset and *Offset fields in the
        % handles structure of the GUI
        [handles.rootOnset1, handles.rootOffset1] = ro.returnBurstInfo;
    
    % Case 2 for root 2.
    case 2
        % Gets burst duration and burst count from averageDuration
        % method in signalanalysis.
        [handles.root2Duration, handles.root2Count] = ro.averageDuration;
        % Gets burst period from averagePeriod method in
        % signalanalysis.
        handles.root2Period = ro.averagePeriod;
        % Gets amp value that is referenced from 0 from
        % averageAmplitude method in signalanalysis.
        amp = ro.averageAmplitude(baseline);
        % True amplitude is amp subtract baseline
        handles.root2Amp = amp - baseline;
        % Plots markers for burst onsets and offsets. plotMarkers method in
        % signalanalysis
        ro.plotMarkers;
        % Refreshes the amplitude graphics object in handles.
        handles.line2 = root.plotAmplitude(amp);
        % Searches for deletions given a percent threshold, amplitude of
        % the data, and average period of the data. findDeletion method in
        % signalanalysis class.
        ro.findDeletion(percent, amp, handles.root2Period);
        % Sets the edit boxes to display to result values.
        set(handles.root2_count_edit, 'String', handles.root2Count);
        set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
        set(handles.root2_avg_per_edit, 'String', handles.root2Period);
        set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
        % Creates or refreshes the *Onset and *Offset fields in the
        % handles structure of the GUI
        [handles.rootOnset2, handles.rootOffset2] = ro.returnBurstInfo;
        
end

% Updates the GUI handles structure.
guidata(hObject, handles);
