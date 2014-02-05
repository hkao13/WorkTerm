function [ averageDuration, averagePeriod ] = burst_duration( time, potential, threshold )
%burst_duration calculates the average duration of the bursts and average
%period between bursts. Duration of a burst is from onset to offset, period
%is measured from onset to the next onset.

%Author: Henry Kao


absPotential = abs(potential);      %rectifies data.
%determines all points above user specified threshold, creats a logic array
burstPotential = (absPotential > threshold);
%determines edges of each burst by the taking the difference of each
%element in the logic array.
limit = diff(burstPotential);
posLimit = find(limit == 1);        %burst begins when the difference is +1.
negLimit = find(limit == -1);       %burst ends when the difference is -1.
burstWidth = negLimit - posLimit;   %width of burst.
%certain threshold to be considered a burst
%TODO: re-do this part when accounting from the noise in data.
widthThreshold = burstWidth >= 4;
onSet = posLimit(widthThreshold);   %onset of burst (start).
offSet = negLimit(widthThreshold) - 1; %offset of burst (end).


cumulativeDuration = 0; %initialize total duration of bursts.
cumulativePeriod = 0;   %initialize total period of bursts.
durationCount = 0;      %initialize total number of bursts.
periodCount = 0;        %initialize total number of gaps between bursts.


%loop to iterate through the number of onsets there are.
for i = 1:size(onSet)
   
    if size(rand(i,0)) < (size(onSet))
        cumulativePeriod = cumulativePeriod + (time(onSet(i+1)) - time(onSet(i)));
        periodCount = periodCount + 1;
    end
    
    cumulativeDuration = cumulativeDuration + (time(offSet(i))- time(onSet(i)));
    durationCount = durationCount + 1;
end

%calculates average duration and period
averageDuration = cumulativeDuration / durationCount; 
averagePeriod = cumulativePeriod / periodCount;

indexInBurst = cell2mat(arrayfun(@(x,y) x:1:y, onSet, offSet, 'uni', false))
