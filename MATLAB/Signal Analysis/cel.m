classdef cel < signalanalysis
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function CE = cel(time, potential, threshold, onsetTimes, offsetTimes)
            if (nargin == 3)
                superArgs{1} = [];
                superArgs{2} = [];
            else
                superArgs{1} = onsetTimes;
                superArgs{2} = offsetTimes;
            end
            CE = CE@signalanalysis(time, potential, threshold, superArgs{:});
        end
        
        function isBurst (CE, spikeThreshold, troughThreshold,...
                burstThreshold)
            
            if (isnan(spikeThreshold))
                spikeThreshold = 0.005;
            end
            
            if (isnan(troughThreshold))
                troughThreshold = 1.00;
            end
            
            if (isnan(burstThreshold))
                burstThreshold = 0.005;
            end  
            
            % if a spike above the threshold lasts more than the
            % SPIKE_THRESHOLD, adds to the [on], [off] array. 
            try
                ind = ( (CE.time(CE.offset)) - (CE.time(CE.onset)) ) > spikeThreshold;
                on = CE.time(CE.onset(ind));
                off = CE.time(CE.offset(ind));

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
                CE.onsetTimes = on;
                CE.offsetTimes = off;
            catch err
                msg = {'Error in detecting bursts for cell.', '1. Try another threshold level.', '2. Try another data time frame.', '3. Adjust cell input settings.'};
                errordlg(msg);
            end
        end
        
        % removes unwanted bursts that are considered as noise from the
        % onset of offset data sets.
        function removeBurst (CE, index)
            CE.onsetRevised(index) = [];
            CE.offsetRevised(index) = [];
        end
    end
    
end

