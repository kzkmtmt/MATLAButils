function [Tsplit, axisValues] = splitTableByAxes(T, axisVars)
%SPLITTABLEBYAXES Splits a table into a multidimensional cell array 
% based on all combinations of specified axis variables.
%
%   [Tsplit, axisValues] = splitTableByAxes(T, axisVars)
%
%   Inputs:
%       T          - Table to be split (table)
%       axisVars   - List of variable names to use as axes (string vector)
%
%   Outputs:
%       Tsplit     - Multidimensional cell array containing the split tables (cell array of tables)
%                    Each dimension corresponds to each variable in axisVars.
%       axisValues - Structure containing the unique values of each axis variable (struct)
%
%   Example:
%       [X, Y, Trial] = ndgrid(1:2, 1:2, 1:3);
%       Z = X .* Y + 0.1 * randn(size(X));
%       T = table(X(:), Y(:), Trial(:), Z(:), 'VariableNames', ["X", "Y", "Trial", "Z"]);
%       [Tsplit, axisValues] = splitTableByAxes(T, ["X", "Y"]);
%       % Tsplit{1, 2} is a 3x4 table where X==1 and Y==2
%
% Author: Kazuki Matsumoto

arguments
    T        table
    axisVars (1,:) string
end

numAxes       = numel(axisVars);
axisSizes     = zeros(1, numAxes);
axisValueList = cell(1, numAxes);
axisValues    = struct;

for axisIdx = 1:numAxes
    axisVar = axisVars(axisIdx);
    values  = unique(T.(axisVar), "stable");

    axisValues.(axisVar)   = values;
    axisValueList{axisIdx} = values;
    axisSizes(axisIdx)     = numel(values);
end

axisCombinations = combinations(axisValueList{:});
axisCombinations.Properties.VariableNames = cellstr(axisVars);

Tsplit = cell(height(axisCombinations), 1);
for combinationIdx = 1:height(axisCombinations)
    filterArgs = [
        num2cell(axisVars)
        table2cell(axisCombinations(combinationIdx, :))
        ];
    Tsplit{combinationIdx} = ...
        filterTable(T, filterArgs{:});
end

Tsplit = reshape(Tsplit, [fliplr(axisSizes), 1]);
Tsplit = permute(Tsplit, [numAxes:-1:1, numAxes + 1]);
end