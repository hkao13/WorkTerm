function mtGUI(mtAction)
% mtGUI( action  );
% by: Doug Weber
% last edit: 11/27/2004
% location: motionTracker toolbox
%
% purpose: this function contains most of the "action" routines
% called by the GUI of the motionTracker program
%*******************
% revision history:
%*******************
% 9/8/2003: added code for joint angles calculations, angles stored in the
% "trak" structure, angle definition parameters stored in "gv" structure
%*******************

global gv;
global trak;
global captureFolder;
global captureFile;
global curImage;
global fullImage;

global RUNNING;

global mTraj;
global caldMarkers;
global guiH;
global controlH;

switch mtAction,
    case 'loadParameters',
        if isempty(gv.nMarkers),
            NEEDSINIT=1;
        else,
            NEEDSINIT = 0;
        end
        [paramFile, paramFolder] = uigetfile( sprintf('%s*_mtParams.mat', captureFolder), 'Select a Parameters file');
        if paramFile == 0,
            return;
        end
        File = fullfile(paramFolder, paramFile);
        load(File);
        %     eval(['load ', sprintf('%s%s', paramFolder, paramFile)]);
        
        if NEEDSINIT,
            mtGUI('initVariables');
        end
        set(guiH.ax,'NextPlot','add');
        for iMarker = 1:gv.nMarkers,
            guiH.mCent(iMarker) = plot( 0, 0, '+', 'Color', 'r', 'MarkerSize',10, 'Parent', guiH.ax );
            guiH.boxs(iMarker) = rectangle('Position', [0 0 0.01 0.01], 'EdgeColor', 'r');
        end
        gv.mrkrLabels = gv.mrkrLabels(1:gv.nMarkers);
        if ~isfield(gv, 'strobePolarity'),
            gv.strobePolarity = -1;
        end
        if ~isfield(gv, 'useStrobe'),
            gv.useStrobe = 0;
        end
        
        controlH = buildMTcontrolGui;        
        addManTrakButns;
        set( guiH.format, 'Value', gv.videoFormat );
        mtGUI('setVideoFormat');                
        set(guiH.commentTxt, 'String', 'Use MANUAL to manually locate the markers or AUTO to continue existing session' );
        
    case 'saveParameters',
        [paramFile, paramFolder] = uiputfile( sprintf('%s*_mtParams.mat', captureFolder), 'Select file to save parameters in');
        if paramFile == 0,
            return;
        end
        
        if findstr( paramFile, '_mtParams'),
            paramFile = paramFile(1:findstr(paramFile, '_mtParams')-1);
        end
        File = fullFile(paramFolder, sprintf('%s_mtParams.mat',paramFile));
        save(File,'gv');    
        
    case 'saveCalibrationFile',
        [calFile, calFolder] = uiputfile( sprintf('%s*_mtCalib.mat', captureFolder), 'Select file to save parameters in');
        if calFile == 0,
            return;
        end
        if findstr( calFile, '_mtCalib'),
            calFile = calFile(1:findstr(calFile, '_mtCalib')-1);
        end
        nPoints = size(mTraj,2)/2;
        fm = questdlg('Is there a "Fixed Marker" in the data set?','Fixed marker?','First Marker','Last Marker','None','None');
        switch fm,
            case 'First Marker',
                mTraj = mTraj(:,3:end)-repmat(mTraj(:,1:2), 1, nPoints-1);
                nPoints = nPoints-1;
            case 'Last Marker',
                mTraj = mTraj(:,1:end-2)-repmat(mTraj(:,end-1:end),1, nPoints-1);
                nPoints = nPoints-1;
        end                
        cal = [];
        
        if nPoints ~= 4,
            h = errordlg('Warning, Incorrect number of calibration points');
            waitfor(h);
        else,
            for i = 1:4,
                answ = inputdlg(sprintf('Enter the real world coordinates [0,0] of marker %d', i), 'Real-world coordinates');
                cal.rw(1, i*2-1:i*2) = str2num(answ{1});
            end
            cal.m = mTraj(~any(isnan(mTraj),2),:);
            File = fullfile(calFolder, sprintf('%s_mtCalib.mat',calFile));
            save(File,'cal');
        end
        
    case 'setNmarkers',
        butn = questdlg('How many markers would you like to track?', ...
            'Number of Markers?', '5', '6', 'Other', '5');
        switch butn,
            case '5',
                gv.nMarkers = 5;            
            case '6',
                gv.nMarkers = 6;
            otherwise,
                gv.nMarkers = str2num(char(inputdlg('How many markers (1 to 21)?')));
        end
        labelList = evalin('base', 'labelList');
        for iMarker = 1:gv.nMarkers,
            gv.mrkrLabels{iMarker} = labelList{iMarker};    
        end
        
        mtGUI('initVariables');
        
        %initialize default values for marker properties
        gv.mrkrInvert = zeros(1,gv.nMarkers);
        gv.mrkrEnable = ones(1,gv.nMarkers);
        gv.mrkrLink = ones(1,gv.nMarkers-1);    
        gv.mrkrSize = ones(1,gv.nMarkers)*10;
        gv.mrkrSizeX = ones(1,gv.nMarkers).*2;
        gv.sizeTol(1:gv.nMarkers) = 8;
        
        %update the display in the configurator window
        if ~isempty( controlH ),
            if ishandle( controlH.fig ),
                close(controlH.fig);
            end
            
        end
        controlH = buildMTcontrolGui;
        
        addManTrakButns;
        set( guiH.anglesMenu, 'Enable', 'On');
        mtGUI('updateDisplay');
        set(guiH.commentTxt, 'String', 'Start tracking by clicking the "MANUAL" button' );
        
    case 'loadFile',
        %    set(guiH.format, 'Value', 1);
        if ~isempty( mTraj ),
            saveFile = questdlg('Would you like to save your work', 'Save File?', 'Yes','No','Yes');
            if strcmp(saveFile,'Yes'),
                mtGUI('saveFile');
            end
        end
        evalin('base', 'mtInitialize');
        [captureFile, captureFolder] = uigetfile( sprintf('%s*.avi', captureFolder), 'Select a movie file');
        File = fullfile(captureFolder, captureFile);
        
        if captureFile ~= 0,
            mtLoadFiles(File, 'vidFile');
            
            %if .mat file exists, then load the mat file
            froot = captureFile(1:min(findstr(captureFile,'.')-1));
            froot = [froot, 'm.mat'];
            File = fullfile(captureFolder, froot);
            
            if ~isempty(dir(File)),
                mtLoadFiles(File,'mtData');
            else,
                if gv.videoFormat > 1,
                    mtGUI('setVideoFormat');
                end
                if ~isempty( gv.nMarkers ),
                    mtGUI('initVariables');
                end
            end
        end
        
    case 'loadNewFileText',
        if ~isempty( mTraj ),
            saveFile = questdlg('Would you like to save your work', 'Save File?', 'Yes','No','Yes');
            if strcmp(saveFile,'Yes'),
                mtGUI('saveFile');
            end
        end
        evalin('base', 'mtInitialize');
        set(guiH.format, 'Value', 1);    
        
        inFile = get(guiH.aviFileTxt, 'String');
        captureFolder = inFile(1:max(findstr(inFile,'\')));
        captureFile = inFile(max(findstr(inFile,'\'))+1:end);    
        %complete filename with path
        File = fullfile(captureFolder, captureFile);
        
        if ~isempty(dir(File)),
            mtLoadFiles(File, 'vidFile');
            
            %if .mat file exists, then load the mat file
            froot = captureFile(1:min(findstr(captureFile,'.')-1));
            froot = [froot, 'm.mat'];
            File = fullfile(captureFolder, froot);
            if ~isempty(dir(File)),
                mtLoadFiles(File,'mtData');
            else,
                if gv.videoFormat > 1,
                    mtGUI('setVideoFormat');
                end
                if ~isempty( gv.nMarkers ),
                    mtGUI('initVariables');
                end
            end
        else,
            h=errordlg('File not found', 'no file');
            waitfor(h);
        end
        
    case 'initVariables',
        %truncate marker label vector
        %initialize these globals to default values
        nFrames = trak.nF*gv.fpf;
        
        trak.curMarkerSize(1:nFrames, 1:gv.nMarkers) = NaN;
        
        mTraj = [];
        mTraj(1:nFrames, 1:gv.nMarkers*2) = NaN;
        set(guiH.totalFramesTxt, 'String', sprintf(' of %d', nFrames));    
        
    case 'back1',    
        if trak.iFrame == 1,
            msgbox('MINIMUM FRAME NUMBER IS 1','Beginning of File','warning');
        else,
            trak.iFrame = trak.iFrame - 1;
            trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
            trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;
            mtGUI('updateDisplay');
            set(guiH.frameNumTxt, 'String', num2str(trak.iFrame))
            set(guiH.frameNumSldr, 'Value', trak.iFrame);
        end
        
    case 'forward1',
        if trak.iFrame == trak.nF*gv.fpf,
            msgbox('END OF MOVIE','END of File','warning');
        else,
            trak.iFrame = trak.iFrame + 1;
            trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
            trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;
            set(guiH.frameNumTxt, 'String', num2str(trak.iFrame))
            set(guiH.frameNumSldr, 'Value', trak.iFrame);
            mtGUI('updateDisplay');
        end
    case 'start',
        RUNNING = 1;
        set(guiH.stopButn, 'Enable','On');
        set(guiH.startButn, 'Enable','Off');
        pause(0.001);
        mtGUI('auto');
        
    case 'auto',
        %CALL THE AUTO TRACKING FUNCTION HERE
        mtAutoTracker;
        
    case 'updateDisplay',   
        %update image
        iFrame = trak.iFrame;
        iField = trak.iField;
        iKeyFrame = trak.iKeyFrame;
        set( guiH.frameNumSldr, 'Value', iFrame );
        
        updateStepEventButns;
        %update segment boundaries popup
        if isfield(trak,'segments'),
            s = trak.segments(iFrame);
            set(guiH.segPopup, 'value', s+1);
            nSeg = sum(trak.segments(1:iFrame)==1);
            set(guiH.segTxt, 'String', sprintf('%d',nSeg));
            sstart = max(find(trak.segments(1:iFrame)==1));
            if ~isempty(sstart)
                sstop = min(find(trak.segments(sstart:end)==2));
                sstop = sstart+sstop-1;
                set(guiH.segStartTxt, 'String', sprintf('%d :', sstart));
                set(guiH.segStopTxt, 'String', sprintf(' %d', sstop));
            end
        end
        
        File = fullfile(captureFolder, captureFile);
        fullImage = aviread( File, iKeyFrame );
        if length(size(fullImage.cdata))==2,
            fullImage = mtIndex2rgb( fullImage.cdata, fullImage.colormap );
        else,
            fullImage = fullImage.cdata;
        end
        if get(guiH.invertBox, 'Value'),
            fullImage = uint8(-1*(double(fullImage) - 255));
        end
        
        if gv.videoFormat == 1,
            disp('Select a valid video format');
            curImage = fullImage;    
            set(guiH.commentTxt,'String', 'Select a valid video format');    
            return;
        elseif gv.videoFormat == 2,
            curImage = fullImage;
        else,
            curImage = mtGetSubImage( fullImage, gv.videoFormat, iField );
        end
        
        if ~strcmp( gv.side, 'Right' ),
            curImage = flipdim( curImage, 2);
        end
        
        set(guiH.frameNumTxt, 'String',int2str(iFrame));
        
        figure(guiH.fig);
        set(guiH.ax, 'NextPlot', 'replacechildren');
        guiH.image = image( curImage, 'Parent', guiH.ax);
        set(guiH.ax, 'NextPlot', 'add');
        
        if ~isempty(mTraj),
            if get( guiH.eraserBox, 'Value') == 1,
                mTraj( iFrame, : ) = NaN;
            end            
            for iMarker = 1:gv.nMarkers,
                xCent = mTraj( iFrame, iMarker*2-1); 
                yCent = mTraj(iFrame, iMarker*2);
                hws = str2num( get( controlH.mrkrSize(iMarker), 'String' ) )/2;
                crnrs = round([xCent - hws, xCent + hws; yCent - hws, yCent + hws]);
                guiH.mCent(iMarker) = plot( xCent, yCent, '+', 'Color', 'r', 'MarkerSize',10, 'Parent', guiH.ax );
                
                if any(any(isnan(crnrs))),
                    guiH.boxs(iMarker) = rectangle('Position', [0 0 .01 .01], 'EdgeColor', 'r');
                else,
                    guiH.boxs(iMarker) = rectangle('Position', [crnrs(1,1) crnrs(2,1) diff(crnrs(1,:)) diff(crnrs(2,:))], 'EdgeColor', 'r');
                end
            end
            if ~all(isnan(mTraj(iFrame,:))) & gv.nMarkers > 1,
                [x, y] = jnts2sticks( mTraj(iFrame, :) );
                line(x, y,'LineWidth',2, 'Parent', guiH.ax);
            end
        end
                    
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
            if gv.strobePolarity == -1,
                if gv.strobeIntensity(iFrame) < gv.strobeThresh,
                    trak.strobes(iFrame) = 1;
                end
            else,
                if gv.strobeIntensity(iFrame) > gv.strobeThresh,
                    trak.strobes(iFrame) = 1;
                end
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
        
    case 'setStrobeThresh',
        figure(999)
        plot(gv.strobeIntensity,'r.','MarkerSize',10);
        si = sort(gv.strobeIntensity);
        si(isnan(si))=[];
        if length(si) > 20,
            bg = mean(si(1:20));
            pk = mean(si(end-19:end));
        else,
            bg = si(1);
            pk = si(end);
        end
        si = gv.strobeIntensity;
        si(isnan(si))=[];
        gv.strobeThresh = bg+.3*(pk-bg);

        prompt={sprintf('Background level: mean = %4.2f, Peak = %4.2f', bg, pk)};
        def={sprintf('%4.2f', gv.strobeThresh)};
        dlgTitle='Change strobe threshold?';
        lineNo=1;
        answer=inputdlg(prompt, dlgTitle, lineNo, def);
        if ~isempty(answer),
            gv.strobeThresh = str2num(answer{1});
        end
        close(999)
        trak.strobes(1:end)=0;
        if si(1) < gv.strobeThresh,
            gv.strobePolarity = 1;
            trak.strobes(gv.strobeIntensity > gv.strobeThresh) = 1;
        else,
            gv.strobePolarity = -1;
            trak.strobes(gv.strobeIntensity<gv.strobeThresh) = 1;
        end        
        mtGUI('updateDisplay');
        
    case 'updateMarkers',
        iFrame = trak.iFrame;
        iField = trak.iField;
        iKeyFrame = trak.iKeyFrame;
        
        if ~all(isnan(mTraj(iFrame, :))),
            enabledMarkers = find( gv.mrkrEnable );
            for iMarker = enabledMarkers,
                xCent = mTraj( iFrame, iMarker*2-1); 
                yCent = mTraj(iFrame, iMarker*2);
                hws = str2num( get( controlH.mrkrSize(iMarker), 'String' ) )/2;
                crnrs = round([xCent - hws, xCent + hws; yCent - hws, yCent + hws]);
                set(guiH.mCent(iMarker), 'XData', xCent, 'YData', yCent );
                if ~isnan(crnrs(1,1));
                    set( guiH.boxs(iMarker), 'Position', [crnrs(1,1) crnrs(2,1) diff(crnrs(1,:)) diff(crnrs(2,:))], ...
                        'Edgecolor','r');
                end
                
            end
            
            %compute vertices of the sticks
            if gv.nMarkers > 1,
                [x, y] = jnts2sticks( mTraj(iFrame, :) );
                line(x, y,'LineWidth',2, 'Parent', guiH.ax);
            end
        end
        
    case 'stop',
        %set(guiH.fig, 'Position', [0 0.26 1 0.72]);
        RUNNING = 0;    
        set(guiH.stopButn, 'Enable','Off');
        set(guiH.startButn, 'Enable','On');
        set(guiH.menuAutoTrak, 'Enable','On');
        set(guiH.commentTxt,'String',' ');    
        beep;
        
    case 'saveFile'
        outFile = sprintf('%sm',captureFile(1:findstr(captureFile,'.')-1));
        File = fullfile(captureFolder,outFile);
        save(File,'gv', 'trak', 'mTraj', 'caldMarkers')            
        disp(sprintf('Saved data to %s.mat', outFile))    
        
    case 'saveFileAs'
        outFile = captureFile(1:findstr(captureFile,'.')-1);
        [outFile, outPath] = uiputfile(sprintf('%s%sm.mat', captureFolder, outFile), 'Save Data File?');
        if outFile ~= 0,
            File = fullfile(outPath,outFile);
            save(File,'gv', 'trak', 'mTraj', 'caldMarkers')            
            disp(sprintf('Saved data to %s%s', outPath, outFile))    
        end
                
    case 'loadMatFile',    
        [matFile, matPath] = uigetfile(sprintf('%s*.mat',captureFolder), 'Loat .mat File?');
        if matFile ~= 0,
            File = fullfile(matPath, matFile);
            mtLoadFiles(File,'mtData');
        end
                
    case 'setFrameSldr',
        trak.iFrame = round(get( guiH.frameNumSldr, 'Value'));
        set(guiH.frameNumTxt, 'String', num2str(trak.iFrame));
        mtGUI('setFrame');
        
    case 'setFrame',
        txtFrameNumH = guiH.frameNumTxt;
        trak.iFrame = str2num( get( txtFrameNumH, 'String' ) );    
        set( guiH.frameNumSldr, 'Value', trak.iFrame);
        
        if trak.iFrame < 1,
            trak.iFrame = 1;
        elseif trak.iFrame > trak.nF*gv.fpf,
            trak.iFrame = trak.nF*gv.fpf;
        end
        trak.iKeyFrame = ceil( trak.iFrame / gv.fpf );
        trak.iField = trak.iFrame - (trak.iKeyFrame-1)*gv.fpf;
        
        mtGUI('updateDisplay');
        
    case 'toggleStrobe',    
        if trak.strobes(trak.iFrame),
            trak.strobes(trak.iFrame) = 0;
            set(guiH.markStrobeButn, 'BackgroundColor',[.5 .5 .5],'String','OFF');
        else,
            trak.strobes(trak.iFrame) = 1;
            set(guiH.markStrobeButn, 'BackgroundColor',[1 0 0],'String','ON');
        end
        
    case 'toggleEvent1',
        if trak.stepEvents(trak.iFrame,1)==0,
            trak.stepEvents(trak.iFrame,1) = 1;
            set(guiH.event1Butn, 'BackgroundColor',[1 0 0],'String','LF DOWN');
        elseif trak.stepEvents(trak.iFrame,1)==1,
            trak.stepEvents(trak.iFrame,1) = 2;
            set(guiH.event1Butn, 'BackgroundColor',[0 1 0],'String','LF UP');
        else,
            trak.stepEvents(trak.iFrame,1) = 0;
            set(guiH.event1Butn, 'BackgroundColor',[.5 .5 .5],'String','LF');
        end
        
    case 'toggleEvent2',
        if trak.stepEvents(trak.iFrame,2)==0,
            trak.stepEvents(trak.iFrame,2) = 1;
            set(guiH.event2Butn, 'BackgroundColor',[1 0 0],'String','RF DOWN');
        elseif trak.stepEvents(trak.iFrame,2)==1,
            trak.stepEvents(trak.iFrame,2) = 2;
            set(guiH.event2Butn, 'BackgroundColor',[0 1 0],'String','RF UP');
        else,
            trak.stepEvents(trak.iFrame,2) = 0;
            set(guiH.event2Butn, 'BackgroundColor',[.5 .5 .5],'String','RF');
        end
        
    case 'toggleEvent3',
        if trak.stepEvents(trak.iFrame,3)==0,
            trak.stepEvents(trak.iFrame,3) = 1;
            set(guiH.event3Butn, 'BackgroundColor',[1 0 0],'String','LR DOWN');
        elseif trak.stepEvents(trak.iFrame,3)==1,
            trak.stepEvents(trak.iFrame,3) = 2;
            set(guiH.event3Butn, 'BackgroundColor',[0 1 0],'String','LR UP');
        else,
            trak.stepEvents(trak.iFrame,3) = 0;
            set(guiH.event3Butn, 'BackgroundColor',[.5 .5 .5],'String','LR');
        end
        
    case 'toggleEvent4',
        if trak.stepEvents(trak.iFrame,4)==0,
            trak.stepEvents(trak.iFrame,4) = 1;
            set(guiH.event4Butn, 'BackgroundColor',[1 0 0],'String','RR DOWN');
        elseif trak.stepEvents(trak.iFrame,4)==1,
            trak.stepEvents(trak.iFrame,4) = 2;
            set(guiH.event4Butn, 'BackgroundColor',[0 1 0],'String','RR UP');
        else,
            trak.stepEvents(trak.iFrame,4) = 0;
            set(guiH.event4Butn, 'BackgroundColor',[.5 .5 .5],'String','RR');
        end
        
    case 'setSegmentBounds',
        %set segment index to boundary value
        %(0: intermediate, 1: start of segment, 2: end of segment)
        s = get(guiH.segPopup,'value')-1;
        if s==3, %s = 3 -> clear segment event
            trak.segments(trak.iFrame)=0;
        elseif s==4, %s = 4 -> clear ALL segment events
            trak.segments(1:end)=0;
        else,
            events = trak.segments;
            events(events==0)=[];
            if isempty(events) & s ~= 1,
                h = errordlg('No prior segment-start events found');
                waitfor(h);
            else,
                lastEvent = trak.segments(max(find(trak.segments(1:trak.iFrame)>0)));
                if isempty(lastEvent),
                    lastEvent = 0;
                end
                iLastStartEvent = max(find(trak.segments(1:trak.iFrame)==1));
                iLastStopEvent = max(find(trak.segments(1:trak.iFrame)==2));
                
                if lastEvent == 1 & s==1, %clear all events between last stop event and current frame
                    trak.segments(iLastStopEvent+1:trak.iFrame)=0;
                elseif lastEvent == 2 & s==2, %clear all events between last start event and current frame
                    trak.segments(iLastStartEvent+1:trak.iFrame)=0;
                end
                trak.segments(trak.iFrame) = s;
            end
        end
        mtGUI('updateDisplay');

    case 'locateStrobe',
        iFrame = trak.iFrame;
        gv.useStrobe = 1;
        gv.strobeIntensity(1:length(trak.strobes)) = NaN;
        trak.strobes = zeros(1, length(trak.strobes));
        gv.strobeThresh = 5;
        
%         uiwait(msgbox('Make sure strobe light is ON','Strobe must be OFF','modal'));
        set(guiH.commentTxt, 'String', 'Draw a rectangle around the strobe');

        b = drawRect(guiH.ax, 'r');
        b.xmin(b.xmin < 1)=1;
        b.xmax(b.xmax > gv.nHp) = gv.nHp;
        b.ymin(b.ymin < 1)=1;
        b.ymax(b.ymax > gv.nVp) = gv.nVp;

        gv.strobeBox = round([b.xmin, b.xmax, b.ymin, b.ymax]);
        sb = curImage(gv.strobeBox(3):gv.strobeBox(4), gv.strobeBox(1):gv.strobeBox(2), :);
        gv.strobeImage = sb;
        mtGUI('updateDisplay');
        set(guiH.commentTxt, 'String', 'instructions...');
        
    case 'makePlot',
        nFrames = trak.nF*gv.fpf;        
        strOn = find(trak.strobes == 1);
        if ~isempty(strOn)
            strOn = [strOn(1), strOn(end)];
        else,
            strOn = [0 0];
        end
        if ~isempty(caldMarkers),
            pixOrCal = questdlg('Plot pixel coordinates or calibrated coords.?', 'Pixels or calibrated', 'Pixels', 'Calibrated', 'Calibrated');
        else,
            pixOrCal = 'Pixels';
        end
        
        refM = questdlg('Which marker is the reference?', 'Reference marker', 'Marker 1', 'Marker N', 'None', 'Marker N');
        
        iTD = find(trak.stepEvents(:,3)==1);
        iTU = find(trak.stepEvents(:,3)==2);
        switch refM,
            case 'Marker 1',
                ii = 1:2;
                if strcmp(pixOrCal, 'Pixels'),
                    pdata = mTraj - repmat(mTraj(:, ii), 1, gv.nMarkers);
                else,
                    pdata = caldMarkers - repmat(caldMarkers(:, ii), 1, gv.nMarkers);
                end
            case 'Marker N',
                iMarker = input('Enter marker number: ');
                ii = iMarker*2-1:iMarker*2;
                if strcmp(pixOrCal, 'Pixels'),
                    pdata = mTraj - repmat(mTraj(:, ii), 1, gv.nMarkers);
                else,
                    pdata = caldMarkers - repmat(caldMarkers(:, ii), 1, gv.nMarkers);
                end
            case 'None'                        
                if strcmp(pixOrCal, 'Pixels'),
                    pdata = mTraj;
                else,
                    pdata = caldMarkers;
                end
            otherwise,
                ii = 3:4;
                if strcmp(pixOrCal, 'Pixels'),
                    pdata = mTraj - repmat(mTraj(:, ii), 1, gv.nMarkers);
                else,
                    pdata = caldMarkers - repmat(caldMarkers(:, ii), 1, gv.nMarkers);
                end                
        end
        
        xAx = questdlg('Scale for X-axis?', 'X axis scale', 'seconds', 'frames', 'seconds');
        switch xAx,
            case 'seconds',
                x = trak.t;
                iTD = trak.t(iTD);
                iTU = trak.t(iTU);
                strOn = trak.t(strOn);
            otherwise,
                x = 1:size(pdata,1);
        end
        showStrobe = questdlg('Show strobe events?', 'Show strobes?', 'Yes', 'No', 'No');
        
        %create plots        
        figure(999);
        orient tall
        subplot(4,1,1:2)        
        percentTracked =  sum(all(~isnan(mTraj),2))/size(mTraj,1)*100;
        firstStrobe = min(find( trak.strobes == 1));
        if isempty(firstStrobe),
            firstStrobe = NaN;
        end
                
        plot(pdata(:, 1:2:end), pdata(:, 2:2:end), '.');        
        legend(gv.mrkrLabels, -1);
        xlabel('Horizontal - X');
        ylabel('Vertical - Y');
        axis equal;
        title(sprintf('Tracking results for %s%s\nPercent visible frames: %2.1f %%, First strobe frame: %d', ...
            captureFolder, captureFile, percentTracked, firstStrobe))
                    
        if strcmp(pixOrCal, 'Pixels'),
            flipaxis('y');
        end
                
        ax(1) = subplot(4,1,3);
        plot(x, pdata(:,1:2:end),'-', 'LineWidth', 1.25, 'Parent', ax(1));
        mtVertLine(iTD,'r');
        mtVertLine(iTU,'g');
        
        axis tight;   
        xxyy=axis;
        switch showStrobe,
            case 'Yes',
                mtVertLine(strOn,'m');
        end
        ylabel('X');
        xlabel('Time (frames)');
        title('Horizontal positions, RED = foot-down, GREEN = foot-up');
        
        ax(2) = subplot(4,1,4);
        plot(x, pdata(:,2:2:end),'-', 'LineWidth', 1.25, 'Parent',ax(2));
        mtVertLine(iTD,'r');
        mtVertLine(iTU,'g');
        
        axis tight;   
        xxyy=axis;
        switch showStrobe,
            case 'Yes',
                mtVertLine(strOn,'m');
        end
        ylabel('Y');
        xlabel('Time (frames)');
        title('Vertical positions, RED = foot-down, GREEN = foot-up');
        linkaxes(ax,'x');
                
    case 'flipView',
        if strcmp(gv.side, 'Right'),
            gv.side = 'Left';
        else,
            gv.side = 'Right';
        end
        mTraj(:,1:2:end) = gv.nHp - mTraj(:,1:2:end);
        
        %set(guiH.pickSideButn, 'String', sprintf('%s side', gv.side));
        mtGui('updateDisplay');
        
    case 'toggleEraser',
        if get(guiH.eraserBox, 'Value') == 1,
            set( guiH.startButn, 'Enable', 'Off');
            mtGUI('updateDisplay');
        else,
            if ~all(all(isnan(mTraj))),
                set( guiH.startButn, 'Enable', 'On');
                set(guiH.menuAutoTrak, 'Enable','On');
            end
        end
        
    case 'toggleInverse',
        if get(guiH.invertBox, 'Value') == 1,
            gv.invertImage = 1;
        else,
            gv.invertImage = 0;
        end
        mtGUI('updateDisplay');
        
    case 'setVideoFormat',    
        gv.videoFormat = get( guiH.format, 'Value' );
        gv.firstField = 'not applicable';
        
        if any(gv.videoFormat == [3 4 6 7]),
            gv.sepFields = questdlg( 'Seperate fields or merged fields', 'Seperate/Merged?', 'Seperate', 'Merged', 'Seperate' );
        elseif gv.videoFormat == 5, %must seperate fields in format 5 (120 fps, TALL)
            gv.sepFields = 'Seperate';
        else,
            gv.sepFields = 'Merged';
        end
        
        if gv.videoFormat == 1, 
            %Normal video format, does not require modification of the time base or spatial resolution
            msgbox('Select a valid video format', 'Video format?', 'error');
            set( guiH.commentTxt, 'String', 'Select a video format from the popup menu or Load a Parameters File' );
            
        elseif gv.videoFormat == 2, %30 field per second progressive scan (full frame)
            %Normal video format, does not require modification of the time base or spatial resolution
            gv.fpf = 1;
            
        elseif gv.videoFormat == 3, %60 field per second (2 fields/frame)
            %60 fps interlaced;
            gv.fpf = 2;
            gv.nVp = 480;
            gv.nHp = 720;            
            
        elseif gv.videoFormat == 4,
            %WIDE 120 fps format
            gv.fpf = 4;
            gv.nVp = 218;
            gv.nHp = 720;
            
        elseif gv.videoFormat == 5,
            %TALL 120 fps format
            gv.fpf = 4;
            gv.nVp = 476;%??????
            gv.nHp = 291;%????
            
        elseif gv.videoFormat == 6,
            %high-speed 240 fps format
            gv.fpf = 8;
            gv.nVp = 184;
            gv.nHp = 292;
        elseif gv.videoFormat == 7,
            %custom format
            gv.fpf = 2;
            msg = sprintf('Video format: %d x %d at %3.2f frames/sec, %s fields', ...
                gv.nHp, gv.nVp, gv.fps, gv.sepFields);
            h = msgbox(msg, 'Custom video format');
            waitfor(h);
        end
        %if interlaced fields are to be merged, then the number of fields is cut in half
        if gv.videoFormat > 2 & strcmp( gv.sepFields, 'Merged' ),
            gv.fpf = gv.fpf/2;
        end
        if any(gv.videoFormat == [3 7]) & strcmp( gv.sepFields, 'Seperate'),
            gv.firstField = questdlg( 'Which field is first', 'Field dominance?', 'Lower', 'Upper', 'Lower' );
        end
        
        nFrames = trak.nF * gv.fpf;
        
        %verify that mTraj is the correct size
        if size(mTraj,1) < nFrames,
            mTraj(end+1:nFrames, 1:gv.nMarkers*2) = NaN;
        elseif size(mTraj,1) > nFrames,
            mTraj = mTraj(1:nFrames,:);
        end
        %verify that curMarkerSize is the correct size
        if isfield( trak, 'curMarkerSize'),
            if size(trak.curMarkerSize, 1) < nFrames,
                trak.curMarkerSize(end+1:nFrames, 1:gv.nMarkers*2) = NaN;
            elseif size(mTraj,1) > nFrames,
                trak.curMarkerSize = trak.curMarkerSize(1:nFrames,:);
            end
        end
        
        trak.iFrame = (trak.iKeyFrame-1) * gv.fpf + trak.iField;
        trak.t = (1:nFrames)/(gv.fps*gv.fpf);   
        trak.strobes = zeros(1, nFrames);
        trak.strobeIntensity = zeros(1, nFrames);
        trak.stepEvents = zeros(nFrames,4);
        trak.segments = zeros(nFrames,1);
        set( guiH.frameNumTxt, 'String', num2str( trak.iFrame ) );
        
        %extract the first field from the full image        
        curImage = fullImage(1:gv.nVp, :, 1:3);
        %if the video format is interlaced, then replace the odd lines with a copy of the even lines
        if gv.videoFormat == 4 & strcmp( gv.sepFields, 'Seperate' ),
            curImage(1:2:end-1, :, :) = curImage(2:2:end, :, :);
        elseif gv.videoFormat == 5 & strcmp( gv.sepFields, 'Seperate' ),
            curImage(2:2:end, :, :) = curImage(1:2:end, :, :);
        end
        
        set(guiH.ax, 'Xlim', [1 gv.nHp] );
        set(guiH.ax, 'Ylim', [1 gv.nVp] );
        set(guiH.totalFramesTxt, 'String', sprintf(' of %d', nFrames ));
        
        step1 = 1 / (nFrames - 1);
        step2 = round(.2*gv.fps*gv.fpf) / (nFrames - 1);
        set( guiH.frameNumSldr, 'Max', nFrames, 'SliderStep', [step1 step2]);
        mtGUI('updateDisplay');    
        
        if isempty( gv.nMarkers ),
            set(guiH.commentTxt, 'String', sprintf('3 Options:\n%s\n%s\n%s', '1) Use the "N markers" button to specify number of markers', ...
                '2) Use "Load MAT" button to Load previous tracking session', '3) Load tracking parameters from the "Parameters" menu'));
        else,
            set( guiH.commentTxt, 'String', 'Start tracking with MANUAL or AUTO buttons');
        end    
        
    case 'calWrefMarkers',
        iRefX = strmatch( 'RefX', gv.mrkrLabels );
        iRef0 = strmatch( 'Ref0', gv.mrkrLabels );
        iRefY = strmatch( 'RefY', gv.mrkrLabels );
        if isempty( iRefX ) | isempty( iRef0 ),
            prompt={'Enter the marker numbers for the horizontal calibration (e.g. [RefX, Ref0]', 'Enter the "real-world" calibration distance in mm'};
            def={'[6 7]', '100'};
            dlgTitle='Horizontal Calibration';
            lineNo=1;
            answer=inputdlg(prompt, dlgTitle, lineNo, def);
            iRef = str2num( answer{1} );
            iRefX = iRef(1);
            iRef0 = iRef(2);
            refDX = str2num(answer{2}); %mm
        else,
            prompt={'Enter the "real-world" calibration distance in mm'};
            def={'100'};
            dlgTitle='Horizontal Calibration';
            lineNo=1;
            answer=inputdlg(prompt, dlgTitle, lineNo, def);
            refDX = str2num(answer{1}); %mm
        end
        pixDX = mean( abs(mTraj( ~isnan(mTraj(:, iRefX*2-1)), iRefX*2-1) - mTraj( ~isnan(mTraj(:, iRef0*2-1)), iRef0*2-1) )); %pixels
        varpixDX = std( abs(mTraj( ~isnan(mTraj(:, iRefX*2-1)), iRefX*2-1) - mTraj( ~isnan(mTraj(:, iRef0*2-1)), iRef0*2-1) ));
        Xpix2mm = refDX / pixDX; %mm/pixel
        varXpix2mm = refDX / varpixDX;
        sprintf('Horizontal calibration factor is %5.3f +/- %5.3f mm/pixel', Xpix2mm, varXpix2mm)
        
        if isempty( iRefY ) | isempty( iRef0 ),
            prompt={'Enter the marker numbers for the vertical calibration (e.g. [RefY, Ref0]', 'Enter the "real-world" calibration distance in mm'};
            def={'[8 7]', '100'};
            dlgTitle='Vertical Calibration';
            lineNo=1;
            answer=inputdlg(prompt, dlgTitle, lineNo, def);
            iRef = str2num( answer{1} );
            iRefY = iRef(1);
            iRef0 = iRef(2);
            refDY = str2num(answer{2});
        else,
            prompt={'Enter the "real-world" calibration distance in mm'};
            def={'100'};
            dlgTitle='Vertical Calibration';
            lineNo=1;
            answer=inputdlg(prompt, dlgTitle, lineNo, def);
            refDY = str2num(answer{1});
        end
        pixDY = mean(abs( mTraj( ~isnan(mTraj(:, iRefY*2)), iRefY*2) - mTraj( ~isnan(mTraj(:, iRef0*2)), iRef0*2) ));
        varpixDY = std(abs( mTraj( ~isnan(mTraj(:, iRefY*2)), iRefY*2) - mTraj( ~isnan(mTraj(:, iRef0*2)), iRef0*2) ));
        Ypix2mm = refDY / pixDY;
        varYpix2mm = refDY / varpixDY;
        sprintf('Vertical calibration factor is %5.3f +/- %5.3f mm/pixel', Ypix2mm, varYpix2mm)
        gv.pix2mm = [Xpix2mm Ypix2mm];
        
        caldMarkers = mTraj;
        caldMarkers(:, 1:2:end) = caldMarkers(:,1:2:end)*Xpix2mm;
        caldMarkers(:, 2:2:end) = caldMarkers(:,2:2:end)*-Ypix2mm;
        assignin('base', 'caldMarkers', caldMarkers);
        
    case 'cal2points',
        h=helpdlg('Click on 2 points of KNOWN separation distance', '2-point Calibration');
        uiwait(h)
        [pixX, pixY] = ginput(2);
        pixDX = diff(pixX);
        pixDY = diff(pixY);
        [pixTh, pixS] = cart2pol(pixDX, pixDY); %[radians, theta]
        
        prompt={'Enter the "real-world" calibration distance in mm'};
        def={'100'};
        dlgTitle='2-point Calibration';
        lineNo=1;
        answer=inputdlg(prompt, dlgTitle, lineNo, def);
        actS = str2num(answer{1}); %mm   
        pix2mm = actS / pixS;
        
        sprintf('Calibration factor is %5.3f mm/pixel', pix2mm)
        gv.pix2mm = [pix2mm pix2mm];
        
        caldMarkers = mTraj*pix2mm;
        caldMarkers(:,2:2:end) = -caldMarkers(:,2:2:end);
        assignin('base', 'caldMarkers', caldMarkers);
        
        
    case 'calWmouse',
        h=helpdlg('Click on 2 points for HORIZONTAL Calibration', 'Horizontal Calibration');
        uiwait(h)
        [refX, junk] = ginput(2);
        
        prompt={'Enter the "real-world" calibration distance in mm'};
        def={'100'};
        dlgTitle='Horizontal Calibration';
        lineNo=1;
        answer=inputdlg(prompt, dlgTitle, lineNo, def);
        refDX = str2num(answer{1});
        
        pixDX = abs(diff(refX));
        Xpix2mm = refDX / pixDX;
        sprintf('Horizontal calibration factor is %5.3f mm/pixel', Xpix2mm);
        
        h=helpdlg('Click on 2 points for VERTICAL Calibration', 'Vertical Calibration');
        uiwait(h)
        [junk, refY] = ginput(2);
        
        prompt={'Enter the "real-world" calibration distance in mm'};
        def={'100'};
        dlgTitle='Vertical Calibration';
        lineNo=1;
        answer=inputdlg(prompt, dlgTitle, lineNo, def);
        refDY = str2num(answer{1});
        pixDY = abs(diff(refY));
        Ypix2mm = refDY / pixDY;
        sprintf('Vertical calibration factor is %5.3f mm/pixel', Ypix2mm);
        gv.pix2mm = [Xpix2mm Ypix2mm];
        
        caldMarkers = mTraj;
        caldMarkers(:, 1:2:end) = caldMarkers(:,1:2:end)*Xpix2mm;
        caldMarkers(:, 2:2:end) = caldMarkers(:,2:2:end)*-Ypix2mm;
        assignin('base', 'caldMarkers', caldMarkers);
        
    case 'AboutBox',
        h = helpdlg(sprintf('Motion Tracker 2-D version 1.0 (September 10, 2002)\nAuthor: Douglas Weber, Ph.D.\nUniversity of Alberta\ndoug.weber@ualberta.ca'), 'About motionTracker');
        uiwait(h);
        
    case 'exportRawData',
        outFile = captureFile(1:findstr(captureFile,'.')-1);
        [outFile, outPath] = uiputfile(sprintf('%s%s_pix.txt', captureFolder, outFile), 'Save Data File?');
        if outFile ~= 0,
            M = [trak.t', trak.strobes', mTraj];
            dlm = '\t';
            dlmwrite(sprintf('%s%s',outPath, outFile), M, dlm, 1, 0);
            disp(sprintf('Saved data to %s%s', outPath, outFile))    
        else,
            disp('could not open file');
        end
        
    case 'exportCaldData',
        caldMarkers = evalin('base', 'caldMarkers');
        if ~isempty( caldMarkers ),
            outFile = captureFile(1:findstr(captureFile,'.')-1);
            [outFile, outPath] = uiputfile(sprintf('%s%s_mm.txt', captureFolder, outFile), 'Save Data File?');
            if outFile ~= 0,
                M = [trak.t', trak.strobes', caldMarkers];
                dlm = '\t';
                dlmwrite(sprintf('%s%s',outPath, outFile), M, dlm);
                disp(sprintf('Saved data to %s%s', outPath, outFile))    
            else,
                disp('could not open file');
            end
        else,
            h = errordlg('Not yet calibrated');
            waitfor(h);
        end
end


function updateStepEventButns;
global trak;
global guiH;

if isfield(trak, 'stepEvents'),
    stepE = trak.stepEvents(trak.iFrame,:);
    %button 1
    for iE = 1:4,
        if stepE(iE) == 1,
            cond = 'DOWN';
            clr = [1 0 0];
        elseif stepE(iE) == 2,
            cond = 'UP';
            clr = [0 1 0];
        else
            cond = ' ';
            clr = [.5 .5 .5];
        end
        if iE == 1,
            h = guiH.event1Butn;
            foot = 'LF';
        elseif iE == 2,
            h = guiH.event2Butn;
            foot = 'RF';
        elseif iE == 3,
            h = guiH.event3Butn;
            foot = 'LR';
        elseif iE == 4,
            h = guiH.event4Butn;
            foot = 'RR';
        end
        set(h, 'BackgroundColor', clr, 'String', sprintf('%s %s', foot, cond));
    end
end

function b = drawRect(axH, clr),

zoom off
k = waitforbuttonpress;
point1 = get(axH,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];

b.h = plot(x,y, clr);                            % redraw in dataspace units        

b.xmin = min([point1(1), point2(1)]);
b.xmax = max([point1(1), point2(1)]);
b.ymin = min([point1(2), point2(2)]);
b.ymax = max([point1(2), point2(2)]);
