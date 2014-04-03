[filename, pathname] = uigetfile({'*.txt'});
full = fullfile(pathname, filename);
data = importdata(full);
xx = data(:, 1);
yy = data(:, 2);
color = data(:, 3);


figure(2)
subplot(2,2,1)
hold on
axis ij;
for i = 1:numel(xx)
    x = xx(i);
    y = yy(i);
    c = color(i);
    switch c
        case 1
            c = 'r';
        case 2
            c = 'g';
        case 3
            c = 'b';
        case 12
            c = 'y';
        case 13
            c = 'm';
        case 23
            c = 'y';
        case 123
            c = 'k';
    end
    plot(x, y, strcat(c, 'o'));
    
end
hold off


n = 5;
xxi = linspace(min(xx(:)), max(xx(:)), n);
yyi = linspace(min(yy(:)), max(yy(:)), n);

xxr = interp1(xxi, 1:numel(xxi), xx, 'nearest');
yyr = interp1(yyi, 1:numel(yyi), yy, 'nearest');

zz = accumarray([xxr yyr], 1, [n n]);

subplot(2,2,2)
hold on
camroll(270)
surf(zz)
hold off

subplot(2,2,3)
hold on
camroll(270)
contour(zz)
hold off