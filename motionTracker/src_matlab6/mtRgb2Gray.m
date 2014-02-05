function y = rgb2gray( x, nLevels );
% USAGE: y = rgb2gray( x );
% This function converts rgb images (e.g. 240 x 320 x 3) to grayscale indexed images (240 x 320) with nLevels
% INPUTS: 
%   x: rgb 3-D rgb image matrix
%   nLevels: number of levels in the grayscale indexed image (default is 64)   

if nargin < 2,
    nLevels = 64;% Number of shades in new indexed image
end

A = double(x);
Xrgb  = 0.2990*A(:,:,1) + 0.5870*A(:,:,2) + 0.1140*A(:,:,3);

y = makeGray(Xrgb,nLevels);

function y = makeGray( x, nLevels),

[t1,t2] = size(x);
y  = ones(t1,t2);
x = abs(x);

x = x - min(min(x));
maxx  = max(max(x));
if maxx >= eps,
    mul  = nLevels/maxx;
    y(:) = fix(1 + mul*x);
end
y(y>nLevels) = nLevels;
