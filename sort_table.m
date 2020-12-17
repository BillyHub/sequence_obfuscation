function [r_max_set, max_size] = sort_table(cell_table)
% sort the table set by the size by descending order
% output the set of all indices with maximum size and the size

NrowsB = cellfun('size',cell_table,1) ;
[~,ri] = sort(NrowsB,'descend');
max_size = size(cell_table{ri(1)},1);
r_max_set = [];
for i = 1:size(ri,2)
    if (size(cell_table{ri(i)},1) == max_size)
        r_max_set = [r_max_set, ri(i)];
    else
        break;
    end
end
end