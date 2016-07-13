%% Examples for Support Vector Regression on 1D Data
clear all;
close all;

%% %%%%%%%%%%%%%%%%%%%
%  Choose a Dataset
%%%%%%%%%%%%%%%%%%%%%%
%%  (simple example) Generate Data from sine function

nbSamples = 200;
epsilon   = 0.1;
x_limits  = [0, 100];

% Generate True function and data
X         = linspace(x_limits(1),x_limits(2),nbSamples)';
y_true    = sin(X*0.05);
y         = y_true + normrnd(0,epsilon,1,nbSamples)';

% Plot data
options             = [];
options.points_size = 10;
options.title       = 'noisy sinusoidal data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function and Data
plot(X,y_true,'--k','LineWidth',2);
legend({'data','true function'})


%% (complex example) Generate Data from a sinc function

% Set parameters for sinc function data 
nbSamples = 200;
epsilon   = 0.2;
y_offset  = 0.5;
x_limits  = [-5, 5];

% Generate True function and data
X = linspace(x_limits(1),x_limits(2),nbSamples) ;
y_true = sinc(X) + y_offset ;
y = y_true + normrnd(0,epsilon,1,nbSamples);

% Plot data
options             = [];
options.points_size = 15;
options.title       = 'noisy sinc data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function and Data
plot(X,y_true,'--k','LineWidth',2);
legend({'data','true function'})

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     RELEVANCE VECTOR REGRESSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RVR + RBF Kernel

clear rvr_options

%Set RVR OPTIONS%
rvr_options.useBias = true;
rvr_options.maxIts  = 100;

%Set Kernel OPTIONS%
rvr_options.kernel_ = 'gauss';
rvr_options.width   = 0.5;

% Train RVR Model
clear model
[~, model] = rvm_regressor(X,y,rvr_options,[]);

% Plot RVR function 
ml_plot_rvr_function(X, y, model, rvr_options);

