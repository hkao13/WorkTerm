classdef signalanalysis < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = protected, SetAccess = protected)
        time
        potential
        potentialMod
        threshold
        onset
        offset
        onsetTimes
        offsetTimes
        onsetRevised
        offsetRevised  
        maxValuesArray
    end
    
    methods (Static)
        
        function line = plotAmplitude (amp)
            hold on;
            line = refline (0, amp);
            set(line, 'Color', 'r')
            hold off;
        end
        
    end
        
    methods
        
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
            SA.threshold = threshold;
        end
        
        function aboveThreshold (SA)
            aboveThreshold = (SA.potentialMod > SA.threshold); 
            edge = diff(aboveThreshold); %calculates difference between each index value
            SA.onset = find(edge == 1); %(0 -> 1) difference of +1 means onset of a spike
            SA.offset = find(edge == -1);  %(1 -> 0) difference of -1 means ofset of a spike
        end
        
        function indexToTime(SA)
            SA.onsetTimes = SA.time(SA.onsetRevised(1,:));
            SA.offsetTimes = SA.time(SA.offsetRevised(1,:));
        end
        
        function plotData(SA)
            if isempty(SA.potentialMod)
                SA.potentialMod = SA.potential;
            end
            %hold on;
            plot (SA.time, SA.potentialMod, 'Color', 'k');
            xlabel('Time (s)');
            ylabel('Voltage (mV)');
            %hold off;
        end
        
        function plotMarkers (SA)
            hold on;
            refline(0, SA.threshold);
            plot(SA.onsetTimes, SA.threshold, '>',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g');
            plot(SA.offsetTimes, SA.threshold, '<',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                'MarkerFaceColor', 'r');
            hold off;
        end
        
        % calculates the average duration of each burst. The duration of a
        % burst is measured from the onset to the offset of that burst.
        function [averageBurstDuration, durationCount] = averageDuration(SA)
            burstDuration = SA.offsetTimes - SA.onsetTimes;
            averageBurstDuration = mean(burstDuration);
            durationCount = numel(burstDuration);
            
        end
        
        function averageBurstPeriod = averagePeriod(SA)
            averageBurstPeriod = mean(diff(SA.onsetTimes));
        end
        
        % caluclates the average amplitude of all bursts in the data set.
        % Determines the maximum local peaks of each burst and takes the
        % mean of all peaks.
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
        
        function [signalOnset, signalOffset] = returnBurstInfo(SA)
            signalOnset = SA.onsetTimes;
            signalOffset = SA.offsetTimes;
        end
        
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
                        fprintf('Deletion at %f to %f,\nUnable to find deletion type\n', SA.onsetTimes(i), SA.offsetTimes(i))
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
                            fprintf ('\nDeletion at: %f to %f,\nNon-Reseting\n', SA.onsetTimes(i), SA.offsetTimes(i));
                            hold on;
                            plot(SA.onsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'g',...
                                'MarkerFaceColor', 'c');
                            plot(SA.offsetTimes(i), SA.threshold, 's',...
                                'MarkerSize', 10, 'MarkerEdgeColor', 'r',...
                                'MarkerFaceColor', 'c');
                            hold off;
                        elseif((difference < lowerBound) || (difference > upperBound))
                            fprintf ('\nDeletion at: %f to %f,\nReseting\n', SA.onsetTimes(i), SA.offsetTimes(i));
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
            plot(x, y, '>',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g');
            hold off;
            
        end
        
        function addBurstOffset(SA, x, y)
            SA.offsetTimes(end+1) = x;
            SA.offsetTimes = sort(SA.offsetTimes, 'ascend');
            hold on;
            plot(x, y, '<',...
                 'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                 'MarkerFaceColor', 'r');
             hold off;
        end
    end
    
end

