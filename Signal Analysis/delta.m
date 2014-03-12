function [ deltaTime, deltaTimeArray ] = delta( time1, time2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (numel(time1) ~= numel(time2))
    disp('Unequal amount of bursts between the two data sets.')
else
    deltaTimeArray = time2 - time1;
end

deltaTime = mean(deltaTimeArray);
end

