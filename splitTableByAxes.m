function [Tgroups, axisValues] = splitTableByAxes(T, axisVars)
%SPLITTABLEBYAXES Splits a table based on combinations of specified axis variables
%
%   [Tgroups, axisValues] = splitTableByAxes(T, axisVars)
%
%   Inputs:
%       T          - Table to be split (table)
%       axisVars   - List of variable names to use as axes (string vector)
%
%   Outputs:
%       Tgroups    - Multidimensional cell array containing the split tables (cell array of tables)
%                    Each dimension corresponds to each variable in axisVars.
%       axisValues - Structure containing the unique values of each axis variable (struct)
%
%   Example:
%       T = table(["A";"A";"B";"B"], [1;2;1;2], [10;20;30;40], 'VariableNames', ["Name", "ID", "Value"]);
%       [Tgroups, axisValues] = splitTableByAxes(T, ["Name", "ID"]);
%       % Tgroups{1, 1} is the table where Name=="A" and ID==1
%
% Copyright 2026 Kazuki Matsumoto, 
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

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

Tgroups = cell(height(axisCombinations), 1);
for combinationIdx = 1:height(axisCombinations)
    filterArgs = [
        num2cell(axisVars)
        table2cell(axisCombinations(combinationIdx, :))
        ];
    Tgroups{combinationIdx} = ...
        filterTable(T, filterArgs{:});
end

Tgroups = reshape(Tgroups, [fliplr(axisSizes), 1]);
Tgroups = permute(Tgroups, [numAxes:-1:1, numAxes + 1]);
end