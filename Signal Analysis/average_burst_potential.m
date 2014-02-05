function [ averagePotential ] = average_amplitude ( time, potential, threshold )

count = 0;
cumulativePotential = 0;

absPotential = abs(potential);

for elem = 1:size(time)
    if ( absPotential(elem) > threshold )
        cumulativePotential = cumulativePotential + absPotential(elem);
        count = count + 1;
    end
end

averagePotential = cumulativePotential / count;
        
        
    