classdef manualmode < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time
        potential
        onsetRevised
        offsetRevised
        onsetDeletion
        offsetDeletion
        onYValue
        offYValue
        onStruct
        offStruct
        onCount = 0;
        offCount = 0;
    end
    
    methods (Static)
        
        function plotAmplitude(amp)
            hold on;
            line = refline (0, amp);
            set(line, 'Color', 'r')
            hold off;
        end
        
    end
    
    methods
        
        function MM = manualmode(time, potential)
            MM.time = time;
            MM.potential = potential;
        end

        function appendOnset(MM, onset, y)
            MM.onsetRevised(end + 1) = onset;
            MM.onYValue(end + 1) = y;
            MM.onCount = MM.onCount + 1;
        end
        
        function appendDeletionOnset (MM, onset)
            MM.onsetDeletion(end + 1) = onset;
        end
        
        function deleteOnset(MM)
            MM.onsetRevised(MM.onCount) = [];
            MM.onYValue(MM.onCount) = [];
            MM.onCount = MM.onCount - 1;
        end
        
        
        
        function appendOffset(MM, offset, y)
            MM.offsetRevised(end + 1) = offset;
            MM.offYValue(end + 1) = y;
            MM.offCount = MM.offCount + 1;
        end
        
        function deleteOffset(MM)
            MM.offsetRevised(MM.offCount) = [];
            MM.offYValue(MM.offCount) = [];
            MM.offCount = MM.offCount - 1;
        end
        
        function plotOnset(MM, x, y)
            hold on;
            on = plot(x, y, '>', 'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g');
            MM.onStruct(MM.onCount).onNumber = MM.onCount;
            MM.onStruct(MM.onCount).onValue = on;
            hold off;
        end
        
        function plotOffset(MM, x, y)
            hold on;
            off = plot(x, y, '<', 'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                 'MarkerFaceColor', 'r');
            MM.offStruct(MM.offCount).offNumber = MM.offCount;
            MM.offStruct(MM.offCount).offValue = off;
            hold off;
        end
        
        function deleteOnsetMarker(MM)
            hold on;
            delete(MM.onStruct(end).onValue);
            MM.onStruct(end) = [];
            hold off;
        end
        
        function deleteOffsetMarker(MM)
            hold on;
            delete(MM.offStruct(end).offValue);
            MM.offStruct(end) = [];
            hold off;
        end
        
        function [averageBurstDuration, count] = averageDuration(MM)
            try
                cumulativeBurstDuration = 0;
                count = 0;
                for i = 1:numel(MM.onsetRevised)
                    cumulativeBurstDuration = cumulativeBurstDuration +...
                        (MM.offsetRevised(i) - MM.onsetRevised(i));
                    count = count + 1;
                end
                averageBurstDuration = cumulativeBurstDuration / count;
            catch err
                disp (err);
                averageBurstDuration = 'ERROR';
            end
        end
        
        function averagePeriodDuration = averagePeriod(MM)
            try
                cumulativePeriodDuration = 0;
                count = 0;
                i = 1;
                while (i < numel(MM.onsetRevised))
                    cumulativePeriodDuration =...
                        cumulativePeriodDuration +...
                        MM.onsetRevised(i + 1) -...
                        MM.onsetRevised(i);
                    count = count + 1;
                    i = i + 1;
                end
                averagePeriodDuration = cumulativePeriodDuration / count;
            catch err
                disp(err);
                averagePeriodDuration = 'ERROR';
            end
        end
        
        function averageAmp = averageAmplitude(MM)
            maxValues = zeros(numel(MM.time):1);
            precision = 0.0001;
            for i = 1:numel(MM.onsetRevised)
                start = round2(MM.onsetRevised(i), precision);
                stop = round2(MM.offsetRevised(i), precision);
                roundTime = round2(MM.time, precision);
                values = abs(MM.potential...
                    (find(roundTime == start):find(roundTime == stop)));
                peak = mean(findpeaks(values, 'MINPEAKDISTANCE', 3));
                maxValues(i) = peak;
            end
            maxValues = maxValues(maxValues ~= 0);
            averageAmp = mean(maxValues);
        end
        
        function plotThreshold(MM)
            avgThreshold = mean([mean(MM.onYValue), mean(MM.offYValue)]);
            hold on;
            refline(0, avgThreshold);
            hold off;
        end
        
        function signalOnset = returnOnset (MM)
            signalOnset = MM.onsetRevised;
        end
    end
    

        

    
end

