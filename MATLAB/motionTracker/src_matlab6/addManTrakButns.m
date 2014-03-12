function addManTrakButns;

global gv;
global guiH;

%The single-marker digitize buttons are positioned in the range:
% horizontal 0.81 - 0.98
% vertical 0.15 - 0.40
xMin = 0.81; xMax = 0.98;
yMin = 0.14; yMax = 0.43;

%distribute the buttons across columns of six buttons
nRows = 7;
nCols = ceil( gv.nMarkers/nRows );

bw = (xMax-xMin)/nCols;
if bw > .08,
    bw = .08;
end
bh = (yMax-yMin)/nRows;
if bh > .05,
    bh = .05;
end

iButton = 0;
for iCol = 1:nCols,
    for iRow = 1:nRows,
        iButton = iButton+1;
        if iButton <= gv.nMarkers,
            guiH.manTrak(iButton) = uicontrol('Parent', guiH.fig, ...
                'Style','pushbutton', ...
                'Enable', 'Off',...
                'Units',' Normalized', ...
                'Position', [xMin+(iCol-1)*bw yMax-iRow*bh  bw bh], ...
                'Callback', sprintf('manualDigitize %d', iButton), ...
                'String', gv.mrkrLabels{iButton}, ...
                'FontWeight','b',...
                'FontUnits','points',...
                'FontSize', 8,...
                'TooltipString', sprintf('Manually locate %s marker', gv.mrkrLabels{iButton}) );
%             if iButton < 10,
%                 uimenu('Parent', guiH.manTrakMenu, ...
% 	                'Callback', sprintf('manualDigitize %d', iButton), ...
%                     'Accelerator', num2str(iButton), ...
% 	                'Label', gv.mrkrLabels{iButton});
            end
        end
    end
end

%*******************************************************
