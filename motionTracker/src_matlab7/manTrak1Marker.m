function manTrak1Marker( iMarker );

global gv;
global guiH;
global mTraj;
global trak;

iFrame = trak.iFrame;
iMarker = str2num(iMarker);
if iMarker <= gv.nMarkers,
    set(guiH.commentTxt, 'String', sprintf('Click on %s Marker Center\nOR\nRIGHT Click to cancel', gv.mrkrLabels{iMarker}) );        
    [xCent, yCent, butn] = ginput(1);
    if butn == 1,
        %use the mouse position
        mTraj(iFrame, iMarker*2-1:iMarker*2) = [xCent, yCent];
    elseif butn == 32, %spacebar clears the marker position
        mTraj(iFrame, iMarker*2-1:iMarker*2) = [xCent, yCent];
        xCent = NaN;
        yCent = NaN;
    end
    crnrs = round([xCent - hws, xCent + hws; yCent - hws, yCent + hws]);
    set(guiH.mCent(iMarker), 'XData', xCent, 'YData', yCent );
    set( guiH.boxs(iMarker), 'Position', [crnrs(1,1) crnrs(2,1) diff(crnrs(1,:)) diff(crnrs(2,:))] );
    hws = round( gv.mrkrSize(iMarker)/2);
    [refIdx, crnrs] = makeRefIdx( hws, xCent, yCent );
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
    gv.refDot{iMarker} = Sw;    
    
    set(guiH.commentTxt, 'String', 'instructions...' );
end
