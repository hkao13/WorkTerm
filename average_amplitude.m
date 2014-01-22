function [ averagePotential ] = average_amplitude ( time, potential, threshold )
%average_amplitude calculates the average potential amplitude of the
%bursts. The user inputs the time and potential data, and also the
%threshold voltage where the bursts start at.


count = 0; %number of potentials above the threshold level.
cumulativePotential = 0; %cumulative sum of all potentials above the threshold level.
absPotential = abs(potential); %rectifies the data of the potentials.

%iterates through the data to find all abs(potential) above the threshhold
%level. Potentials above the threshold will be added to the cumulative sum.
% Number of potenials above the threshold is kept track of by count
for elem = 1:size(time)
    if ( absPotential(elem) > threshold )
        cumulativePotential = cumulativePotential + absPotential(elem);
        count = count + 1;
    end
end

%divides cumulative sum by count to find the average amplitude of the
%bursts.
averagePotential = cumulativePotential / count;

%TODO: make it so that it can auto-detect a threshold level.
        
    