function LineH=vertline(positionMark,clr);
%vertline: draw vertical lines in current figure
%		vertline(positionMark);
%	positionMark is a vector holding position at with you
%	want to draw vertical line
if nargin <2,
    clr = 'b';
end
xxyy=axis;  %[xmin,xmax,ymin,ymax]
for i=1:length(positionMark)
	LineH(i)=line([positionMark(i),positionMark(i)],[xxyy(3), xxyy(4)],'color',clr);
end
