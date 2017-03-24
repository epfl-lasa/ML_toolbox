%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   Gaussian Mixture Regression 2D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             1) Load 2D Regression Datasets                 %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%% (1a) Sin/Cos Dataset %%%%%%
clc; clear all; close all;
dataset_type = '2d-cossine';
[ X, y_true, y ] = ml_load_regression_datasets( dataset_type, [] );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    2) Learn the GMM Model from your regression data       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fit GMM with Chosen parameters
K = 10;

%%%% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
Xi = [X  y]'; close all;
[Priors, Mu, Sigma] = ml_gmmEM(Xi, K);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    3) Validate my_gmr.m function on 2D Dataset    %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute Regressive signal and variance
N = size(X,2); P = size(y,2); M = size(X,1);
in  = 1:N;       % input dimensions
out = N+1:(N+P); % output dimensions
[y_est, var_est] = ml_gmr(Priors, Mu, Sigma, X', in, out);

% Function handle for my_gmr.m
f = @(X) ml_gmr(Priors,Mu,Sigma,X, in, out);

% Plotting Options for Regressive Function
options           = [];
options.title     = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.regr_type = 'GMR';
options.surf_type = 'surf';
ml_plot_value_func(X,f,[1 2],options);hold on

% Plot Training Data
options = [];
options.plot_figure = true;
options.points_size = 12;
options.labels = zeros(M,1);
options.plot_labels = {'$x_1$','$x_2$','y'};
ml_plot_data([X y],options);

