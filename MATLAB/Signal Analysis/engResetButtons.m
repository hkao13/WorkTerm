switch identity
    case 0
        disp('Reseting Cell Data...');
        
        if(isfield(handles, 'threshold0'))
            handles = rmfield(handles, 'threshold0');
        end
        
        if(isfield(handles, 'cellOnset'))
            handles = rmfield(handles, 'cellOnset');
        end
        
        if(isfield(handles, 'cellOffset'))
            handles = rmfield(handles, 'cellOffset');
        end
        
        if(isfield(handles, 'cellDuration'))
            handles = rmfield(handles, 'cellDuration');
        end
        
        if(isfield(handles, 'cellCount'))
            handles = rmfield(handles, 'cellCount');
        end
        
        if(isfield(handles, 'cellPeriod'))
            handles = rmfield(handles, 'cellPeriod');
        end
        
        if(isfield(handles, 'onsetDiff'))
            handles = rmfield(handles, 'onsetDiff');
        end
        
        if(isfield(handles, 'offsetDiff'))
            handles = rmfield(handles, 'offsetDiff');
        end
        
        set(handles.thresh_cell_edit, 'String', '');
        set(handles.cell_count_edit, 'String', '');
        set(handles.cell_avg_dur_edit, 'String', '');
        set(handles.cell_avg_per_edit, 'String', '');
        set(handles.onset_diff_edit, 'String', '');
        set(handles.offset_diff_edit, 'String', '');
        axes(handles.axes3);
        del_items = findobj(handles.axes3, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        guidata(hObject, handles);
        
    case 1
        disp('Reseting Root 1 Data...');
        
        if(isfield(handles, 'threshold1'))
            handles = rmfield(handles, 'threshold1');
        end
        
        if(isfield(handles, 'baseline1'))
            handles = rmfield(handles, 'baseline1');
        end
        
        if(isfield(handles, 'base1'))
            handles = rmfield(handles, 'base1');
        end
        
        if(isfield(handles, 'line1'))
            handles = rmfield(handles, 'line1');
        end
        
        if(isfield(handles, 'rootOnset1'))
            handles = rmfield(handles, 'rootOnset1');
        end
        
        if(isfield(handles, 'rootOffset1'))
            handles = rmfield(handles, 'rootOffset1');
        end
        
        if(isfield(handles, 'root1Duration'))
            handles = rmfield(handles, 'root1Duration');
        end
        
        if(isfield(handles, 'root1Count'))
            handles = rmfield(handles, 'root1Count');
        end
        
        if(isfield(handles, 'root1Period'))
            handles = rmfield(handles, 'root1Period');
        end
        
        if(isfield(handles, 'root1Amp'))
            handles = rmfield(handles, 'root1Amp');
        end
        
        set(handles.baseline1_edit, 'String', '');
        set(handles.thresh_root1_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        set(handles.root1_avg_dur_edit, 'String', '');
        set(handles.root1_avg_per_edit, 'String', '');
        set(handles.root1_avg_amp_edit, 'String', '');
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        axes(handles.axes2);
        del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        guidata(hObject, handles);
        
    case 2
        disp('Reseting Root 2 Data...');
       
        if(isfield(handles, 'threshold2'))
            handles = rmfield(handles, 'threshold2');
        end
        
        if(isfield(handles, 'baseline2'))
            handles = rmfield(handles, 'baseline2');
        end
        
        if(isfield(handles, 'base2'))
            handles = rmfield(handles, 'base2');
        end
        
        if(isfield(handles, 'line2'))
            handles = rmfield(handles, 'line2');
        end
        
        if(isfield(handles, 'rootOnset2'))
            handles = rmfield(handles, 'rootOnset2');
        end
        
        if(isfield(handles, 'rootOffset2'))
            handles = rmfield(handles, 'rootOffset2');
        end
        
        if(isfield(handles, 'root2Duration'))
            handles = rmfield(handles, 'root2Duration');
        end
        
        if(isfield(handles, 'root2Count'))
            handles = rmfield(handles, 'root2Count');
        end
        
        if(isfield(handles, 'root2Period'))
            handles = rmfield(handles, 'root2Period');
        end
        
        if(isfield(handles, 'root2Amp'))
            handles = rmfield(handles, 'root2Amp');
        end
        
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.baseline2_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        set(handles.root2_avg_dur_edit, 'String', '');
        set(handles.root2_avg_per_edit, 'String', '');
        set(handles.root2_avg_amp_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        axes(handles.axes4);
        del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        guidata(hObject, handles);
end



warning OFF;
ax(1) = handles.axes2;
ax(2) = handles.axes3;
ax(4) = handles.axes4;
linkaxes(ax, 'x');