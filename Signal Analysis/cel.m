classdef cel < signalanalysis
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function CE = cel(time, potential, threshold)
            CE = CE@signalanalysis(time, potential, threshold);
        end
        
        function isBurst (CE, spikeThreshold, troughThreshold,...
                burstThreshold)
            if (isnan(spikeThreshold))
                spikeThreshold = 0.01;
            end
            if (isnan(troughThreshold))
                troughThreshold = 0.5;
            end
            if (isnan(burstThreshold))
                burstThreshold = 0.005;
            end
            % preallocates arrays to determine which onsets and offsets to 
            % use for calculations.
            on = zeros(numel(CE.onset):1);
            off = zeros(numel(CE.offset):1);
            % if a spike above the threshold lasts more than the
            % SPIKE_THRESHOLD, adds to the [on], [off] array. 
            for i = 1:numel(CE.onset)
                if ( CE.time(CE.offset(i)) -...
                        CE.time(CE.onset(i)) > spikeThreshold )
                    on(i) = CE.onset(i);
                    off(i) = CE.offset(i);
                end
            end
            on = on(on ~= 0);
            off = off(off ~= 0);
            trough_on = zeros(numel(on):1);
            trough_off = zeros(numel(off):1);
            % determines all troughs that are less than the
            % TROUGH_THRESHOLD
            for j = 2:numel(on)
                if ( ((CE.time(on(j)) -...
                        CE.time(off(j-1))) < troughThreshold)...
                        && ( CE.time(on(j)) -...
                        CE.time(off(j-1)) > 0 ))
                    trough_on(j) = on(j);
                    trough_off(j) = off(j-1);
                end
            end
            trough_on = trough_on(trough_on ~= 0);
            trough_off = trough_off(trough_off ~= 0);
            % troughs that are less than the TROUGH_THRESHOLD are ignored
            % by removing them from the [on], [off], array.
            for k = 1:numel(trough_on)  
                on(on == trough_on(k)) = [];
                off(off == trough_off(k)) = [];
            end
            burst_on = zeros(numel(on):1);
            burst_off = zeros(numel(off):1);
            % determines single spikes that was considered to be a burst
            % from previous operations.
            for n = 1:numel(on)
                if ( (CE.time(off(n)) -...
                        CE.time(on(n))) < burstThreshold )
                    burst_on(n) = on(n);
                    burst_off(n) = off(n);
                end
            end
            burst_on = burst_on(burst_on ~= 0);
            burst_off = burst_off(burst_off ~= 0);
            % removes the single spikes from the [on], [off] arrays.
            for m = 1:numel(burst_on);
                on(on == burst_on(m)) = [];
                off(off == burst_off(m)) = [];
            end
            CE.onsetRevised = on;
            CE.offsetRevised = off;
        end
        
        % removes unwanted bursts that are considered as noise from the
        % onset of offset data sets.
        function removeBurst (CE, index)
            CE.onsetRevised(index) = [];
            CE.offsetRevised(index) = [];
        end
    end
    
end

