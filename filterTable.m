function [Tfilt, idx] = filterTable(T, filterVar, filterValue)
%FILTERTABLE Filters rows by specified variable–value pairs.
%
%   [Tfilt, idx] = filterTable(T, filterVar1, filterValue1, filterVar2, filterValue2, ...)
%
%   Inputs:
%       T             - Table to be filtered (table)
%       filterVar     - Variable name(s) used for filtering (string)
%       filterValue   - Value(s) to filter by
%
%   Outputs:
%       Tfilt         - Table containing only the rows that match the specified values (table)
%       idx           - Logical index of the rows that matched the specified values (logical vector)
%
%   Example:
%       [X, Y, Trial] = ndgrid(1:2, 1:2, 1:3);
%       Z = X .* Y + 0.1 * randn(size(X));
%       T = table(X(:), Y(:), Trial(:), Z(:), 'VariableNames', ["X", "Y", "Trial", "Z"]);
%       [Tfilt, idx] = filterTable(T, "X", 1, "Y", 2);
%       % Tfilt is a 3x4 table containing rows where X==1 and Y==2
%
% Author: Kazuki Matsumoto

arguments
    T table
end
arguments (Repeating)
    filterVar (1,1) string
    filterValue
end

idx = true(height(T), 1);
for k = 1:numel(filterVar)
    idx = idx & ismember(T.(filterVar{k}), filterValue{k});
end

Tfilt = T(idx, :);
end