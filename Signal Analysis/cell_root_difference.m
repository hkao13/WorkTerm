function [ ] = cell_root_difference( time, cellPotential, rootPotential, cellThreshold, rootThreshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

absRoot = abs(rootPotential);      %rectifies data.
%determines all points above user specified threshold, creats a logic array
rootBurstPotential = (absRoot > rootThreshold);
%determines edges of each burst by the taking the difference of each
%element in the logic array.
rootLimit = diff(rootBurstPotential);
rootPosLimit = find(rootLimit == 1);        %burst begins when the difference is +1.
rootNegLimit = find(rootLimit == -1);       %burst ends when the difference is -1.
rootBurstWidth = rootNegLimit - rootPosLimit;   %width of burst.
%certain threshold to be considered a burst
%TODO: re-do this part when accounting from the noise in data.
rootWidthThreshold = rootBurstWidth >= 4;
rootOnSet = rootPosLimit(rootWidthThreshold);   %onset of burst (start).
rootOffSet = rootNegLimit(rootWidthThreshold) - 1; %offset of burst (end).

absCell = abs(cellPotential);
cellBurstPotential = (absCell > cellThreshold);
cellLimit = diff(cellBurstPotential);
cellPosLimit = find(cellLimit == 1);
cellNegLimit = find(cellLimit == -1);
cellBurstWidth = cellNegLimit - cellPosLimit;
cellWidthThreshold = cellBurstWidth >= 4;
cellOnSet = cellPosLimit(cellWidthThreshold);
cellOffSet = cellNegLimit(cellWidthThreshold);

timeDifference = 0;
count = 0;

for i = 1:size(rootOnSet)
    timeDifference = timeDifference + abs(cellOnSet(i) - rootOnSet(i));
    count = count + 1;
end
    
averageTimeDifference = timeDifference / count
end

