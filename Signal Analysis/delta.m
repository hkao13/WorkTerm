function [ deltaTime ] = delta( time1, time2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

totalTime = 0;
count = 0;

if (numel(time1) ~= numel(time2))
    disp('Unequal amount of bursts between the two data sets.')
else
    for i = 1:numel(time1)
        totalTime = totalTime + ( time2(i) - time1(i) );
        count = count + 1;
    end
end

deltaTime = totalTime / count;
end

