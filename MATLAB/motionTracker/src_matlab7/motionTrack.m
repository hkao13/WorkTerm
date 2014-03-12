%--------------------------------------------------------------------------
% This is where you will enter name of the data points collected from
% motionTracker 2D. It is set to mTraj currently since that is what
% moitionTracker2D names its data. If you have a different data set you
% would like to use, change the name within the brackets to the name of the
% desired data set.

% Example: 
% matrix = ( myDataSet );
% matrix = ( another_Data_Set );
% matrix = ( myDataSet2 );

matrix = ( mTraj );

% Spacing is a value to determine how many data points to skip within the
% data set. For example, setting spacing equal to 5 will skip 5 data
% points. The lowest number possible is 1. Do not set anything less than 1.
% The value of spacing must also be a natural number. Do not set spacing to
% a negative value or a decimal value.
% To change the value of spacing, change the number within the brackets to
% some other number.

% Example:
% spacing = ( 1 );
% spacing = ( 10 );

spacing = ( 4 );

%--------------------------------------------------------------------------
% Nothing to change right here. The code here is used to remove all the NaN
% elements from the original data set.

data = matrix(isfinite(matrix(:,1)), :);
[row, col] = size(data);

%--------------------------------------------------------------------------
% Depending how many markers you set in motionTracker2D, you may have to
% change this block of code. Don't worry, it is pretty simple. If you have 
% three markers, there should be three 'x' data points and three 'y' data
% points. For example, if the are two markers, you should only have x1, x2,
% y1, and y2. For four markers, you should have x1, x2, x3, x4, y1, y2, y3,
% y4, no more, no less.

for i = 1: spacing :row

    % To change the amount of markers, you can add or delete the variables
    % here. To add a new nth marker, type in, below the existing markers:
    % xn = data(i, columnNumber);
    % yn = data(i, columnNumber);
    % Don;t forget to delete an excess amount of markers. For example, if
    % you had 5 markers previously, but changed to three markers, do not
    % forget to delete the 2 extra markers from both the 'x' and the 'y'.
    
    % Example:
    % If you are adding a 4th marker to an existing set of 3 markers, it
    % should look like:
    % x1 = data(i, 1);
    % x2 = data(i, 3);
    % x3 = data(i, 5);
    % x4 = data(i, 7);
    %
    % y1 = data(i, 2);
    % y2 = data(i, 4);
    % y3 = data(i, 6);
    % y4 = data(i, 8);
    
    x1 = data(i, 1);
    x2 = data(i, 3);
    x3 = data(i, 5);
    x4 = data(i, 7);

    y1 = data(i, 2);
    y2 = data(i, 4);
    y3 = data(i, 6);
    y4 = data(i, 8);

    % When you change the amount of 'x' and 'y' above, you also have to
    % change line below.
    
    % Example:
    % Four markers would look like:
    % line( [x1, x2, x3, x4], [y1, y2, y3, x4] );
    % Two markers would look like:
    % lineline( [x1, x2], [y1, y2] );
    figure(999)
    line( [x1, x2, x3, x4], [y1, y2, y3, y4] );
    set(gca, 'ydir', 'reverse');

end
%--------------------------------------------------------------------------