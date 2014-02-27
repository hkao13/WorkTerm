root1_col = str2double(get(handles.root1_edit, 'String'));
root2_col = str2double(get(handles.root2_edit, 'String'));
cell_col = str2double(get(handles.cell_edit, 'String'));
first = str2double(get(handles.from_edit, 'String'));
last = str2double(get(handles.to_edit, 'String'));
span = str2double(get(handles.span_edit, 'String'));

if (isnan(first))
    first = 0;
end

if (isnan(last))
    last = 'e';
end

try
    [data, si] =...
    abfload(handles.path_and_file, 'start', first, 'stop', last);
    if (isnan(root1_col))
        root1 = NaN;
    else
        root1 = data(:,root1_col);
    end
    
    if (isnan(root2_col))
        root2 = NaN;
    else
        root2 = data(:,root2_col);
    end
    
    if (isnan(cell_col))
        cell = NaN;
    else
        cell = data(:,cell_col);
    end
    
    sample = (1 / (si*10 ^ -6));
    
    if (~isnan(cell))
        time = (0 : (1/sample) : (numel(cell) - 1)/sample)';
    elseif (~isnan(root1))
        time = (0 : (1/sample) : (numel(root1) - 1)/sample)';
    elseif (~isnan(root2))
        time = (0 : (1/sample) : (numel(root2) - 1)/sample)';
    else
        disp('No data sets were recognized, please try again.')
    end
    
    setappdata(0, 'span', span);
    setappdata(0, 'root1', root1);
    setappdata(0, 'root2', root2);
    setappdata(0, 'cell', cell);
    
    
    setappdata(0, 'time', time);
    set(handles.import_edit, 'String', 'Import Successful');
catch err
    %disp(err);
    set(handles.import_edit, 'String', 'Import Unsuccessful');
end

