function [pos1,pos2] = findPosition(name)
    %UNTITLED Summary of this function goes here
    %   Input fn{i}
    if isequal('bg',name)
        pos1 = 'BG Position 3';
        pos2 = 'BG Position 4';
    elseif isequal('u_pos34',name)
        pos1 = 'Undamped Position 3';
        pos2 = 'Undamped Position 4';
    elseif isequal('pos12',name)
        pos1 = 'Position 1';
        pos2 = 'Position 2';
    elseif isequal('pos34',name)
        pos1 = 'Position 3';
        pos2 = 'Position 4';
    elseif isequal('pos56',name)
        pos1 = 'Position 5';
        pos2 = 'Position 6';
    elseif isequal('pos78',name)
        pos1 = 'Position 7';
        pos2 = 'Position 8';
    end
end