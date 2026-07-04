%[text] # Example: Polynomial Fitting and Overfitting
%[text] First, let's create a dummy data table `T` containing the results of polynomial fitting.
%[text] `T` contains the predicted values `y_predict` and the absolute error `error` relative to the observed values `y_observe` for polynomial degrees `N = 1, 2, ..., 10`.
T = dummyData()
%[text] To observe overfitting, we plot the average `error` for each polynomial degree `N`, separating the training data (`train = true`) from the test data (`train = false`).
%[text] Using `reduceTableByAxes`, we can easily calculate and visualize the mean error for every combination of `N` and `train`.
[averageError, axisValues] = reduceTableByAxes(T, ["N", "train"], @mean, "error");
bar(axisValues.N, averageError)
legend("train=" + string(axisValues.train), Location="northwest")

yscale("log")
xlabel("Polynomial degree N")
ylabel("Mean absolute error")
grid on
%[text] From the graph, we can see that while the error on the training data (`train = true`) decreases as the degree increases, the error on the test data (`train = false`) starts to increase when the degree becomes too large, indicating overfitting.
%%
%[text] ### Helper function for generating dummy data
function T = dummyData
rng(1)
x      = (-2:0.2:2)';
y_observe = x.^3 - 2 * x + 0.3 * randn(size(x));
train  = rand(size(x)) < 0.7;
test   = ~train;

x_train   = x(train);
y_train   = y_observe(train);

x_test    = x(test);
y_test    = y_observe(test);

fit1      = polyfit(x_train, y_train, 1);
fit3      = polyfit(x_train, y_train, 3);
fit10     = polyfit(x_train, y_train, 10);

figure; hold on;

fplot(@(x) polyval(fit1, x), [-2.5 2.5], "k:", "DisplayName", "N=1");
fplot(@(x) polyval(fit3, x), [-2.5 2.5], "k-", "DisplayName", "N=3");
fplot(@(x) polyval(fit10, x), [-2.5 2.5], "k--", "DisplayName", "N=10");

scatter(x_train, y_train, "ro", "DisplayName", "train=true");
scatter(x_test, y_test, "bx", "DisplayName", "train=false");

xlabel("x");
ylabel("y");

legend("Location","northwest");
ylim([-5 5]);
grid on;
T = table();
for n = 1:10
    y_predict = polyval(polyfit(x_train, y_train, n), x);
    error     = abs(y_observe - y_predict);
    N         = repmat(n, numel(x), 1);
    T         = [T; table(x, y_observe, y_predict, error, train, N)];
end
hold off
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
