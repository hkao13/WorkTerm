clear ce;
clc;
ce = cel(t2, c2, -45);

ce.aboveThreshold
ce.isBurst(NaN, NaN, NaN);
ce.plotData;
ce.plotMarkers;