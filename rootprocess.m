classdef rootprocess < handle
    %SIGNALPROCESS
    %   this class takes input parameters of time, potential data of the
    %   ENG, and the threshold voltage start computation at.
   
    properties (GetAccess = private, SetAccess = private)
        time        %time
        potential   %potential
        threshold   %potential threshold level
    end
    
    properties (SetAccess = private)
        b %filter properties
        a %filter properties
        time_downsample %downsampled time data
        potential_downsample %downsampled potential data
        avg_abs_filt_poten %filtered, rectified and averaged data.
        onset %all onsets of spikes in data
        onset_revised %onset of only the desired bursts
        offset %all offsets of spikes in data
        offset_revised %offset of only the desired bursts
        average_burst_duration %average duration of each burst
        average_burst_period %average period between each burst
        average_amplitude %avergae amplitude of each burst
    end
    
    properties (Constant)
        FILTER_ORDER = 2; % order of the filter
        FREQ_SAMPLE = 10000; % sample frequency (Hz)
        FREQ_PASS = [100, 1000]; % passband frequency (Hz)
        MOVING_AVG_SPAN = 501; % span of moving average (10E-4s)
        SPIKE_THRESHOLD = 0.05; % time threshold for a spike above potential threshold to be a burst (s)
        TROUGH_THRESHOLD = 0.106; % threshold for a trough above potential threshold to be negligible (s)
        BURST_THRESHOLD = 0.5; % maximum thresh in which a burst is not ignored as noise (s)
        TIME_BETWEEN = 0.5; % time between two point for one burst to be serperated into 2 bursts
    end
    
    methods
        
        function RP = rootprocess (time, potential, threshold)
        % class constructor
            if (nargin > 0)
                RP.time = time;
                RP.potential = potential;
                RP.threshold = threshold;
            end
        end
        
        %takes a factor of an integer value to downsample the data by.
        %ruturns data sets of time_downsampled and potential_downsampled
        %after the downsampling factor has been applied to the orginal data
        %sets.
        %default downsampling factor is 5 if not downsampling factor is
        %given.
        function downSample (RP, factor)
            if (factor == 0)
                RP.time_downsample = RP.time;
                RP.potential_downsample = RP.potential;
                
            elseif (isnan(factor))
                factor = 5;
                RP.time_downsample = downsample( RP.time, factor );
                RP.potential_downsample = downsample ( RP.potential, factor );
            else
            
                RP.time_downsample = downsample( RP.time, factor );
                RP.potential_downsample = downsample ( RP.potential, factor );
            end
        end
        
        % creates a bandpass filter
        function bandpass (RP)
            
            freq_norm = 2*RP.FREQ_PASS / RP.FREQ_SAMPLE;%normalized passband
            [RP.b, RP.a] = butter(RP.FILTER_ORDER, freq_norm, 'bandpass');
        end
        
        % filters the raw data twice, forward and reverse, doubling the
        % filtering order and removing phase shifts. Full wave
        % rectification of data, and then takes a moving average of the
        % data.
        function filterData (RP)
            
            filt_poten = filtfilt(RP.b, RP.a, RP.potential_downsample);%filters the ENG
            abs_filt_poten = abs(filt_poten);%rectifies filtered ENG
            RP.avg_abs_filt_poten = smooth(abs_filt_poten, RP.MOVING_AVG_SPAN, 'moving');
        end
        
        % function to plot time vs. the filtered, rectified, and averaged
        % data.
        function plotData (RP)
            hold on;
            plot (RP.time_downsample, RP.avg_abs_filt_poten, 'Color', 'k')
            xlabel('Time (s)');
            ylabel('Voltage (mV)');
            hold off;
        end
        
        %plots the onsets and offsets of each burst. onsets and offsets
        %come from the onset_revised and offset_revised data sets. Also
        %plots a horizontal line corresponding to the threshold level
        %specified from the construtor.
        %onset markers are green > markers, offsets are red < markers.
        %threshold level is a black line
        function plotMarker (RP)
            hold on;
            refline(0, RP.threshold);
            plot(RP.time_downsample(RP.onset_revised), RP.threshold,...
                '>', 'MarkerSize', 8, 'MarkerEdgeColor',...
                'g', 'MarkerFaceColor', 'g');
             plot(RP.time_downsample(RP.offset_revised), RP.threshold,...
                '<','MarkerSize', 8, 'MarkerEdgeColor',...
                'r', 'MarkerFaceColor', 'r');
            hold off;
        end
        
        %plots the average amplitude as a horizontal red line.
        function plotAvgAmp (RP)
            hold on;
            line = refline (0, RP.average_amplitude);
            set(line, 'Color', 'r')
            hold off;
        end
        % determines all onsets and offsets of every spike above the
        % potential threshold level.
        
        function aboveThreshold (RP)
            
            above_threshold = (RP.avg_abs_filt_poten > RP.threshold); 
            edge = diff(above_threshold); %calculates difference between each index value
            RP.onset = find(edge == 1); %(0 -> 1) difference of +1 means onset of a spike
            RP.offset = find(edge == -1);  %(1 -> 0) difference of -1 means ofset of a spike
        end

        % determines whether each spike can be considered a burst or not
        % depending on the thrsholds given.
        function isBurst (RP, spike_threshold, trough_threshold,...
                burst_threshold)
            
            if (isnan(spike_threshold))
                spike_threshold = 0.05;
            end
            
            if (isnan(trough_threshold))
                trough_threshold = 0.106;
            end
            
            if (isnan(burst_threshold))
                burst_threshold = 0.5;
            end
            % preallocates arrays to determine which onsets and offsets to 
            % use for calculations.
            on = zeros(numel(RP.onset):1);
            off = zeros(numel(RP.offset):1);
            % if a spike above the threshold lasts more than the
            % SPIKE_THRESHOLD, adds to the [on], [off] array. 
            for i = 1:numel(RP.onset)
                
                if ( RP.time_downsample(RP.offset(i)) -...
                        RP.time_downsample(RP.onset(i)) > spike_threshold )
                    
                    on(i) = RP.onset(i);
                    off(i) = RP.offset(i);
                end
            end
            
            on = on(on ~= 0);
            off = off(off ~= 0);
         
            trough_on = zeros(numel(on):1);
            trough_off = zeros(numel(off):1);
            % determines all troughs that are less than the
            % TROUGH_THRESHOLD
            for j = 2:numel(on)
                
                if ( ((RP.time_downsample(on(j)) -...
                        RP.time_downsample(off(j-1))) < trough_threshold)...
                        && ( RP.time_downsample(on(j)) -...
                        RP.time_downsample(off(j-1)) > 0 ))
                    
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
                
                if ( (RP.time_downsample(off(n)) -...
                        RP.time_downsample(on(n))) < burst_threshold )
                    
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
            
            RP.onset_revised = on;
            RP.offset_revised = off;
        end
               
        % calculates the average duration of each burst. The duration of a
        % burst is measured from the onset to the offset of that burst.
        function averageDuration (RP)
            
            cumulative_burst_duration = 0;
            duration_count = 0;
            
            for i = 1:numel(RP.onset_revised) 
                
                cumulative_burst_duration = cumulative_burst_duration +...
                    (RP.time_downsample(RP.offset_revised(i))-...
                    RP.time_downsample(RP.onset_revised(i)));
                duration_count = duration_count + 1;
            end
            
            RP.average_burst_duration =...
                cumulative_burst_duration / duration_count;
        end
            
        % calculates the average period cycle of bursts. The period is
        % measured from the onset of one burst to the onset of the next
        % consectutive burst.
        function averagePeriod (RP)
            
            cumulative_burst_period = 0;
            period_count = 0;
            
            for x = 1:numel(RP.onset_revised)
                if ( x < numel(RP.onset_revised) )
                    cumulative_burst_period = cumulative_burst_period +...
                        ( RP.time_downsample(RP.onset_revised(x+1)) -...
                        RP.time_downsample(RP.onset_revised(x)) );
                    period_count = period_count + 1;
                end
            end
            
            RP.average_burst_period =...
                cumulative_burst_period / period_count; 
        end
        
        % caluclates the average amplitude of all bursts in the data set.
        % Determines the maximum local peaks of each burst and takes the
        % mean of all peaks.
        function averageAmplitude (RP)
            
            max_values = zeros(numel(RP.potential_downsample):1);
            
            for i = 1:numel(RP.onset_revised)
                
                start = RP.onset_revised(i);
                stop = RP.offset_revised(i);
                
                for j = find(RP.onset == start):find(RP.offset == stop)
                    values =...
                        RP.avg_abs_filt_poten(RP.onset(j):RP.offset(j));
                end
                
                peaks = max(values);
                max_values(i) = peaks;  
            end
            
            max_values = max_values(max_values ~= 0);
            RP.average_amplitude = mean(max_values);
        end
                
        function getDuration (RP)
            
            fprintf('Average burst duration:\n%f s\n',...
                RP.average_burst_duration);
        end
        
        function getPeriod (RP)
            
            fprintf ('Average period of bursts:\n%f s\n',...
                RP.average_burst_period);
        end
        
        function getAmplitude (RP)
            
            fprintf ('Average burst amplitude:\n%f mV\n',...
                RP.average_amplitude);
        end   
    end

end

