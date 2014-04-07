% Opens ui to get file.
[filename, pathname] = uigetfile({'*.txt'});
full = fullfile(pathname, filename);

% Imports the file
data = importdata(full);

% x coordinate of centroid in first column.
xx = data(:, 1);
% y cooordinate of centroid in second column.
yy = data(:, 2);
% color code of coordinate in third column.
color = data(:, 3);


% Opens figure(2) window
figure(2)

% Sets subplot 1 of figure(2) to current axes
subplot(2,2,1)
hold on
axis ij;
% For loop to plot data.
CircleSize = 5; % Change number for size of the Markers.
for i = 1:numel(xx)
    x = xx(i);
    y = yy(i);
    c = color(i);
    switch c
        case 1 
            c = [1 0 0];        % Red Cells
        case 2
            c = [0 1 0];        % Green Cells
        case 3
            c = [0 0 1];        % Blue Cells
        case 12
            c = [1 0.6 .2];     % Red/Green (Yellow) Cells
        case 13
            c = [1 0 1];        % Red/Blue (Magenta) Cells
        case 23
            c = [0 1 1];        % Blue/Green (Cyan) Cells
        case 123
            c = [0 0 0];        % Red/Green/Blue (Black, actually supposed to be White) Cells
    end
    plot(x, y, 'o', 'MarkerEdgeColor', c, 'MarkerFaceColor', c, 'MarkerSize', CircleSize);   
end
hold off
% End of plotting the data.

% -------------------------------------------------------------------------
% Number of divisons to split the plot by.
n = 20; % Change this number. Larger number to have smaller divisons,
       % Smaller to have larger divisions.
% -------------------------------------------------------------------------
% Creates the divisons.
xxi = linspace(min(xx(:)), max(xx(:)), n);
yyi = linspace(min(yy(:)), max(yy(:)), n);

% Groups data.
xxr = interp1(xxi, 1:numel(xxi), xx, 'nearest');
yyr = interp1(yyi, 1:numel(yyi), yy, 'nearest');

% Makes matrix.
zz = accumarray([xxr yyr], 1, [n n]);

% Sets subplot 2 of figure(2) to current axes.
subplot(2,2,2)
hold on
camroll(270)
% Creates Heat/Density Map.
surf(zz)
hold off

% Sets subplot 3 of figure(2) to current axes.
subplot(2,2,3)
hold on
camroll(270)
% Creates contour plot.
contour(zz)
hold off