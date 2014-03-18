classdef signalanalysis < handle
    % signalanaysis is the main class used in eng GUI. Obtains burst
    % information for the root and cel subclasses. Does calucaulation in
    % methods to return average durations, periods, and amplitudes. Can
    % find deletions in the data sets. Also is able to plot the data and
    % burst locations.
    %
    % signalanalysis extends the handles superclass.
    %
    % PROPERTIES ----------------------------------------------------------
    % NAME              TYPE            DESCRIPTION
    % time              double, []      Time data for the eng recording.
    % potential         double, []      Voltage data for the cell or root
    %                                     recordings.
    % potentialMod      double, []      Filtered, rectified and moving
    %                                     averaged data set of the
    %                                     potential data set.
    % threshold         double          Single value for the voltage
    %                                     threshold to find bursts.
    % onset             double, []      All indices of onsets of possible
    %                                     bursts above threshold.
    %                                     
    % offset            double, []      All indicies of offsets of possible 
    %                                     bursts above threshold.
    % onsetTimes        double, []      All points in the time data of
    %                                     burst onsets.
    % offsetTimes       double, []      All points in the time dsata of
    %                                     burst offsets.
    % maxValuesArray    double, []      Values of the amplitudes of the
    %                                     peaks of spikes in the bursts of 
    %                                     a data set.
    % onsetHandles      double, []      Array of handles of the
    %                                     manually plotted onsets.
    % offsetHandles     double, []      Array of handles of the
    %                                     manually plotted offsets.
    %
    % ---------------------------------------------------------------------
    %
    % METHODS -------------------------------------------------------------
    % NAME              DESCRIPTION
    % signalanalysis    Class constructor.
    % plotAmplitude     (Static), plots a horizontal line given a y-value
    %                     that represents the average amplitude.
    % aboveThreshold    Finds spikes in the data.
    % plotData          Plots time vs. potential.
    % plotMarkers       Plots markers for onsets and offsets.
    % averageDuration   Caluculates the average duration of all the bursts.
    % averagePeriod     Calculates the average period of all the bursts.
    % averageAmplitude  Calculates the average amplitude of all the bursts.
    % returnBurstInfo   Returns the onsetTimes and offsetTimes arrays.
    % findDeletions     Finds possibles deletions in the data.
    % deleteBurst       Deletes a whole burst.
    % addBurstOnset     Manually adds a burst onset.
    % addBurstOffset    Manually adds a burst offset.
    % deleteBurstMarker Deletes the last manually plotted burst onset or
    %                     offset.
    %
    % ---------------------------------------------------------------------
    
    properties (GetAccess = protected, SetAccess = protected)
        time
        potential
        potentialMod
        threshold
        onset
        offset
        onsetTimes
        offsetTimes  
        maxValuesArray
        onsetHandles = [];
        offsetHandles = [];
    end
    
    methods (Static)
        
        % Plots a horizontal line to represent the average amplitude.
        % @param amp: double value for the average amplitude.
        function line = plotAmplitude (amp)
            hold on;
            line = refline (0, amp);
            set(line, 'Color', 'r')
            hold off;
        end
        
    end
        
    methods
        
        % Class constructor or the signalanalysis class. 
        % @param time:          Time data set for the eng.
        % @param potential:     Voltages data set for the root reading of
        %                         the eng.
        % @param threshold:     Double value for a voltage level to detect
        %                         bursts.
        % @param onsetTimes:    An existing set of values of the times of
        %                         onsets.
        % @param offsetTimes:   An existing set of values of the times of
        %                         offsets.
        % @returns SA:          Class object.
        function SA = signalanalysis (time, potential, threshold, onsetTimes, offsetTimes)
       
            if (nargin == 3)
                SA.onsetTimes = [];
                SA.offsetTimes = [];
            else
                SA.onsetTimes = onsetTimes;
                SA.offsetTimes = offsetTimes;
            end
            SA.time = time;
            SA.potential = potential;
            SA.potentialMod = potential;
            SA.threshold = threshold;
        end
        
        % Finds spikes in ENG recording using the SA.threshold value.
        % @param SA:    The signalanalysis class object.
        % @modifies SA.onset
        % @modifies SA.offset
        function aboveThreshold (SA)
            aboveThreshold = (SA.potentialMod > SA.threshold); 
            edge = diff(aboveThreshold); %calculates difference between each index value
            SA.onset = find(edge == 1); %(0 -> 1) difference of +1 means onset of a spike
            SA.offset = find(edge == -1);  %(1 -> 0) difference of -1 means ofset of a spike
        end
        
        % Plots time vs. potenital data
        % @param SA:    The signalanalysis class object.
        % @modifies SA.potentialMod
        function plotData(SA)
            if isempty(SA.potentialMod)
                SA.potentialMod = SA.potential;
            end
            plot (SA.time, SA.potentialMod, 'Color', 'k');
            xlabel('Time (s)');
            ylabel('Voltage (mV)');
        end
        
        % Plots markers for burst onsets and offsets.
        % @param SA:    The signalanalysis class object.
        function plotMarkers (SA)
            hold on;
            refline(0, SA.threshold);
            plot(SA.onsetTimes, SA.threshold, '+',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g', 'LineWidth', 2);
            plot(SA.offsetTimes, SA.threshold, '+',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                'MarkerFaceColor', 'r', 'LineWidth', 2);
            hold off;
        end
        
        % Calculates the average duration of each burst. The duration of a
        % burst is measured from the onset to the offset of that burst.
        % @param SA:    The signalanalysis class object.
        % @returns averageBurstDuration:    Double value for the average
        %                                     duration.
        % @returns durationCount:           Number of bursts detected.
        function [averageBurstDuration, durationCount] = averageDuration(SA)
            burstDuration = SA.offsetTimes - SA.onsetTimes;
            averageBurstDuration = mean(burstDuration);
            durationCount = numel(burstDuration);
            
        end
        
        % Calculates the average period of bursts. Period is measure from
        % onse burst onset to the next consecutive burst onset.
        % @param SA:    The signalanalysis class object.
        % @returns averageBurstPeriod:    Double value for the average
        %                                     period.
        function averageBurstPeriod = averagePeriod(SA)
            averageBurstPeriod = mean(diff(SA.onsetTimes));
        end
        
        % Caluclates the average amplitude of all bursts in the data set.
        % Determines the maximum local peaks of each burst and takes the
        % mean of all peaks.
        % @param SA:            The signalanalysis class object.
        % @param baseline:      Double value acts as a reference value to
        %                         calculate the true average amplitude.
        %                         True amplitude = averageAmp - baseline.
        % @returns averageAmp:  Double value of the average amplitude of
        %                         the recording relative to 0.
        % @modifies SA.maxValuesArray
        function averageAmp = averageAmplitude(SA, baseline)
            maxValues = zeros(numel(SA.time):1);
            precision = 0.0001;
            for i = 1:numel(SA.onsetTimes)
                start = round2(SA.onsetTimes(i), precision);
                stop = round2(SA.offsetTimes(i), precision);
                roundTime = round2(SA.time, precision);
                value = abs(SA.potential...
                    (find(roundTime == start):find(roundTime == stop)));
                peak = mean(findpeaks(value, 'MINPEAKDISTANCE', 3));
                maxValues(i) = peak;  
            end
            maxValues = maxValues(maxValues ~= 0);
            SA.maxValuesArray = maxValues - baseline;
            averageAmp = mean(maxValues);
        end
        
        % Returns values for SA.onsetTimes and SA.offsetTimes to the user.
        % @param SA:            The signalanalysis class object.
        % @returns signalOnset:     Equal to SA.onsetTimes.
        % @returns signalOffset:    Equal to SA.offsetTimes.
        function [signalOnset, signalOffset] = returnBurstInfo(SA)
            signalOnset = SA.onsetTimes;
            signalOffset = SA.offsetTimes;
        end
        
        % Finds possible deletions in the eng recordings.
        % @param SA:            The signalanalysis class object.
        % @param percent:       Double value, maximum threshold for bursts
        %                         that are under percent*(average amplitude
        %                         of recording) to be identified as
        %                         deletions.
        % @param amp:           Double value. Is the average amplitude of
        %                         the recording that is reference from the 
        %                         baseline.
        % @param period:        Double values. Is that average period of
        %                         the burst in the recording.
        function [on, off] = findDeletion (SA, percent, amp, period)
            if (isnan(percent))
                percent = 0.50;
            else
                percent = percent / 100;
            end
            periodArray = diff(SA.onsetTimes);
            standardDev = std(periodArray);
            
            for i = 1:numel(SA.maxValuesArray)
                if (SA.maxValuesArray(i) < (percent * amp))
                    on = SA.onsetTimes(i);
                    off = SA.onsetTimes(i);
                    if (i == 1)
                        fprintf('Deletion at %f to %f,\nUnable to find deletion type\n',...
                            SA.onsetTimes(i), SA.offsetTimes(i))
                        hold on;
                        plot(SA.onsetTimes(i), SA.threshold, 's',...
                            'MarkerSize', 10, 'MarkerEdgeColor', 'g',...
                            'MarkerFaceColor', 'b');
                        plot(SA.offsetTimes(i), SA.threshold, 's',...
                            'MarkerSize', 10, 'MarkerEdgeColor', 'r',...
                            'MarkerFaceColor', 'b');
                        hold off;
                    else
                        difference = SA.onsetTimes(i) - SA.onsetTimes(i-1);
                        upperBound = period + standardDev;
                        lowerBound = period - standardDev;
                        if((difference > lowerBound) && (difference < upperBound))
                            fprintf ('\nDeletion at: %f to %f,\nNon-Reseting\n',...
                                SA.onsetTimes(i), SA.offsetTimes(i));
                            hold on;
                            plot(SA.onsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'g',...
                                'MarkerFaceColor', 'c');
                            plot(SA.offsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'r',...
                                'MarkerFaceColor', 'c');
                            hold off;
                        elseif((difference < lowerBound) || (difference > upperBound))
                            fprintf ('\nDeletion at: %f to %f,\nReseting\n',...
                                SA.onsetTimes(i), SA.offsetTimes(i));
                            hold on;
                            plot(SA.onsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'g',...
                                'MarkerFaceColor', 'y');
                            plot(SA.offsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'r',...
                                'MarkerFaceColor', 'y');
                            hold off;
                        end
                    end         
                end
            end
            
        end
        
        function deleteBurst(SA, x)
            onsetToDelete = x > SA.onsetTimes;
            offsetToDelete = x < SA.offsetTimes;
            ind1 = find(onsetToDelete, 1, 'last');
            ind2 = find(offsetToDelete, 1, 'first');
            SA.onsetTimes(ind1) = [];
            SA.offsetTimes(ind2) = [];
        end
        
        function addBurstOnset(SA, x, y)
            SA.onsetTimes(end+1) = x;
            SA.onsetTimes = sort(SA.onsetTimes, 'ascend');
            hold on;
            markerHandle = plot(x, y, '+',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g', 'LineWidth', 2);
            hold off;
            SA.onsetHandles(end+1) = markerHandle;
        end
        
        function addBurstOffset(SA, x, y)
            SA.offsetTimes(end+1) = x;
            SA.offsetTimes = sort(SA.offsetTimes, 'ascend');
            hold on;
            markerHandle = plot(x, y, '+',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                'MarkerFaceColor', 'r', 'LineWidth', 2);
            hold off;
            SA.offsetHandles(end+1) = markerHandle;
        end
        
        function deleteBurstMarker(SA, clickHistory)
            if (isempty(clickHistory))
                errordlg('No more markers to delete.');
            else
                clickHandle = clickHistory(end);
                if (mod(clickHandle, 2) == 0) %even for onsets
                    hold on;
                    delete(SA.onsetHandles(end));
                    hold off;
                    SA.onsetHandles(end) = [];
                    SA.onsetTimes(end) = [];
                elseif (mod(clickHandle, 2) == 1) %odd for offsets
                    hold on;
                    delete(SA.offsetHandles(end));
                    hold off;
                    SA.offsetHandles(end) = [];
                    SA.offsetTimes(end) = [];
                end
            end
        end
                
                
    end
    
end

