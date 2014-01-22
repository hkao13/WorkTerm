function [ avgPotential ] = root( time, potential, time1, time2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

index = find( time >= time1 & time <= time2 )
newpotential = potential(index);

avgPotential = mean(newpotential);
end

