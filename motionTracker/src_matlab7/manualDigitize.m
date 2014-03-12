function manualDigitize( action )
% manualDigitize( action )
% by: Doug Weber
% last edit: 11/30/2002
% location: motionTracker toolbox
% purpose: manually digitize ALL or individual markers
% INPUTS:
%   action: allMarkers or "otherwise"


global gv;
global trak;
global guiH;
global controlH;
global curImage;

global mTraj;

iFrame = trak.iFrame;

switch action,
case 'allMarkers',

    figure(guiH.fig);
    enabledMarkers = find( gv.mrkrEnable );    
    for iMarker = enabledMarkers,
        set(guiH.commentTxt, 'String', sprintf('Click on %s Marker Center\nor\nRIGHT Click to CANCEL', ...
            gv.mrkrLabels{iMarker}) );
        [xHat, yHat, butn] = ginput(1);
        if butn == 1,
            [xCent, yCent] = mtFindMarker( curImage, xHat, yHat, iMarker, 'centroid'); 
        else,
            mTraj(iFrame, iMarker*2-1:iMarker*2) = [NaN, NaN];
            mtGUI('stop');
            return;
        end
        xCent = mTraj( iFrame, iMarker*2-1); 
        yCent = mTraj(iFrame, iMarker*2);
        hws = str2num( get( controlH.mrkrSize(iMarker), 'String' ) )/2;
        crnrs = round([xCent - hws, xCent + hws; yCent - hws, yCent + hws]);
        set(guiH.mCent(iMarker), 'XData', xCent, 'YData', yCent );
        set( guiH.boxs(iMarker), 'Position', [crnrs(1,1) crnrs(2,1) diff(crnrs(1,:)) diff(crnrs(2,:))] );
        set(guiH.manTrak(iMarker), 'Enable', 'On');
    end
    mtGUI('updateDisplay');
    set(guiH.commentTxt, 'String', 'Click "AUTO" to auto-track markers' );
    set(guiH.startButn, 'Enable', 'On');    
    set(guiH.saveFileButn, 'Enable','On');
    set( guiH.menuAutoTrak, 'Enable', 'On');
        
otherwise,
    iMarker = str2num(action);
    if iMarker <= gv.nMarkers,
        set(guiH.commentTxt, 'String', sprintf('Click on %s Marker Center\nOR\nRIGHT Click to cancel', gv.mrkrLabels{iMarker}) );        
        [xCentMouse, yCentMouse, butn] = ginput(1);
        if butn == 1,
            mTraj(iFrame, iMarker*2-1:iMarker*2) = [xCentMouse, yCentMouse];            
        else,
            %if not left clicked, then cancel update 
        end
        hws = round( gv.mrkrSize(iMarker)/2);
        [refIdx, crnrs] = makeRefIdx( hws, xCentMouse, yCentMouse );
        Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
        gv.refDot{iMarker} = Sw;    
        
        mtGUI('updateDisplay');
        set(guiH.commentTxt, 'String', 'instructions...' );
    end
end

