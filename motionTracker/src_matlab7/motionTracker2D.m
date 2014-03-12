%motionTracker2D
% by: Doug Weber
% last edit: 11/30/2002
% location: Main program for the motionTracker 2-D program.
%
% Motion tracker is a matlab application that can be used to digitize
% the position of 1 to 18 markers in each frame of a .avi video. 
% feature('JavaFigures',0)
close all
clear all
warning off;


%STEP 0: Initialize variables
mtInitialize;

%STEP 1: Build graphical-user-interface
guiH = buildMTgui;




