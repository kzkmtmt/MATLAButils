function [reducedValues, axisValues] = reduceTableByAxes(T, axisVars, valueVar, reduceFcn)
%REDUCETABLEBYAXES Splits a table by axis variables and applies a reduction function to a specific variable
%
%   [reducedValues, axisValues] = reduceTableByAxes(T, axisVars, valueVar, reduceFcn)
%
%   Inputs:
%       T             - Table to be reduced (table)
%       axisVars      - List of variable names to use as axes (string vector)
%       valueVar      - Variable name containing the values to be reduced (string)
%       reduceFcn     - Reduction function to apply (function_handle)
%
%   Outputs:
%       reducedValues - Multidimensional array or cell array containing the reduced results
%                       (depends on the output format of reduceFcn)
%       axisValues    - Structure containing the unique values of each axis variable (struct)
%
%   Example:
%       T = table(["A";"A";"B";"B"], [1;1;2;2], [10;20;30;40], 'VariableNames', ["Name", "ID", "Value"]);
%       [meanValues, axes] = reduceTableByAxes(T, "Name", "Value", @mean);
%       % meanValues is an array containing the mean of Value for each Name
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
    T       table
    axisVars  (1,:) string
    valueVar  (1,1) string
    reduceFcn (1,1) function_handle
end

[Tgroups, axisValues] = splitTableByAxes(T, axisVars);

fun = @(T) reduceFcn(T.(valueVar));
reducedValues = cellfun(fun, Tgroups);
end