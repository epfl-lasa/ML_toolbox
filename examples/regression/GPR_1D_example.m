%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Gaussian Process Regression 1D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate Data
clear all; close all; clc;
nbSamples   = 200;
epsilon     = 0.2;
X           = linspace(0,50,nbSamples);
y           = sin(X*0.2) + normrnd(0,0.2,1,nbSamples);

X           = X(:);
y           = y(:);

% Make hole in Data

id    = (X > 20 & X < 30);
X(id) = [];
y(id) = [];

% Plot data
options             = [];
options.points_size = 10;
options.plot_labels = {'x','y'};
options.title       = 'noisy sinusoidal data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 2) "Train" GPR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train GP (no real training, just give parameters)

model.X_train   = X;
model.y_train   = y;
X_test          = linspace(0,50,200)';
rbf_var         = 0.1;
epsilon         = 0.1;
gp_f            = @(X)ml_gpr(X,[],model,epsilon,rbf_var);

% Plot GPR
options             = [];
options.points_size = 10;
options.title       = 'GPR'; 
options.plot_labels = {'x','y'};

if exist('h2','var') && isvalid(h2), delete(h2);end
h2  = ml_plot_data([X(:),y(:)],options);
hold on;

options = [];
options.bFigure = false;
options.num_samples = 100;
gp_plot(X,gp_f,1,options);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           3) Grid Search for GPR with RBF Kernel           %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% K-fold cross validation 

Kfold = 10;
disp('Parameter grid search GP');
rbf_vars = [0.01,0.1,1,2,5,10,20,40,50,100];

test  = cell(length(rbf_var),1);
train = cell(length(rbf_var),1);


for i=1:length(rbf_vars)
    disp(['[' num2str(i) '/' num2str(length(rbf_vars)) ']']);
    
    
    f                       = @(X,y,model)ml_gpr(X,y,model,epsilon,rbf_vars(i));
    [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
    
    
    test{i}                 = test_eval;
    train{i}                = train_eval;
    disp(' ');
end

%% Get Statistics
[ stats ] = ml_get_cv_grid_states_regression(test,train);

%% Plot Statistics

options             = [];
options.title       = 'GPR k-CV';
options.metrics     = {'r'};     % <- you can add many other metrics, see list in next cell box
options.para_name   = 'variance rbf';

if exist('handle','var'), delete(handle); end
[handle,handle_test,handle_train] = ml_plot_cv_grid_states_regression(stats,rbf_vars,options);


%% Full list of evaluation metrics for regression methods

options.metric = {'mse','nmse','rmse','nrmse','mae','mare','r','d','e','me','mre'};

%   '1'  - mean squared error                               (mse)
%   '2'  - normalised mean squared error                    (nmse)
%   '3'  - root mean squared error                          (rmse)
%   '4'  - normalised root mean squared error               (nrmse)
%   '5'  - mean absolute error                              (mae)
%   '6'  - mean  absolute relative error                    (mare)
%   '7'  - coefficient of correlation                       (r)
%   '8'  - coefficient of determination                     (d)
%   '9'  - coefficient of efficiency                        (e)
%  '10'  - maximum absolute error                           (me)
%  '11'  - maximum absolute relative error                  (mre)




