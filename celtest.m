clear ce;
clear ro;
clc;
ce = cel(t, c, -52);
ce.aboveThreshold;
ce.isBurst(NaN, NaN, NaN);
valueCel = cel.collection(ce.time, ce.onsetRevised, ce.offsetRevised);

ro = root(t, r, 0.04);
ro.bandpass;
ro.filterData;
ro.aboveThreshold;
ro.isBurst(NaN, NaN, NaN);
ro.averageAmplitude;
ro.averageDuration;
ro.averagePeriod;
ro.plotAmplitude;
valueRoot = root.collection(ro.time, ro.onsetRevised, ro.offsetRevised);

~(((valueCel(4).onset >= valueRoot(2).onset) || (valueCel(4).offset >= valueRoot(2).onset))...
           && ((valueCel(4).onset <= valueRoot(2).offset) || (valueCel(4).offset <= valueRoot(2).offset)))

position = 1;
for i = 1:numel(valueRoot)
    disp('i')
    disp(i)
    if ~(position > numel(valueCel))
        for j = position:numel(valueCel)
            disp('j')
            disp(j)
            if ~(((valueCel(j).onset >= valueRoot(i).onset) || (valueCel(j).offset >= valueRoot(i).onset))...
                && ((valueCel(j).onset <= valueRoot(i).offset) || (valueCel(j).offset <= valueRoot(i).offset)))
                ce.removeBurst(j);
                position = position + 1;
                break
            end
        position = position + 1;
        end
    end
end

subplot(2,1,1);
ce.plotData;
ce.plotMarkers;

subplot(2,1,2);
ro.plotData;
ro.plotMarkers;