classdef root < signalanalysis
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        b
        a
    end
    
    properties (Constant)
        FILTER_ORDER = 2; % order of the filter
        FREQ_SAMPLE = 10000; % sample frequency (Hz)
        FREQ_PASS = [100, 1000]; % passband frequency (Hz)
    end
    
    methods
        function RO = root(time, potential, threshold)
            RO = RO@signalanalysis(time, potential, threshold);
        end
        
        function bandpass (RO)
            freqNorm = 2*RO.FREQ_PASS / RO.FREQ_SAMPLE;%normalized passband
            [RO.b, RO.a] = butter(RO.FILTER_ORDER, freqNorm, 'bandpass');
        end
        
        function filterData (RO, window)
            if (isnan(window))
                window = 511;
            else
                window = window * (10^4);
            end
            filtPoten = filtfilt(RO.b, RO.a, RO.potential);%filters the ENG
            absFiltPoten = abs(filtPoten);%rectifies filtered ENG
            RO.potential = smooth(absFiltPoten, window, 'moving');
        end
                
        function isBurst (RO, spikeThreshold, troughThreshold,...
                burstThreshold)
            if (isnan(spikeThreshold))
                spikeThreshold = 0.05;
            end
            if (isnan(troughThreshold))
                troughThreshold = 0.105;
            end
            if (isnan(burstThreshold))
                burstThreshold = 0.7;
            end
            % preallocates arrays to determine which onsets and offsets to 
            % use for calculations.
            on = zeros(numel(RO.onset):1);
            off = zeros(numel(RO.offset):1);
            % if a spike above the threshold lasts more than the
            % SPIKE_THRESHOLD, adds to the [on], [off] array. 
            for i = 1:numel(RO.onset)
                if ( RO.time(RO.offset(i)) -...
                        RO.time(RO.onset(i)) > spikeThreshold )
                    on(i) = RO.onset(i);
                    off(i) = RO.offset(i);
                end
            end
            on = on(on ~= 0);
            off = off(off ~= 0);
            trough_on = zeros(numel(on):1);
            trough_off = zeros(numel(off):1);
            % determines all troughs that are less than the
            % TROUGH_THRESHOLD
            for j = 2:numel(on)
                if ( ((RO.time(on(j)) -...
                        RO.time(off(j-1))) < troughThreshold)...
                        && ( RO.time(on(j)) -...
                        RO.time(off(j-1)) > 0 ))
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
                if ( (RO.time(off(n)) -...
                        RO.time(on(n))) < burstThreshold )
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
            RO.onsetRevised = on;
            RO.offsetRevised = off;
        end
        
    end
    
end

