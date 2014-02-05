function mtControlGUI( action )
% mtControl( action  );
% by: Doug Weber
% last edit: 12/2/2002
% location: motionTracker toolbox
%
% purpose: this performs the operations for marker-configuration GUI 
% such as labelling markers, specifying size, color, enable, etc...

global gv;
global trak;
global controlH;

global fullImage;
global curImage;

global mTraj;
global guiH;
global captureFolder;
global mtConfigH;

iFrame = trak.iFrame;
iKeyFrame = trak.iKeyFrame;
iField = trak.iField;

switch action,
    
case 'mrkrLabels',
    gv.mrkrLabels = get( controlH.mrkrLabels, 'String' );
    if gv.nMarkers == 1,
        set(guiH.manTrak,'String', gv.mrkrLabels);
    else,
        for iMarker = 1:gv.nMarkers,
            set(guiH.manTrak(iMarker),'String', gv.mrkrLabels{iMarker});
        end
    end
    
case 'mrkrLink',
    for i = 1:gv.nMarkers-1,
        gv.mrkrLink(i) = get( controlH.mrkrLink(i), 'Value' );
    end
    [stickX(iFrame, :, :), stickY(iFrame, :, :)] = jnts2sticks( mTraj(iFrame, :) );
    
    mtGUI('updateDisplay');
    
case 'mrkrEnable',
    for i = 1:gv.nMarkers,
        gv.mrkrEnable(i) = get( controlH.mrkrEnable(i), 'Value' );
    end
    
    %disabled markers need to have their variables cleared
    iDisabled = find(gv.mrkrEnable == 0);
    iEnabled = find(gv.mrkrEnable == 1);
    for i = iDisabled,
        gv.boxH(i) = NaN;
        mTraj(iFrame, i*2-1:i*2) = NaN;
        set(guiH.manTrak(i), 'Enable','Off')
    end
    for i = iEnabled,
        set(guiH.manTrak(i), 'Enable','On')
    end
        
    mtGUI('updateDisplay');
    
case 'mrkrInvert',
    for i = 1:gv.nMarkers,
        gv.mrkrInvert(i) = get( controlH.mrkrInvert(i), 'Value' );
    end
    
case 'mrkrSize',
    oldSize = gv.mrkrSize;
    for i = 1:gv.nMarkers,
        gv.mrkrSize(i) = str2num( get( controlH.mrkrSize(i), 'String' ) );
    end
    newSize = gv.mrkrSize;
    dx = oldSize-newSize;
    iNew = find( dx ~= 0 );
    if ~any(isnan(mTraj(iFrame,:))),
        for iMarker = iNew,
            xCent = round(mTraj( iFrame, iMarker*2-1)); 
            yCent = round(mTraj(iFrame, iMarker*2));
            hws = ceil(str2num( get( controlH.mrkrSize(iMarker), 'String' ) )/2);
            crnrs = [xCent - hws, xCent + hws; yCent - hws, yCent + hws];
            crnrs( crnrs(:,1) < 1, 2 ) = 2*hws+1;
            crnrs( crnrs(:,1) < 1, 1 ) = 1;
            if crnrs(1,2) > gv.nHp,
                crnrs( 1, 1:2 ) = [gv.nHp - 2*hws, gv.nHp];
            end
            if crnrs(2,2) > gv.nVp,
                crnrs( 2, 1:2 ) = [gv.nVp - 2*hws, gv.nVp];
            end
            Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
            gv.refDot{iNew} = Sw;    
            
            mtGUI('updateMarkers');
        end
    end    
case 'mrkrSizeX',
    for i = 1:gv.nMarkers,
        gv.mrkrSizeX(i) = str2num( get( controlH.mrkrSizeX(i), 'String' ) );
    end
    
case 'mrkrSizeTol',
    for i = 1:gv.nMarkers,
        gv.sizeTol(i) = str2num( get( controlH.mrkrSizeTol(i), 'String' ) );
    end
    
case 'updateConfigDisplay',
    for i = 1:gv.nMarkers,
        set(controlH.mrkrLabels(i), 'String', gv.mrkrLabels{i} );
        set(controlH.mrkrEnable(i), 'Value', gv.mrkrEnable(i) );
        set(controlH.mrkrInvert(i), 'Value', gv.mrkrInvert(i) );
        set(controlH.mrkrSize(i), 'String', gv.mrkrSize(i) );
        set(controlH.mrkrSizeX(i), 'String', gv.mrkrSizeX(i) );
    end
    
case 'toggleEraser',
    if get(guiH.eraserBox, 'Value') == 1,
        set( guiH.manTrakButn, 'Enable', 'Off');
        set( guiH.startButn, 'Enable', 'Off');
    else,
        set( guiH.manTrakButn, 'Enable', 'On');
        if ~all(all(isnan(mTraj))),
            set( guiH.startButn, 'Enable', 'On');
        end
    end

case 'Manual',
    trak.method = 'Manual';    
    h = mtConfigH.methButns;
    set(h(1), 'Value', 1);
    mutualExclude( h(2:3) );
    
case 'HotSpot',
    trak.method = 'hotSpot';    
    h = mtConfigH.methButns;
    set(h(2), 'Value', 1);
    mutualExclude( h([1,3:4]) );

case 'matchDot',
    trak.method = 'matchDot';    
    h = mtConfigH.methButns;
    set(h(3), 'Value', 1);
    mutualExclude( h(1:2,4) );
    
case 'matchColor',
    trak.method = 'matchColor';    
    h = mtConfigH.methButns;
    set(h(4), 'Value', 1);
    mutualExclude( h(1:3) );
    
case 'Linear',
    gv.predMode = 'Xpoly';    
    h = mtConfigH.extrapButns;
    set(h(1), 'Value', 1);
    mutualExclude( h(2) );
    
case 'Polar',
    gv.predMode = 'Qpoly';    
    h = mtConfigH.extrapButns;
    set(h(2), 'Value', 1);
    mutualExclude( h(1) );
    
case 'extrapHistory',
    l = str2num(get( mtConfigH.extrapHist, 'String'));
    gv.polyPts = round( l*gv.fps*gv.fpf);
    
end

function mutualExclude( off );
set(off,'Value',0)
