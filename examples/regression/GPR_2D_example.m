%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Gaussian Process Regression 2D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             1) Load 2D Regression Datasets                 %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example of Gaussian Process Regression (2D)
%% Generate Random Gaussian distribution
clear all; close all; clc;
K = 90;
a =-50;
b = 50;
x = a + (b-a).*rand(K,1); 
y = a + (b-a).*rand(K,1);      

a    = 40;
b    = 100;
vars = a + (b-a).*rand(K,1);         
 
Mu    = [x,y]';
Sigma = zeros(2,2,K);

for k=1:K
    Sigma(:,:,k) = eye(2,2) .* vars(k);
end
        
gmm_x.Priors    = ones(1,K)./K;
gmm_x.Mu        = Mu;
gmm_x.Sigma     = Sigma;

% Generate some training Data
X = ml_gmm_sample(500,gmm_x.Priors,gmm_x.Mu,gmm_x.Sigma )';
f = @(X)ml_gmm_pdf(X',gmm_x.Priors,gmm_x.Mu,gmm_x.Sigma );
y = f(X);
y = y(:);

% Plot Training Data

% Plot Real Function
options           = [];
options.title     = 'Training data';
options.surf_type = 'surf';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_value_func(X,f,[1 2],options);hold on

% Plot Training Data
options.bFigure     = false;
options.surf_type   = 'scatter';
options.points_size = 20;
ml_plot_value_func(X,f,[1 2],options);hold on

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 2) "Train" GPR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train GP (no real training, just give parameters)
epsilon         = 0.1;
dims            = 2;
model.X_train   = X;
model.y_train   = y;
rbf_var         = 25;
gp_f            = @(X)ml_gpr(X,[],model,epsilon,rbf_var);

% Plot Estimated Function
options           = [];
options.title     = 'Estimated y=f(x) from Gaussian Process Regression';
options.surf_type = 'surf';
if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = ml_plot_value_func(X,gp_f,[1 2],options);hold on

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           3) Test GPR Model on Train points                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test GPR
options           = [];
options.bFigure   = true;
options.title     = 'Test data';
options.surf_type = 'pcolor';
dims              = [1,2];

if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = gp_plot(model.X_train,gp_f,dims,options);
colorbar

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           4) Grid Search for GPR with RBF Kernel           %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% K-fold cross validation 
Kfold = 20; 

disp('Parameter grid search GP');

rbf_vars = [5,10,20,40,50,100,10000];

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
options.metrics     = {'nrmse','r'};     % <- you can add many other metrics, see list in next cell box
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







