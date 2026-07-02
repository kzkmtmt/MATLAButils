function [Tfilt, idx] = filterTable(T, filterVar, filterValue)
%FILTERTABLE Filters a table by specific variable values
%
%   [Tfilt, idx] = filterTable(T, filterVar1, filterValue1, filterVar2, filterValue2, ...)
%
%   Inputs:
%       T             - Table to be filtered (table)
%       filterVar     - Variable name(s) used for filtering (string)
%       filterValue   - Value(s) to filter by
%
%   Outputs:
%       Tfilt         - Table containing only the rows that meet the criteria (table)
%       idx           - Logical index of the rows that met the criteria (logical vector)
%
%   Example:
%       T = table(["A";"A";"B";"B"], [1;2;1;2], [10;20;30;40], 'VariableNames', ["Name", "ID", "Value"]);
%       [Tfilt, idx] = filterTable(T, "Name", "A", "ID", 1);
%       % Tfilt contains the rows where Name=="A" and ID==1
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