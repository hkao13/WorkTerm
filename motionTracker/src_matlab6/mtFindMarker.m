function [xCent, yCent, problemFlag] = findMarker( curImage, xi, yi, iMarker, method );
% [xCent, yCent, problemFlag] = findMarker( xi, yi, iMarker, method );
% by: Doug Weber
% last edit: 11/30/2002
% location: motionTracker toolbox
% purpose: identify the location (centroid) of the current marker (iMarker)
% INPUTS:
%   [xi, yi]: estimated location marker location
%   iMarker: marker number
%   method:  method for locating marker

global gv;
global guiH;
global trak;
global mTraj;
global controlH;
nIndexLevels = 64; %number of levels in the indexed image

problemFlag = 0;
orig_xi = xi; % make sure these values aren't lost
orig_yi = yi;

if nargin < 4,
    method = 'mrkrSize';
end

iFrame = trak.iFrame;
%sets the threshold for determinin if the number of pixels is significantly larger than the reference
threshScaleFactor = 1.5; 

mThresh = nIndexLevels/2;
bfSize = 3; %boxcar filter size (pixels)
%gfs = 101; gfsd = 0.65; %NOTE: Gaussian filter parameters (DISCONTINUED)

nHpixels = gv.nHp; nVpixels = gv.nVp;

colorInvert = gv.mrkrInvert(iMarker);

switch method,    
case 'centroid',
    windowSize = gv.mrkrSize(iMarker);
    hws = ceil(windowSize/2);
    minHWS = hws;
    
    [refIdx, crnrs] = makeRefIdx( hws, xi, yi );

    %extract subwindow (sw)
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : );
    %reassign reference dot image
    gv.refDot{iMarker} = Sw;
    
    %NOTE: gaussian filter is too slow; boxcar works good
    smSw = uint8( smooth3( Sw, 'box', bfSize ));
    smGraySw = mtRgb2Gray( smSw, nIndexLevels );
    if gv.mrkrInvert(iMarker) == 1,
        smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
    end
    %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
    %[linear index of pixel, x index, y index, intensity]
    refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
        
    %find centroid of suprathreshold points
    stPixels = refImage( refImage(:, end) > mThresh, : );
    
    xCent = sum( stPixels(:, 2) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    yCent = sum( stPixels(:, 3) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    
    trak.curMarkerSize(iFrame, iMarker) = size( stPixels, 1 );
    trak.refMarkerSize(iMarker) = trak.curMarkerSize(iFrame, iMarker);
    
    mTraj( iFrame, iMarker*2-1:iMarker*2) = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1;
       
case 'hotSpot',
    set(guiH.ax,'NextPlot','add');
    windowScalar = gv.mrkrSizeX(iMarker);
    
    %1st iteration: scale boxes by UI scalar
    windowSize = gv.mrkrSize(iMarker)*windowScalar;   
    hws = ceil(windowSize/2);
    
    [refIdx, crnrs] = makeRefIdx( hws, xi, yi );
    rectangle('Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1], 'Edgecolor', ' y')
    
    %extract subwindow (sw)
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
    %NOTE: gaussian filter is too slow; boxcar works good
    smSw = uint8( smooth3( Sw, 'box', bfSize ));
    smGraySw = mtRgb2Gray( smSw, nIndexLevels );
    if gv.mrkrInvert(iMarker) == 1,
        smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
    end
    
    %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
    %[linear index of pixel, x index, y index, intensity]
    refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
    %rank-order pixels and take the centroid of the five brightest pixels
    refImage = sortrows(refImage, 4);
    refImage = flipud(refImage);
    stPixels = refImage(1:5,:);
    xi = mean(stPixels(:,2));
    yi = mean(stPixels(:,3));
    newCent = [xi + crnrs(1,1), yi + crnrs(2,1)] - 1;    
    plot(newCent(1), newCent(2), 'yo', 'MarkerSize', 10,'Parent',guiH.ax)    
    %1st iteration complete

    %2nd Iteration
    windowScalar = mean([1; windowScalar]);
    windowScalar(windowScalar<1) = 1; %make sure the multiplier is >= 1
    
    windowSize = gv.mrkrSize(iMarker)*windowScalar;    
    hws = ceil(windowSize/2);
    
    [refIdx, crnrs] = makeRefIdx( hws, newCent(1), newCent(2) );
    rectangle('Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1],'Edgecolor','g')
    
    %extract subwindow (sw)
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
    %NOTE: gaussian filter is too slow; boxcar works good
    smSw = uint8( smooth3( Sw, 'box', bfSize ));
    smGraySw = mtRgb2Gray( smSw, nIndexLevels );
    if gv.mrkrInvert(iMarker) == 1,
        smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
    end
    %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
    %[linear index of pixel, x index, y index, intensity]
    refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
    
    refImage = sortrows(refImage, 4);
    refImage = flipud(refImage);
    stPixels = refImage(1:5,:);
    xi = mean(stPixels(:,2));
    yi = mean(stPixels(:,3));
    newCent = [xi + crnrs(1,1), yi + crnrs(2,1)] - 1;        
    plot(newCent(1), newCent(2), 'go', 'MarkerSize', 7,'Parent',guiH.ax)    

    
    %third and final iteration    
    windowSize = gv.mrkrSize(iMarker);    
    hws = ceil(windowSize/2);
    
    [refIdx, crnrs] = makeRefIdx( hws, newCent(1), newCent(2) );
%     if ~isnan(guiH.boxs(iMarker)),
%         set( guiH.boxs(iMarker), 'Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1],'Edgecolor','r');
%     else,
%         guiH.boxs(iMarker) = rectangle('Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1],'Edgecolor','r');
%     end
    
    %extract subwindow (sw)
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
    
    %NOTE: gaussian filter is too slow; boxcar works good
    smSw = uint8( smooth3( Sw, 'box', bfSize ));
    smGraySw = mtRgb2Gray( smSw, nIndexLevels );
    if gv.mrkrInvert(iMarker) == 1,
        smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
    end
    %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
    %[linear index of pixel, x index, y index, intensity]
    refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];    
    stPixels = refImage( refImage(:, end) > mThresh, : );
    trak.curMarkerSize(iFrame, iMarker) = size( stPixels, 1 );
    
    xCent = sum( stPixels(:, 2) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    yCent = sum( stPixels(:, 3) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    

    mTraj( iFrame, iMarker*2-1:iMarker*2) = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1; 
    %temporary change, 10/18/2003
    if iMarker>1 % if not first marker
        % calculate distance between this and previous marker
        [angle,distance] = cart2pol( mTraj(iFrame,(iMarker-1)*2-1) - (xCent+crnrs(1,1)-1),...
                                    mTraj(iFrame,(iMarker-1)*2)   - (yCent+crnrs(2,1)-1) );
        [prevangle, prevdistance] = cart2pol( mTraj(iFrame-1,(iMarker-1)*2-1) - mTraj(iFrame-1,(iMarker)*2-1),...
                                        mTraj(iFrame-1,(iMarker-1)*2)   - mTraj(iFrame-1,(iMarker)*2) );                                
        mTraj( iFrame, iMarker*2-1:iMarker*2) = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1;
        if abs(prevdistance-distance) > 0.2*prevdistance |... % if segment length change is too large
           (iMarker>2 & abs(prevangle-angle)>pi/8) % or if angle changed suddenly
            problemFlag = 1;
            
            %%%%%%%%%%%%%%%%%% base prediction on surrounding points from previous frame's marker
            %mTraj( iFrame, iMarker*2-1:iMarker*2) = mTraj( iFrame-1, iMarker*2-1:iMarker*2); % use previous frame's value
            [refIdx, crnrs] = makeRefIdx( hws, mTraj( iFrame-1, iMarker*2-1), mTraj( iFrame-1, iMarker*2) );            
            rectangle('Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1], 'Edgecolor','b');            
            %extract subwindow (sw)
            Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : );
            
            %NOTE: gaussian filter is too slow; boxcar works good
            smSw = uint8( smooth3( Sw, 'box', bfSize ));
            smGraySw = mtRgb2Gray( smSw, nIndexLevels );
            if gv.mrkrInvert(iMarker) == 1,
                smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
            end
            %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
            %[linear index of pixel, x index, y index, intensity]
            refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
            %find centroid of suprathreshold points
            stPixels = refImage( refImage(:, end) > mThresh, : );
            %testS = stPixels((abs(stPixels(:,2)-1-round(crnrs(1,1)-mTraj( iFrame-1, iMarker*2-1)))<3)&...
            %                 (abs(stPixels(:,3)-1-round(crnrs(2,1)-mTraj( iFrame-1, iMarker*2)))<3),:);
            sCent = [sum( stPixels(:, 2) .* stPixels(:,end) ) ./ sum( stPixels( :,end) )   sum( stPixels(:, 3) .* stPixels(:,end) ) ./ sum( stPixels( :,end) )];
            scrnrs = crnrs; % for plotting point
            mTraj( iFrame, iMarker*2-1:iMarker*2) = [sCent(1)+scrnrs(1,1)-1 sCent(2)+scrnrs(2,1)-1];
            %%%%%%%%%%%%%%%%%% end base prediction on surrounding points from previous frame's marker
            
            
        end % end if distance
    else % if first marker
        mTraj( iFrame, iMarker*2-1:iMarker*2) = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1; 
    end % end if iMarker>1
    
    if problemFlag==1
        %plot( xCent+crnrs(1,1)-1, yCent+crnrs(2,1)-1, ... % plot cyan crosshair (based on orig guess for this frame)
        %'+', 'MarkerSize', 10, 'color', 'c', 'Parent', guiH.ax);
        plot( sCent(1)+scrnrs(1,1)-1, sCent(2)+scrnrs(2,1)-1, ... % plot blue crosshair (based on prev frame), just to know where it would be
        '+', 'MarkerSize', 10, 'color', 'b', 'Parent', guiH.ax);
    else
        set(guiH.mCent(iMarker), 'XData', mTraj(iFrame, iMarker*2-1), 'YData', mTraj(iFrame, iMarker*2));
%         plot( mTraj(iFrame, iMarker*2-1), mTraj(iFrame, iMarker*2), ... % plot red crosshair
%         '+', 'MarkerSize', 10, 'color', 'r', 'Parent', guiH.ax);
    end % end if problemFlag==1
    

case 'matchDot',
    refDot = gv.refDot{iMarker};
    RI = mtRgb2Gray(refDot, nIndexLevels);
    if gv.mrkrInvert(iMarker) == 1,
        RI = -1*(RI-nIndexLevels); %this equation inverts the indexed image
    end
%     RI = 255*(RI-min(min(RI)))/range(reshape(RI, prod(size(RI)),1));
    
    set(guiH.ax,'NextPlot','add');
    ms = gv.mrkrSize(iMarker);
    windowScalar = gv.mrkrSizeX(iMarker);
    
    %1st iteration: scale boxes by UI scalar
    windowSize = ms*windowScalar;   
    hws = ceil(windowSize/2);
    
    XCmin = round(xi) - hws;
    YCmin = round(yi) - hws;
    if XCmin < ceil(ms/2), XCmin = ceil(ms/2); end;
    if YCmin < ceil(ms/2), YCmin = ceil(ms/2); end;
    if XCmin > gv.nHp - ceil(ms/2)+1; XCmin = gv.nHp - ceil(ms/2)+1; end;
    if YCmin > gv.nVp - ceil(ms/2)+1; YCmin = gv.nVp - ceil(ms/2)+1; end;
    if XCmin+windowSize > gv.nHp, XCmin = gv.nHp - windowSize; end
    if YCmin+windowSize > gv.nVp, YCmin = gv.nVp - windowSize; end

    rectangle('Position', [XCmin YCmin 2*hws 2*hws], 'EdgeColor', [.5 .5 .5], 'linewidth', 0.5);

    XCmax = XCmin+windowSize;
    YCmax = YCmin+windowSize;
    %extract subwindow (sw)
    Sw = curImage( YCmin:YCmax, XCmin:XCmax, : ); 
    SI = mtRgb2Gray(Sw, nIndexLevels);
    if gv.mrkrInvert(iMarker) == 1,
        SI = -1*(SI-nIndexLevels); %this equation inverts the indexed image
    end
%     SI = (SI-min(min(SI)))/range(reshape(SI, prod(size(SI)),1));
    E = filter2(RI, SI, 'same');
    [maxx, maxi] = max(reshape(E, prod(size(E)),1));
    xi = XCmin + ceil(maxi/size(E,1))-1;
    yi = YCmin + rem(maxi, size(E,1))-1;
        
    hws = ceil( str2num( get( controlH.mrkrSize(iMarker), 'String' ) )/2 );
    crnrs1 = [round(xi) - hws, round(xi) + hws; round(yi) - hws, round(yi) + hws];
    rectangle('Position', [crnrs1(1,1) crnrs1(2,1) 2*hws+1 2*hws+1],'Edgecolor','g')
        
    %move xi, yi to centroid of the box
    [refIdx, crnrs] = makeRefIdx( hws, xi, yi );    
    %extract subwindow (sw)
    Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : ); 
    %NOTE: gaussian filter is too slow; boxcar works good
    smSw = uint8( smooth3( Sw, 'box', bfSize ));
    smGraySw = mtRgb2Gray( smSw, nIndexLevels );
    if gv.mrkrInvert(iMarker) == 1,
        smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
    end

    %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
    %[linear index of pixel, x index, y index, intensity]
    refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
    stPixels = refImage( refImage(:, end) > mThresh, : );
    trak.curMarkerSize(iFrame, iMarker) = size( stPixels, 1 );
    
    xCent = sum( stPixels(:, 2) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    yCent = sum( stPixels(:, 3) .* stPixels(:,end) ) ./ sum( stPixels( :,end) );
    
    newCent = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1;        
    
    %coordinates of marker centroid
    xi = newCent(1); yi = newCent(2);
    
    problemFlag = 0;
    
    mTraj( iFrame, iMarker*2-1:iMarker*2) = [xCent + crnrs(1,1), yCent + crnrs(2,1)] - 1;
    if iMarker>1 % if not first marker
        % calculate distance between this and previous marker
        [angle,distance] = cart2pol( mTraj(iFrame,(iMarker-1)*2-1) - (xCent+crnrs(1,1)-1),...
                                    mTraj(iFrame,(iMarker-1)*2)   - (yCent+crnrs(2,1)-1) );
        [prevangle, prevdistance] = cart2pol( mTraj(iFrame-1,(iMarker-1)*2-1) - mTraj(iFrame-1,(iMarker)*2-1),...
                                        mTraj(iFrame-1,(iMarker-1)*2)   - mTraj(iFrame-1,(iMarker)*2) );
                                    
        if abs(prevdistance-distance) > 0.1*prevdistance |... % if segment length change is too large
           (iMarker>2 & abs(prevangle-angle)>pi/8) % or if angle changed suddenly
            problemFlag = 1;
            
            %%%%%%%%%%%%%%%%%% base prediction on surrounding points from previous frame's marker
            %mTraj( iFrame, iMarker*2-1:iMarker*2) = mTraj( iFrame-1, iMarker*2-1:iMarker*2); % use previous frame's value
            [refIdx, crnrs] = makeRefIdx( hws, mTraj( iFrame-1, iMarker*2-1), mTraj( iFrame-1, iMarker*2) );            
            rectangle('Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1], 'Edgecolor','b');            
            %extract subwindow (sw)
            Sw = curImage( crnrs(2,1):crnrs(2,2), crnrs(1,1):crnrs(1,2), : );
            
            %NOTE: gaussian filter is too slow; boxcar works good
            smSw = uint8( smooth3( Sw, 'box', bfSize ));
            smGraySw = mtRgb2Gray( smSw, nIndexLevels );
            if gv.mrkrInvert(iMarker) == 1,
                smGraySw = -1*(smGraySw-nIndexLevels); %this equation inverts the indexed image
            end
            %create a matrix of pixel coordinates (refIdx) and intensities (smGraySw)
            %[linear index of pixel, x index, y index, intensity]
            refImage = [refIdx, reshape( smGraySw, size(smGraySw,1)*size(smGraySw,2), 1 )];
            %find centroid of suprathreshold points
            stPixels = refImage( refImage(:, end) > mThresh, : );
            %testS = stPixels((abs(stPixels(:,2)-1-round(crnrs(1,1)-mTraj( iFrame-1, iMarker*2-1)))<3)&...
            %                 (abs(stPixels(:,3)-1-round(crnrs(2,1)-mTraj( iFrame-1, iMarker*2)))<3),:);
            sCent = [sum( stPixels(:, 2) .* stPixels(:,end) ) ./ sum( stPixels( :,end) )   sum( stPixels(:, 3) .* stPixels(:,end) ) ./ sum( stPixels( :,end) )];
            scrnrs = crnrs; % for plotting point
            mTraj( iFrame, iMarker*2-1:iMarker*2) = [sCent(1)+scrnrs(1,1)-1 sCent(2)+scrnrs(2,1)-1];
            %%%%%%%%%%%%%%%%%% end base prediction on surrounding points from previous frame's marker
        end % end if distance
    end % end if iMarker>1
    
    if problemFlag==1
        plot( sCent(1)+scrnrs(1,1)-1, sCent(2)+scrnrs(2,1)-1, ... % plot blue crosshair (based on prev frame), just to know where it would be
            '+', 'MarkerSize', 10, 'color', 'b', 'Parent', guiH.ax);
    else
        set( guiH.mCent(iMarker), 'XData', mTraj(iFrame, iMarker*2-1), 'YData', mTraj(iFrame, iMarker*2), 'LineWidth', 2);
%         set( guiH.boxs(iMarker), 'Position', [crnrs(1,1) crnrs(2,1) 2*hws+1 2*hws+1],'Edgecolor','r', 'LineWidth', 2);
    end % end if problemFlag==1
     
end % end switch



