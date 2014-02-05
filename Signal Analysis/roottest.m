clear ro;
ro = root(t, r, 0.04);
ro.bandpass;
ro.filterData;
ro.aboveThreshold;
ro.isBurst(NaN, NaN, NaN);
ro.plotData;
ro.plotMarkers;
ro.averageAmplitude;
ro.averageDuration;
ro.averagePeriod;
ro.plotAmplitude;
value = root.collection(ro.time, ro.onsetRevised, ro.offsetRevised);
value(3)