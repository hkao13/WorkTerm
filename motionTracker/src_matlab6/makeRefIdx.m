function [refIdx, crnrs] = makeRefIdx( hws, tempxi, tempyi );

global gv;

nHpixels = gv.nHp; nVpixels = gv.nVp;

refIdx = [];
refIdx(1,:) = 1:(2*hws+1)^2;
refIdx(2,:) = reshape( repmat(1:2*hws+1, 2*hws+1, 1), 1, (2*hws+1)^2);
refIdx(3,:) = repmat(1:2*hws+1, 1, 2*hws+1);
refIdx = refIdx';
tempxi = round(tempxi);
tempyi = round(tempyi);
hws = ceil(hws);

% define x,y positions of the cube corners (crnrs: top row = horizontal limits, bottom row = vertical limits)
crnrs = [tempxi - hws, tempxi + hws; tempyi - hws, tempyi + hws];

%use logical indexing to verify that subwindow boundaries are within the limits of the field (nHpixels x nVpixels)
crnrs( crnrs(:,1) < 1, 2 ) = 2*hws+1;
crnrs( crnrs(:,1) < 1, 1 ) = 1;
if crnrs(1,2) > nHpixels,
    crnrs( 1, 1:2 ) = [nHpixels - 2*hws, nHpixels];
end
if crnrs(2,2) > nVpixels,
    crnrs( 2, 1:2 ) = [nVpixels - 2*hws, nVpixels];
end
