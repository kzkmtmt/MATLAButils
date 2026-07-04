function [reducedValues, axisValues] = reduceTableByAxes(T, axisVars, reduceFcn, dataVar)
%REDUCETABLEBYAXES Splits a table based on all combinations of specified 
% axis variables and then applies a reduction function to a data variable.
%
%   [reducedValues, axisValues] = reduceTableByAxes(T, axisVars, reduceFcn, dataVar)
%
%   Inputs:
%       T             - Table to be reduced (table)
%       axisVars      - List of variable names to use as axes (string vector)
%       reduceFcn     - Reduction function to apply (function_handle)
%       dataVar       - Variable name containing the values to be reduced (string)
%
%   Outputs:
%       reducedValues - Multidimensional array containing the reduced results
%       axisValues    - Structure containing the unique values of each axis variable (struct)
%
%   Example:
%       [X, Y, Trial] = ndgrid(1:2, 1:2, 1:3);
%       Z = X .* Y + 0.1 * randn(size(X));
%       T = table(X(:), Y(:), Trial(:), Z(:), 'VariableNames', ["X", "Y", "Trial", "Z"]);
%       [meanZ, axes] = reduceTableByAxes(T, ["X", "Y"], @mean, "Z");
%       % meanZ is a 2x2 matrix approximating [1, 2; 2, 4]
%
% Author: Kazuki Matsumoto

arguments
    T          table
    axisVars  (1,:) string
    reduceFcn (1,1) function_handle
    dataVar   (1,1) string
end

[Tsplit, axisValues] = splitTableByAxes(T, axisVars);

% Apply the reduction function to each group
fun = @(T) reduceFcn(T.(dataVar));
reducedValues = cellfun(fun, Tsplit, UniformOutput=false);

% Verify that the output is either an empty array or a scalar
isValid = cellfun(@(x) isempty(x) || isscalar(x), reducedValues);
if ~all(isValid, "all")
    error("reduceTableByAxes:InvalidOutputSize", ...
        "reduceFcn must return an empty array or a scalar for each group.");
end

% Replace empty outputs with NaN and convert to a numeric array
reducedValues(cellfun(@isempty, reducedValues)) = {NaN};
reducedValues = cell2mat(reducedValues);
end