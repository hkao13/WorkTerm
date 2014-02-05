function [  ] = signal_process(time, potential, threshold)
%UNTITLED SIGNAL_PROCESS determines the burst duration and period of bursts
%given the raw data for time, potential and a threshold potential.
%   Author:     Henry Kao
%   Date:       January 2014
%   Purpose:    Univ. of Alberta, Dr. Gosgnach's CPG Laboratory.

%   bandpass filter 100Hz -> 1000Hz
n = 2;                                      %order
freq_sample = 10000;                        %sample rate
freq_pass = [100, 1000];                    %passband
freq_norm = 2*freq_pass / freq_sample;      %normalized passband
[b,a] = butter(n, freq_norm, 'bandpass');   %buttterworth bandpass filter

moving_avg_span = 499;                      %span of moving average (10E-4s)

filt_poten = filtfilt(b,a,potential);       %filters the ENG
abs_filt_poten = abs(filt_poten);           %rectifies filtered ENG
avg_abs_filt_poten = smooth(abs_filt_poten, moving_avg_span, 'moving'); %moving average

plot (time, avg_abs_filt_poten)             %plots time vs. averaged and giltered potential

%creates logic array, 1(true) are points above user specified threshold,
%0(false) are points below user specified threshold
above_threshold = (avg_abs_filt_poten > threshold); 
edge = diff(above_threshold);               %calculates difference between each index value
onset = find(edge == 1);                    %(0 -> 1) difference of +1 means onset of a spike
offset = find(edge == -1);                  %(1 -> 0) dofference of -1 means ofset of a spike

%threshold to determine how long a spike has to be above the potential
%threshold to be considered a burst.
pos_burst_threshold = 0.06;                 %spike threshold (s)      
%TODO: think or implement preallocated array for faster speed.
is_burst = [];                              %empty array to store spikes that are bursts

%for loop to determine if each spike is a burst or not.
for i = 1:numel(onset)
    
    %if the difference in time between offset and onset is below the
    %pos_burst_threshold, the spike is not considered a burst, and flase
    %(0) is append to is_burst.
    if ( time(offset(i)) - time(onset(i)) < pos_burst_threshold )
        is_burst = [is_burst, false];
    end
    
    %if the difference in time between offset and onset is above the
    %pos_burst_threshold, the spike considered a burst, and true
    %(1) is append to is_burst.   
    if ( time(offset(i)) - time(onset(i)) >= pos_burst_threshold )
        is_burst = [is_burst, true];
    end
   
end


%threshold to determine if a trough "inverse spike" can be negiligible when
%trying to determine if a spike is a burst or not
neg_burst_threshold = 0.106;                %trough threshold (s)

%for loop to determine if a un-seperate bursts due to wide troughs with the
%bursts.
for j = 2:numel(is_burst)-1
    
    %difference between the time of onset and offset for the troughs have
    %to be liss than the trough threshold and greater than 0. It also have
    %to be between two bursts for trough to be negligible.
    if (((time(onset(j)) - time(offset(j-1))) < neg_burst_threshold) && ((time(onset(j)) - time(offset(j-1))) > 0))
        if ((is_burst(j-1) == 1) || (is_burst(j+1) == 1))
            is_burst(j) = true;             %changes the value from false(0) to true(1) if conditions are met.
        end
    end
end

%is_burst %test

start_ind = find(is_burst, 1, 'first');     %first onset of the first burst
end_ind = find(is_burst, 1, 'last');        %last offset of the last burst
onset_revised = [onset(start_ind)];         %creates array to store values of onset time indicies
offset_revised = [];                        %creates array to store values of offset time indicies
%two or more bursts in is_burst may look like 1 large burst. this threshold
%value will help sperate seemingly large bursts into its actual smaller
%bursts.
time_between_burst_threshold = 0.5;             

%for loop to determine the values of the onset of each burst and offset of
%each burst.
for k = 2:numel(is_burst) - 1
    
    %if there is a time difference greater than the time_between_burst_threshold
    %of the seemily large burst, then it is considered to be sperate
    %bursts.
    if ( (time(onset(k + 1)) - time(offset(k))) > time_between_burst_threshold)
        if ((is_burst(k-1) == 1) && (is_burst(k+1) == 1))
            offset_revised = [offset_revised, offset(k)];   %offset of the seperated large burst
            onset_revised = [onset_revised, onset(k+1)];    %onset of the seperated large burst
        end
    end
    
    %since 0's are unuseful spikes, and 1's are useful spikes in bursts, if
    %is_burst goes from 0 to 1, it means that there is a new burst,
    if ( (is_burst(k) == 0) && (is_burst(k+1) == 1) && ( onset(k+1) ~= onset(start_ind)) )
        onset_revised = [onset_revised, onset(k+1)];    %new onset appended to onset_revised array
    end
    
    %if is_burst goes from 1 to 0, it means that there is an offset to a
    %burst
    if ( (is_burst(k) == 1) && (is_burst(k+1) == 0) && ( offset(k) ~= offset(end_ind)) )
        offset_revised = [offset_revised, offset(k)];   %new offset appended to offset_revised array  
    end   
end
offset_revised = [offset_revised, offset(end_ind)];     %last value of offset_revised is the last offset.

onset_revised %test
offset_revised %test

duration_count = 0;                         %keeps track of how many bursts there are
period_count = 0;                           %keeps track of how many cycles of bursts there are
cumulative_burst_duration = 0;              %total duration of all the bursts
cumulative_burst_period = 0;                %total time of all cycles of the bursts

%for loop to calculate the cumulative time for both burst duration and
%burst period.
for x = 1:numel(onset_revised)
    
    if ( x < numel(onset_revised) )
       cumulative_burst_period = cumulative_burst_period + ( time(onset_revised(x+1)) - time(onset_revised(x)) );
       period_count = period_count + 1;
    end
    
   cumulative_burst_duration = cumulative_burst_duration + (time(offset_revised(x))- time(onset_revised(x)));
   duration_count = duration_count + 1;
end
average_burst_duration = cumulative_burst_duration / duration_count     %average burst duration
average_burst_period = cumulative_burst_period / period_count           %average burst period


end

