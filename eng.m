clc;
clear SP;
clear user_time user_pot user_thresh user_downsample option

user_time = input('Please enter the data for time: \n');
disp (' ');

user_pot = input('Please enter the data for the root potential: \n');
disp (' ');

user_thresh = input('Please enter a threshold level (mV): \n');
disp (' ');

SP = signalprocess(user_time, user_pot, user_thresh);

user_downsample = input('Please enter integer to downsample the data, \nor press ENTER for the default value (5): \n');
if (numel(user_downsample) == 0)
    disp ('Defualt value (5).')
    user_downsample = NaN;
end
disp (' ');
SP.downSample(user_downsample);
SP.bandpass;
SP.filterData;
SP.aboveThreshold;

option = input('To change default threshold values for determining bursts,\nplease type "Y"\nor press ENTER to use default thresholds: \n', 's');

if (numel(option) == 0)
    option = NaN;
end

if ((option == 'Y') || (option == 'y'))
    spike = input('Please enter the minimum time duration (s) that a spike has to be above\nthe threshold to be used in finding bursts,\nor press ENTER to use the defualt value (0.05s):\n');
    trough = input('Please enter the maximum time duration (s) that a trough has to be below\nthe threshold to be ignored in determining bursts,\nor press ENTER to use the default value (0.106s):\n');
    burst = input('Please enter the mimmum time duration (s) that a spike has to be above\nthe threshold to be ignored as a burst\nor press ENTER to use the default value (0.5s):\n');
    
    if (numel(spike) == 0)
        spike = NaN;
    end
    
    if (numel(trough) == 0)
        trough = NaN;
    end
    
    if (numel(burst) == 0)
        burst = NaN;
    end
    
else
    spike = NaN;
    trough = NaN;
    burst = NaN;
end
    
SP.isBurst(spike, trough, burst);
SP.averageDuration;
SP.averagePeriod;
SP.averageAmplitude;
SP.getAmplitude;
SP.getDuration;
SP.getPeriod;
SP.plotData
SP.plotTest
SP.plotAvgAmp
SP.click;
    