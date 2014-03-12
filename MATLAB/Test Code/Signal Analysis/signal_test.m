clc;
clear SP;
clear ans;

SP = signalprocess (t, p, 0.028);
SP.downSample(5)
SP.bandpass;
SP.filterData;
SP.aboveThreshold;

SP.plotData
SP.isBurst;
SP.averageDuration;
SP.averagePeriod;
SP.averageAmplitude;
SP.getAmplitude
SP.getDuration
SP.getPeriod

SP.plotTest
SP.plotAvgAmp
