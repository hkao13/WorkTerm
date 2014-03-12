function mtLoadFiles(fname, ftype)

global gv;
global trak;
global guiH;
global controlH;
global fullImage;

switch ftype,
    case 'vidFile',
        aviFileTxtH = guiH.aviFileTxt;
        set(aviFileTxtH, 'String', fname );
        fileInfo = aviinfo( fname );    
        
        %gv.fname = fileInfo.Filename;
        gv.nHp = fileInfo.Width;
        gv.nVp = fileInfo.Height;
        gv.fps = fileInfo.FramesPerSecond;
        gv.useStrobe = 0;
        
        trak.nF = fileInfo.NumFrames;
        trak.iFrame = 1;
        trak.iKeyFrame = 1;
        trak.iField = 1;
        
        fullImage = aviread( fname, trak.iKeyFrame );
        if length(size(fullImage.cdata))==2,
            fullImage = mtIndex2rgb( fullImage.cdata, fullImage.colormap );
        else,
            fullImage = fullImage.cdata;
        end
        if get(guiH.invertBox, 'Value'),
            fullImage = uint8(-1*(double(fullImage) - 255));
        end
        guiH.image = image( fullImage, 'Parent', guiH.ax);
        
        %extract the first field from the full image
        curImage = mtGetSubImage( fullImage, gv.videoFormat, trak.iField );

        if strcmp( gv.side, 'Left' ),
            curImage = flipdim( curImage, 2);
        end
        
        set(guiH.ax, 'Xlim', [1 gv.nHp] );
        set(guiH.ax, 'Ylim', [1 gv.nVp] );
        set( guiH.image, 'CData', curImage );
        
        set( guiH.commentTxt, 'String', 'Select a video format from the popup menu or Load a Parameters File' );
        set(guiH.nMarkersButn, 'Enable', 'On');
        set(guiH.params, 'Enable', 'On');
        set(guiH.loadMatButn, 'Enable','On');
        set(guiH.plotButn, 'Enable','On');
        set(guiH.reviewButn, 'Enable','On');
        set( guiH.frameNumTxt, 'String', num2str( trak.iFrame ) );
        nFrames = trak.nF*gv.fpf;
        set( guiH.totalFramesTxt, 'String', sprintf(' of %d', nFrames) );
        step1 = 1 / (nFrames - 1);
        step2 = round(.2*gv.fps*gv.fpf) / (nFrames - 1);
        set( guiH.frameNumSldr, 'Max', nFrames, 'SliderStep', [step1 step2]);
        
        
    case 'mtData',
        load(fname,'gv','trak','mTraj','caldMarkers');
        assignin('base','gv',gv);
        assignin('base','trak',trak);
        assignin('base','mTraj',mTraj);
        assignin('base','caldMarkers',caldMarkers);
        
        %check for "old file" format and convert to new format
        if isfield( gv, 'fname'),
            trak.fname = gv.fname;
            gv = rmfield( gv, 'fname');
        end
        if isfield( gv, 't'),
            trak.t = gv.t;
            gv = rmfield( gv, 't');
        end
        if isfield( gv, 'nF'),
            trak.nF = gv.nF;
            gv = rmfield( gv, 'nF');
        end
        if isfield( gv, 'strobes'),
            trak.strobes = gv.strobes;
            gv = rmfield( gv, 'strobes');
        end
        if isfield( gv, 'curMarkerSize'),
            trak.curMarkerSize = gv.curMarkerSize;
            gv = rmfield( gv, 'curMarkerSize');
        end
        if isfield( gv, 'refMarkerSize'),
            gv = rmfield( gv, 'refMarkerSize');
        end
        if isfield( gv, 'boxH'),
            gv = rmfield( gv, 'boxH');
        end
        if ~isfield( trak, 'iFrame'),
            trak.iFrame = 1;
            trak.iField = 1;
            trak.iKeyFrame = 1;
        end
        if ~isfield(gv, 'useStrobe'),
            gv.useStrobe = 1;
        end
        if ~isfield(gv, 'strobePolarity'),
            gv.strobePolarity = -1;
        end
        
        if ~isfield( guiH, 'manTrak' ),
            addManTrakButns;
        end
        
        if isempty( controlH ),
            controlH = buildMTcontrolGui;
        else,
            if ishandle( controlH.fig ),
                close( controlH.fig );
            end
            controlH = [];
            controlH = buildMTcontrolGui;
        end
        %re-initialized handle variables
        guiH.boxs(1:gv.nMarkers) = NaN;
        guiH.mCent(1:gv.nMarkers) = NaN;
        
        %verify that the .avi and .mat files match
        if trak.nF*gv.fpf ~= size(mTraj(:,1)),
            msgbox('MAT file does not match AVI file','File Mismatch','warn');
        end
        %adjust image axis properties
        set(guiH.ax, 'Xlim', [1 gv.nHp] );
        set(guiH.ax, 'Ylim', [1 gv.nVp] );
        
        if ~all(all(isnan(mTraj))),
            set(guiH.startButn, 'Enable','On');
            set(guiH.menuAutoTrak, 'Enable','On');
            set(guiH.manTrakMenu, 'Enable','On');
            set(guiH.anglesMenu, 'Enable','On');
            set(guiH.saveFileButn, 'Enable','On');
            set(guiH.plotButn, 'Enable','On');
            set(guiH.reviewButn, 'Enable','On');
            for j = 1:gv.nMarkers,
                set(guiH.manTrak(j), 'Enable','On');
            end
        end
        
%         set( guiH.manTrakButn, 'Enable', 'On');
        nEnabled = max(find(gv.mrkrEnable));
        if nEnabled > 1,
            trak.iFrame = max(find(~any(isnan(mTraj(:, 1:nEnabled*2)),2)));
        else,
            trak.iFrame = max(find(~any(isnan(mTraj),2)));
        end            
        if isempty(trak.iFrame),
            trak.iFrame = 1;
        end
        nFrames = gv.fpf*trak.nF;
        
        if ~isfield( trak, 'stepEvents'),
            trak.stepEvents = zeros(nFrames,4);
        end
        if ~isfield( trak, 'segments'),
            trak.segments = zeros(nFrames,1);
        end
        
        set( guiH.frameNumTxt, 'String', num2str(trak.iFrame) )
        set( guiH.totalFramesTxt, 'String', num2str(nFrames) )
        step1 = 1 / (nFrames - 1);
        step2 = round(.2*gv.fps*gv.fpf) / (nFrames - 1);
        set( guiH.frameNumSldr, 'Max', nFrames, 'SliderStep', [step1 step2]);
        
        set( guiH.format, 'Value', gv.videoFormat );
        mtGUI('setFrame');
        mtGUI('updateDisplay');
        set(guiH.commentTxt, 'String', 'Use MANUAL to manually locate the markers or AUTO to continue existing session' );
end
