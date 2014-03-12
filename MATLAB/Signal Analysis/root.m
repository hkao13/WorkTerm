classdef root < signalanalysis
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        b
        a
%         FILTER_ORDER = 2; % order of the filter
%         FREQ_SAMPLE = 10000; % sample frequency (Hz)
%         FREQ_PASS = [100, 1000]; % passband frequency (Hz)
    end
    
    methods
        function RO = root(time, potential, threshold, onsetTimes, offsetTimes)
            if (nargin == 3)
                superArgs{1} = [];
                superArgs{2} = [];
            else
                superArgs{1} = onsetTimes;
                superArgs{2} = offsetTimes;
            end
            RO = RO@signalanalysis(time, potential, threshold, superArgs{:});
    
        end
        
        function bandpass (RO, filtOrder, sampFrequency, passFrequency)
            
            if (isempty(filtOrder))
                FILTER_ORDER = 2; % order of the filter
            else
                FILTER_ORDER = filtOrder; % order of the filter
            end
            
            if (isempty(sampFrequency))
                FREQ_SAMPLE = 10000; % sample frequency (Hz)
            else
                FREQ_SAMPLE = sampFrequency; % sample frequency (Hz)
            end
            
            if(isempty(passFrequency))
                FREQ_PASS = [100, 1000];
            else
                FREQ_PASS = passFrequency;
            end
                 
   
            freqNorm = 2*FREQ_PASS / FREQ_SAMPLE;%normalized passband
            [RO.b, RO.a] = butter(FILTER_ORDER, freqNorm, 'bandpass');
        end
        
        function downsample(RO, factor)
            if (~isnan(factor))
                RO.time      = downsample(RO.time     , factor);
                RO.potential = downsample(RO.potential, factor);
            end
        end
        
        function filterData (RO, window)
            if (isnan(window))
                window = 511;
            else
                window = window * (10^4);
            end
            filtPoten = filtfilt(RO.b, RO.a, RO.potential);%filters the ENG
            absFiltPoten = abs(filtPoten);%rectifies filtered ENG
            RO.potentialMod = smooth(absFiltPoten, window, 'moving');
        end
                
        function isBurst (RO, spikeThreshold, troughThreshold,...
                burstThreshold)
            
            if (isnan(spikeThreshold))
                spikeThreshold = 0.05;
            end
            
            if (isnan(troughThreshold))
                troughThreshold = 0.200;
            end
            
            if (isnan(burstThreshold))
                burstThreshold = 0.7;
            end  
            
            try
                % if a spike above the threshold lasts more than the
                % SPIKE_THRESHOLD, adds to the [on], [off] array. 
                ind = (RO.time(RO.offset) - RO.time(RO.onset)) > spikeThreshold;
                on = RO.time(RO.onset(ind));
                off = RO.time(RO.offset(ind));

                % determines all troughs that are less than the
                % TROUGH_THRESHOLD            
                on1 = on;
                on1(1) = [];
                off1 = off;
                off1(end) = [];
                ind1 =  ( ((on1 - off1) < troughThreshold) & ((on1 - off1) > 0) );
                trough_on = on1(ind1);
                trough_off = off1(ind1);

                % troughs that are less than the TROUGH_THRESHOLD are ignored
                % by removing them from the [on], [off], array.
                ind2 = ismember(on, trough_on);
                ind3 = ismember(off, trough_off);
                on(ind2) = [];
                off(ind3) = [];

                % determines single spikes that was considered to be a burst
                % from previous operations.
                ind4 = (off - on) < burstThreshold;
                burst_on = on(ind4);
                burst_off = off(ind4);

                % removes the single spikes from the [on], [off] arrays.            
                ind5 = ismember(on, burst_on);
                ind6 = ismember(off, burst_off);
                on(ind5) = [];
                off(ind6) = [];
                RO.onsetTimes = on;
                RO.offsetTimes = off;
            catch err
                msg = {'Error in detecting bursts for root.', '1. Try another threshold level.', '2. Try another data time frame.', '3. Adjust root input settings.'};
                errordlg(msg);
            end
        end
    end
    
end

