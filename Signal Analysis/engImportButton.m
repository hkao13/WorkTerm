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
    root1 = data(:,root1_col);
    root2 = data(:,root2_col);
    cell = data(:,cell_col);
    setappdata(0, 'span', span);
    setappdata(0, 'root1', root1);
    setappdata(0, 'root2', root2);
    setappdata(0, 'cell', cell);
    sample = (1 / (si*10 ^ -6));
    time = (0 : (1/sample) : (numel(root1) - 1)/sample)';
    setappdata(0, 'time', time);
    set(handles.import_edit, 'String', 'Import Successful');
catch err
    %disp(err);
    set(handles.import_edit, 'String', 'Import Unsuccessful');
end

