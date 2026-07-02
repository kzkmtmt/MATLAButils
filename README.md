# Utility functions for MATLAB

A set of utility functions to efficiently organize, filter, and process `table` data in MATLAB.

## List of Functions

- `filterTable`: Filters a table by specific variable values and extracts the rows that meet the criteria.
- `splitTableByAxes`: Splits a table based on combinations of specified axis variables and outputs it as a multidimensional cell array.
- `reduceTableByAxes`: Splits a table by axis variables and applies a reduction function (like mean or sum) to a specific variable.

## Usage Examples

Assume we have a table `T` containing the results of an experiment, with columns such as `method` (e.g., algorithm name), `alpha` (a parameter value), and `performance` (e.g., accuracy or score).

### 1. filterTable
Use `filterTable` to extract rows that match specific conditions. Instead of writing complex logical indexing, you can specify pairs of variable names and values:

```matlab
% Extract rows where method is "A" and alpha is 0.1
Tfilt = filterTable(T, "method", "A", "alpha", 0.1);
```

### 2. splitTableByAxes
Use `splitTableByAxes` to divide a table into a multidimensional cell array based on combinations of variables:

```matlab
% Split table T by unique values of "method" and "alpha"
[Tgroups, axisValues] = splitTableByAxes(T, ["method", "alpha"]);

% axisValues.method contains the unique values of method
% axisValues.alpha contains the unique values of alpha
% Tgroups is a cell array where each element corresponds to a combination of method and alpha
```

### 3. reduceTableByAxes
Use `reduceTableByAxes` to split a table by axes and calculate a summary statistic (e.g., mean) for a specific variable across each group:
```matlab
% Calculate the mean "performance" for each combination of "method" and "alpha"
[averagePerformance, axisValues] = reduceTableByAxes(T, ["method", "alpha"], "performance", @mean);
```
