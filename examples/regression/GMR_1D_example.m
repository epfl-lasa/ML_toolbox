%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Gaussian Mixture Regression 1D Example %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%  (1a) Generate Data from a noisy line %%%%%%
clc; clear all; dataset_type = '1d-linear';
[ X, y_true, y ] = ml_load_regression_datasets( dataset_type );

%% %%%  (1b) Generate Non-Linear Data from sine function %%%%%%
clc; clear all; dataset_type = '1d-sine';
[ X, y_true, y ] = ml_load_regression_datasets( dataset_type );

%% %%% (1c) Generate Non-Linear Data from a sinc function %%%%%%
clc; clear all;dataset_type = '1d-sinc';
[ X, y_true, y ] = ml_load_regression_datasets( dataset_type );

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    2) Learn the GMM Model from your regression data       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fit GMM with Chosen parameters
K = 6; 

%%%% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
Xi = [X  y]'; close all;
[Priors, Mu, Sigma] = ml_gmmEM(Xi, K);

%%%% Visualize GMM pdf from learnt parameters (for 1D Datasets)
ml_plot_gmm_pdf(Xi, Priors, Mu, Sigma)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    3) Validate my_gmr.m function on 1D Dataset    %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute Regressive signal and variance
N = size(X,2); P = size(y,2);
in  = 1:N;       % input dimensions
out = N+1:(N+P); % output dimensions
[y_est, var_est] = ml_gmr(Priors, Mu, Sigma, X', in, out);

% Plot Datapoints
options             = [];
options.points_size = 15;
options.title       = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.labels      = zeros(length(y_est),1);
if exist('h4','var') && isvalid(h4), delete(h4);end
h4 = ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function 
plot(X,y_true,'-k','LineWidth',1); hold on;

% Plot Estimated function 
options             = [];
options.var_scale   = 2;
options.title       = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.plot_figure = false;
ml_plot_gmr_function(X, y_est, var_est, options)
legend({'data','y = f(x)','$Var\{p(y|x)\}$','$+2\sigma\{p(y|x)\}$', ...
    '$-2\sigma\{p(y|x)\}$','$\hat{y} = E\{p(y|x)\}$' }, 'Interpreter','latex')

