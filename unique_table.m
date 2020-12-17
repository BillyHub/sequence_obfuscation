function [unique_table_cell] = unique_table(table_cell)
% eliminate the duplicate vectors of each table member

r = size(table_cell,2);
unique_table_cell = {};
for i = 1:r
    unique_table_cell{i} = unique(table_cell{i},'rows');
end
end