function [stickX, stickY] = jnts2sticks( mTraj )


global gv;

x = mTraj(1, 1:2:end);
y = mTraj(1, 2:2:end);

enabledMarkers = find(~isnan(x)); %this is the list of enabled markers
if isempty( enabledMarkers ),
    stickX(1:2,length(x) - 1) = NaN;
    stickY(1:2,length(x) - 1) = NaN;
else,
    %loop through the list of enabled markers and connect adjacent points with sticks
    for iSeg = 1:length(enabledMarkers)-1,
        stickX(1, iSeg) = x(enabledMarkers(iSeg)); %origin
        stickX(2, iSeg) = x(enabledMarkers(iSeg+1)); %termination
        stickY(1, iSeg) = y(enabledMarkers(iSeg)); %origin
        stickY(2, iSeg) = y(enabledMarkers(iSeg+1)); %termination    
    end
%     n = sum(isnan(x));
%     if n > 0,
%         stickX(:, end+n) = NaN;
%         stickY(:, end+n) = NaN;
%     end
end

iNOlink = find( gv.mrkrLink == 0);
for i = iNOlink,
    stickX(:, i) = NaN;
    stickY(:, i) = NaN;
end
