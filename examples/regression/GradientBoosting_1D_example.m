%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Gradient Boosting Regression 1D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (1a) (simple example) Generate Data from sine function
clear all; close all; clc;
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


%% (1b) (complex example) Generate Data from a sinc function
clear all; close all; clc;
% Set parameters for sinc function data 
nbSamples = 200;
epsilon   = 0.1;
y_offset  = 0.5;
x_limits  = [-5, 5];

% Generate True function and data
X = linspace(x_limits(1),x_limits(2),nbSamples) ;
y_true = sinc(X) + y_offset ;
y = y_true + normrnd(0,epsilon,1,nbSamples);
X = X';
y = y';

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
%%                 2)  GRADIENT BOOSTING REGRESSION                     %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gradient Boosting with decision stumps weak learners
% Options 
options.nbWeakLearners = 200;

% Train Gradient Boosting Model
model = fitensemble(X,y,'LSBoost',options.nbWeakLearners,'Tree');

% Compute prediction

Y = predict(model,X);

% Plot data
options.title       = [options.title ' : Prediction']; 

if exist('hl','var') && isvalid(hl), delete(hl);end
hl      = ml_plot_data([X(:),y(:)],options); hold on;

% Plot prediction from Gradient Boosting

plot(X,Y,'k','LineWidth',2);
legend({'data', 'predicted function'});

% Plot Loss function of Training Model

if exist('hl2','var') && isvalid(hl2), delete(hl2);end
figure
hl2 = plot(model.FitInfo);
xlabel('Number of weak learners','FontSize',14);
ylabel('Loss (MSE)','FontSize',14);
title('Cumulative Loss of the train data','FontSize',18);