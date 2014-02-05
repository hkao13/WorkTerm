function calib2Ddlt();

global mTraj;
global caldMarkers;

nMarkers = size(mTraj,2)/2;

[calFile, calFolder] = uigetfile( sprintf('*_mtCalib.mat'), 'Select calibration file');

File = fullfile(calFolder, calFile);
load(File);

fm = questdlg('Is there a "Fixed Marker" in the data set?','Fixed marker?','First Marker','Last Marker','None','None');
mrkrs = mTraj;
nPoints = size(mrkrs,2)/2;
switch fm,
    case 'First Marker',
        mrkrs = mrkrs(:,3:end)-repmat(mrkrs(:,1:2), 1, nPoints-1);
        nPoints = nPoints-1;
    case 'Last Marker',
        mrkrs = mrkrs(:,1:end-2)-repmat(mrkrs(:,end-1:end),1, nPoints-1);
        nPoints = nPoints-1;
end

RW = cal.rw;
M = cal.m;
RW = repmat(RW, size(M,1), 1);
F = [];
L = [];
for i = 1:size(M,2)/2,
    F = [F; RW(:, i*2-1:i*2)];
    L = [L; M(:, i*2-1:i*2)];
end
F(:,2) = F(:,2);
L(:,2) = -L(:,2);

junk = find(isnan(F(:,1)));
m=size(F,1); Lt=L'; C=Lt(:);

for i=1:m
    B(2*i-1,1)  = F(i,1); 
    B(2*i-1,2)  = F(i,2); 
    B(2*i-1,3)  = 1;
    B(2*i-1,7)  =-F(i,1)*L(i,1);
    B(2*i-1,8)  =-F(i,2)*L(i,1);
    B(2*i,4)    = F(i,1);
    B(2*i,5)    = F(i,2);
    B(2*i,6)    = 1;
    B(2*i,7)    =-F(i,1)*L(i,2);
    B(2*i,8)    =-F(i,2)*L(i,2);
end

% Cut the lines out of B and C including the control points to be discarded
junk=[junk.*2-1, junk.*2];
B(junk, :)=[];
C(junk, :)=[];

% Solution for the coefficients
A=B\C;
D=B*A;
R=C-D;
res=norm(R); 
avgres=res/size(R,1)^0.5;
caldMarkers=[];

for iFrame = 1:size(mrkrs,1),  %number of time points
    for iMarker = 1:size(mrkrs,2)/2,
        x=mrkrs(iFrame, iMarker*2-1);
        y=-mrkrs(iFrame, iMarker*2);
        L1 = [];
        L2 = [];
        if ~(isnan(x) | isnan(y))  % do not construct l1,l2 if camx,y=NaN
            L1=[A(1)-x*A(7), A(2)-x*A(8) ; ...
                    A(4)-y*A(7), A(5)-y*A(8) ];
            L2=[x-A(3); y-A(6)];
        end
        
        if (size(L2,1))==2  % check whether data available
            g=L1\L2;
        else
            g=[NaN;NaN];
        end
        caldMarkers(iFrame, iMarker*2-1:iMarker*2) = g';
    end
end    
