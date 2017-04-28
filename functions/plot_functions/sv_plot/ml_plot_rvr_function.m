function [handle]  = ml_plot_rvr_function(X, y, model, rvr_options)
% ML_PLOT_SVR_FUNCTION plots the training data
%   and decision boundary, given a model produced by LIBSVM for Regression
%   input ----------------------------------------------------------------
%
%       o X            : (N x D), number of input datapoints.
%
%       o y            : (N x 1), number of output datapoints.
%
%       o model        : struct containing RVM model params
%
%
%% Plot options and model params for title

% Transform data to columns
X = X(:);

% Extract model params
sigma   = model.width;
N_RVs   = length(model.RVs_idx);
est_eps = sqrt(1/model.beta);

% Plot data
options             = [];
options.labels      = [];
options.points_size = 10;
options.title       = sprintf('RVR + RBF Kernel: $\\sigma$ = %g, RV = %d, $\\epsilon_{est}$= %g', sigma, N_RVs, est_eps); 

% Compute predicted regression function (using train data)
[y_rvm, model] = rvm_regressor(X, randn(length(X),1), rvr_options, model);

% Plot Original Data
handle      = ml_plot_data([X(:),y(:)],options); hold on;

% Plot Relevant Vectors
plot(X(model.RVs_idx),y(model.RVs_idx),'ok','LineWidth',2);

% Plot Regressive function
plot(X, y_rvm,'-r','LineWidth',2);

% Plot estimated noise-levels
plot(X, y_rvm + est_eps, '--r', X, y_rvm - est_eps, '--r', 'LineWidth',1);

% Draw Legend
legend({'Train Points','Support Vectors', 'f(x)', 'f(x) $\pm$ $\epsilon_{est}$', },'Interpreter','LaTex')




end

