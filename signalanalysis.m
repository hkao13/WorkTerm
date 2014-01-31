classdef signalanalysis < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        time
        potential
        threshold
        onset
        offset
        onsetRevised
        offsetRevised
        averageBurstDuration
        averageBurstPeriod
        averageAmp
    end
    
    methods(Static)
        
        function map = collection(time, onsetRevised, offsetRevised)
            bursts = zeros(numel(onsetRevised):1);
            for i = 1:numel(onsetRevised)
                bursts(i).burstNumber = i;
                bursts(i).onset = time(onsetRevised(i));
                bursts(i).offset = time(offsetRevised(i));
            end
            map = bursts;
        end
    end
    
    methods
        
        function SA = signalanalysis (time, potential, threshold)
            SA.time = time;
            SA.potential = potential;
            SA.threshold = threshold;
        end
        
        function aboveThreshold (SA)
            aboveThreshold = (SA.potential > SA.threshold); 
            edge = diff(aboveThreshold); %calculates difference between each index value
            SA.onset = find(edge == 1); %(0 -> 1) difference of +1 means onset of a spike
            SA.offset = find(edge == -1);  %(1 -> 0) difference of -1 means ofset of a spike
        end
        
        function plotData(SA)
            hold on;
            plot (SA.time, SA.potential, 'Color', 'k');
            xlabel('Time (s)');
            ylabel('Voltage (mV)');
            hold off;
        end
        
        function plotMarkers (SA)
            hold on;
            refline(0, SA.threshold);
            plot(SA.time(SA.onsetRevised), SA.threshold, '>',...
                'MarkerSize', 8, 'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g');
             plot(SA.time(SA.offsetRevised), SA.threshold, '<',...
                 'MarkerSize', 8, 'MarkerEdgeColor', 'r',...
                 'MarkerFaceColor', 'r');
            hold off;
        end
        
        function plotAmplitude (SA)
            hold on;
            line = refline (0, SA.averageAmp);
            set(line, 'Color', 'r')
            hold off;
        end
        
        % calculates the average duration of each burst. The duration of a
        % burst is measured from the onset to the offset of that burst.
        function averageDuration (SA)
            cumulativeBurstDuration = 0;
            durationCount = 0;
            for i = 1:numel(SA.onsetRevised) 
                cumulativeBurstDuration = cumulativeBurstDuration +...
                    (SA.time(SA.offsetRevised(i)) -...
                    SA.time(SA.onsetRevised(i)));
                durationCount = durationCount + 1;
            end
            SA.averageBurstDuration =...
                cumulativeBurstDuration / durationCount;
        end
        
        function averagePeriod(SA)
            cumulativeBurstPeriod = 0;
            period_count = 0;
            for i = 1:numel(SA.onsetRevised)
                if ( i < numel(SA.onsetRevised) )
                    cumulativeBurstPeriod = cumulativeBurstPeriod +...
                        ( SA.time(SA.onsetRevised(i + 1)) -...
                        SA.time(SA.onsetRevised(i)) );
                    period_count = period_count + 1;
                end
            end
            SA.averageBurstPeriod =...
                cumulativeBurstPeriod / period_count; 
        end
        
        % caluclates the average amplitude of all bursts in the data set.
        % Determines the maximum local peaks of each burst and takes the
        % mean of all peaks.
        function averageAmplitude (SA)
            max_values = zeros(numel(SA.potential):1);
            precision = 0.0001;
            for i = 1:numel(SA.onsetRevised)
                start = round2(SA.time(SA.onsetRevised(i)), precision);
                stop = round2(SA.time(SA.offsetRevised(i)), precision);
                roundTime = round2(SA.time, precision);
                value = abs(SA.potential...
                    (find(roundTime == start):find(roundTime == stop)));
                peak = mean(findpeaks(value, 'MINPEAKDISTANCE', 3));
                max_values(i) = peak;  
            end
            max_values = max_values(max_values ~= 0);
            SA.averageAmp = mean(max_values);
        end
    end
    
end
