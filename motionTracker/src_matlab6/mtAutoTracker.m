function mtAutoTracker;
% mtAutoTracker;
% by: Doug Weber
% last edit: 12/2/2002
% location: motionTracker toolbox
% purpose: function that loops through frames during autoTracking operation

global gv;
global trak;
global mTraj;
global guiH;
global RUNNING;
global captureFolder;
global captureFile;
global curImage;

fullImage = [];

while (trak.iFrame < trak.nF*gv.fpf) & (RUNNING == 1),
    %update instructional comment
    set(guiH.commentTxt,'String','Click "STOP" to halt tracking');

    %increment frame number and begin tracking
    %frame number
    trak.iFrame = trak.iFrame + 1;
    %keyframe number
    trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
    %field number
    trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;

    iFrame = trak.iFrame;
    iField = trak.iField;
    iKeyFrame = trak.iKeyFrame;

    %update frame number in display
    set( guiH.frameNumSldr, 'Value', iFrame );
    set(guiH.frameNumTxt, 'String', int2str(iFrame));
    mTraj(iFrame,:) = NaN;

    %get new frame/field if iField equals 1
    if trak.iField < 2 | isempty( fullImage ),
        fullImage = aviread( sprintf('%s%s', captureFolder, captureFile), iKeyFrame );
        if length(size(fullImage.cdata))==2,
            fullImage = mtIndex2rgb( fullImage.cdata, fullImage.colormap );
        else,
            fullImage = fullImage.cdata;
        end
        if get(guiH.invertBox, 'Value'),
            fullImage = uint8(-1*(double(fullImage) - 255));
        end
    end

    %extract subimage from whole frame
    if gv.videoFormat == 1,
        disp('Select a valid video format');
        curImage = fullImage;
    elseif gv.videoFormat == 2,
        curImage = fullImage;
    else,
        curImage = mtGetSubImage( fullImage, gv.videoFormat, iField );
    end

    %mirror image left-right if necessary
    if ~strcmp( gv.side, 'Right' ),
        curImage = flipdim( curImage, 2);
    end

    %update image in figure window
    figure(guiH.fig);
    set(guiH.ax, 'NextPlot', 'replacechildren');
    guiH.image = image( curImage, 'Parent', guiH.ax);
    set(guiH.ax, 'NextPlot', 'add');
    enabledMarkers = find( gv.mrkrEnable );
    for iMarker = enabledMarkers,
        guiH.mCent(iMarker) = plot( NaN, NaN, '+', 'Color', 'r', 'MarkerSize',10, 'Parent', guiH.ax );
        guiH.boxs(iMarker) = rectangle('Position', [0 0 .01 .01], 'EdgeColor', 'r');
    end

    %Check for event/strobe
    if ~isfield( gv, 'strobeImage' ) & gv.useStrobe,
        yesNo = questdlg('Would you like to locate the Sync Strobe?','Locate strobe?', 'Yes','No','Yes');
        switch yesNo,
            case 'Yes',
                mtGUI('locateStrobe');
            otherwise,
                gv.useStrobe = 0;
        end
    elseif gv.useStrobe,
        %Check for strobe
        sb = curImage(gv.strobeBox(3):gv.strobeBox(4), gv.strobeBox(1):gv.strobeBox(2), :);
        d = double(sb) - double(gv.strobeImage);
        gv.strobeIntensity(iFrame) = abs(sum(sum(sum(d)))/prod(size(d)));
        if gv.strobeIntensity(iFrame) > gv.strobeThresh,
            trak.strobes(iFrame) = 1;
        end

        if trak.strobes(iFrame),
            set(guiH.markStrobeButn, 'BackgroundColor',[1 0 0],'String','ON');
        else,
            set(guiH.markStrobeButn, 'BackgroundColor',[.5 .5 .5],'String','OFF');
        end
        if sum(trak.strobes) == 0,
            strobeCount = 0;
        else,
            strobeCount = sum(abs(diff(trak.strobes)))/2;
        end
        set(guiH.strobesTxt,'String', int2str(strobeCount));
    end
    %START OF AUTO-TRACKING
    if strcmp( trak.method, 'Manual'),
        manualDigitize( 'allMarkers' );
    else,
        %First, estimate the position of the marker in the next window
        %parse out a local history of the marker positions
        if iFrame < gv.polyPts+1,
            iLocalFrames = 1:iFrame;
        else,
            iLocalFrames = iFrame-gv.polyPts:iFrame;
        end
        %use local history to predict current point
        localPts = mTraj(iLocalFrames, :);
        t = trak.t(iLocalFrames);

        if ~isempty( enabledMarkers ),
            firstVisible = enabledMarkers(1);
            for iMarker = enabledMarkers,
                %The first step is to estimate the marker position given
                %the recent history of tracked marker positions (i.e. ~NaN)
                goodI = find(~any(isnan(mTraj(iLocalFrames, :)),2));
                if isempty( goodI ),
                    %if there are no visible points in the recent history, prompt user to select marker
                    [xHat, yHat] = ginput(1);
                else,
                    %Use Cartesian space (Xpoly) prediction if specified OR
                    %if tracking the first marker
                    if iMarker == 1 | strcmp(gv.predMode, 'Xpoly'),
                        pX = polyfit( t(goodI)', localPts(goodI, iMarker*2-1), gv.polyOrder);
                        pY = polyfit( t(goodI)', localPts(goodI, iMarker*2), gv.polyOrder);
                        xHat = polyval( pX, t(end) );
                        yHat = polyval( pY, t(end) );
                    else,
                        %extrapolate in joint space for remaining markers

                        seg = localPts(:, iMarker*2-1:iMarker*2) - localPts(:, firstVisible*2-1:firstVisible*2);
                        [q, r] = cart2pol( seg(:,2), seg(:,1) );

                        pq = polyfit( t(goodI)', q(goodI), gv.polyOrder);
                        qHat = polyval( pq, t(end) );
                        pr = polyfit( t(goodI)', r(goodI), gv.polyOrder);
                        rHat = polyval( pr, t(end) );

                        %rHat = mean( r(~isnan(r) ));
                        [dy, dx] = pol2cart( qHat, rHat );

                        xHat = X0(1) + dx;
                        yHat = X0(2) + dy;
                    end
                end

                [xCent, yCent, problemFlag] = mtFindMarker(curImage, xHat, yHat, iMarker, trak.method);

                %if using an autoTracking method, verify marker identity (size or shape)
                if ~strcmp( trak.method, 'manual' ),
                    refMarkerSize = mtNanmean(trak.curMarkerSize(1:iFrame-1,iMarker));
                    tolMarkerSize = gv.sizeTol(iMarker)*mtNanstd(trak.curMarkerSize(1:iFrame-1,iMarker));

                    %validate marker size
                    if tolMarkerSize == 0 | ...
                            abs(trak.curMarkerSize(iFrame, iMarker) - refMarkerSize) > tolMarkerSize,
                        pause(0.001);
                        beep;
                        set(guiH.commentTxt, 'String', ...
                            sprintf('%s Marker:\nSPACEBAR => ACCEPT\nor\nLEFT CLICK => NEW CENTER\nor\nRIGHT CLICK => CANCEL',...
                            gv.mrkrLabels{iMarker}));
                        [xCentMouse, yCentMouse, butn] = ginput(1);
                        if butn == 1,
                            mTraj(iFrame, iMarker*2-1:iMarker*2) = [xCentMouse, yCentMouse];
                        elseif butn == 32,
                            %mTraj already updated in the findMarkers function
                        else,
                            mTraj(iFrame, iMarker*2-1:iMarker*2) = NaN;
                            %gv.boxH(iMarker) = NaN;
                            mtGUI('stop');
                            return;
                        end
                    end %if point is bad
                end
                X0 = mTraj( iFrame, firstVisible*2-1:firstVisible*2 ); %reset position of base marker
            end %markers loop
        end
        pause(0.001);
    end

    mtGUI('updateMarkers');
    %abort tracking at last frame
    if iFrame == trak.nF*gv.fpf,
        msgbox('END OF FILE');
        RUNNING == 0;
    end
end
mtGUI('stop');
