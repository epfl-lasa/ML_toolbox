%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Relevant Vector Regression 1D Example %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (simple example) Generate Data from sine function
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


%% (complex example) Generate Data from a sinc function
clear all; close all; clc;
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

% Transform Data for CV
X = X'; y = y';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    2)  RELEVANT VECTOR REGRESSION                     %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RVR + RBF Kernel

clear rvr_options

%Set RVR OPTIONS%
rvr_options.useBias = true;
rvr_options.maxIts  = 100;

%Set Kernel OPTIONS%
rvr_options.kernel_ = 'gauss';
rvr_options.width   = 1;

% Train RVR Model
clear model
[~, model] = rvm_regressor(X,y,rvr_options,[]);

% Plot RVR function 
ml_plot_rvr_function(X, y, model, rvr_options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   3) Do K-fold cross validation on hyper-parameters for RVR      %%                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% K-fold cross validation 

Kfold = 10;
disp('Parameter grid search RVR');

%Set RVR OPTIONS%
rvr_options.useBias = true;
rvr_options.maxIts  = 100;

%Set Kernel OPTIONS%
rvr_options.kernel_ = 'gauss';

% Modify these according to your data!
rbf_vars = [0.1:0.1:1];

test  = cell(length(rbf_vars),1);
train = cell(length(rbf_vars),1);

for i=1:length(rbf_vars)
    disp(['[' num2str(i) '/' num2str(length(rbf_vars)) ']']);
    
    rvr_options.width       = rbf_vars(i);   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)    
    
    f                       = @(X,y,model)rvm_regressor(X,y,rvr_options,model);
    [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
    
    
    test{i}                 = test_eval;
    train{i}                = train_eval;
    disp(' ');
end


%% Get Statistics

[ stats ] = ml_get_cv_grid_states_regression(test,train);

% Plot Statistics

options             = [];
options.title       = 'RVR k-CV';
options.metrics     = {'nmse'};     % <- you can add many other metrics, see list in next cell box
options.para_name   = 'variance rbf';

[handle,handle_test,handle_train] = ml_plot_cv_grid_states_regression(stats,rbf_vars,options);

