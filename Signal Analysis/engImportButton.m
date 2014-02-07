root_col = str2double(get(handles.root_col_edit, 'String'));
cell_col = str2double(get(handles.cell_col_edit, 'String'));
first = str2double(get(handles.from_edit, 'String'));
last = str2double(get(handles.to_edit, 'String'));

if (isnan(first))
    first = 0;
end

if (isnan(last))
    last = 'e';
end

try
    [data, si] =...
        abfload(handles.path_and_file, 'start', first, 'stop', last);
    handles.root = data(:,root_col);
    handles.cell = data(:,cell_col);
    sample = (1 / (si*10 ^ -6));
    handles.time = (0 : (1/sample) : (numel(handles.root) - 1)/sample)';
    guidata(hObject, handles);
    set(handles.test_edit, 'String', 'Import Successful');
catch err
    disp(err);
    set(handles.test_edit, 'String', 'Import Unsuccessful');
end

