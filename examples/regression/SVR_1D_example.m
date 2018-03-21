%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Support Vector Regression 1D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (1a) (simple example) Generate Data from sine function
clc; clear all;clc;
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
clc; clear all;clc;
% Set parameters for sinc function data 
nbSamples = 200;
epsilon   = 0.1;
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
%%                    2)  SUPPORT VECTOR REGRESSION                     %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2a) epsilon-SVR + Linear Kernel
clear svr_options
% SVR OPTIONS
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 1;    % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 1; % set the epsilon in loss function of epsilon-SVR 
% Kernel OPTIONS
svr_options.kernel_type = 0;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)

clear model
% Train SVR Model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% 2b) epsilon-SVR + Polynomial Kernel
% SVR OPTIONS
clear svr_options
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 1;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 0.5; % set the epsilon in loss function of epsilon-SVR 
% Kernel OPTIONS
svr_options.kernel_type = 1;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.degree      = 1;    % polynomial kernel: (<x,x^i> + coeff)^degree, when coeff=0 homogeneous, coeff>=1 inhomogeneous
svr_options.coeff       = 0;    % polynomial kernel: ..


% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% 2c) epsilon-SVR + RBF Kernel
% SVR OPTIONS
clear svr_options
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 100;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 1;  % set the epsilon in loss function of epsilon-SVR 
% Kernel OPTIONS
svr_options.kernel_type = 2;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = 1;  %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)


% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% 2d) nu-SVR + RBF Kernel
% SVR OPTIONS
clear svr_options
svr_options.svr_type    = 1;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 10;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.nu          = 0.1;  % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
% Kernel OPTIONS
svr_options.kernel_type = 2;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = 5;   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Calculate the estimated epsilon from nu-svr
X_sv = X(model.sv_indices(1),:);
y_sv = y(model.sv_indices(1),:);
[y_pred] = svmpredict(1, X_sv,model);
svr_options.epsilon = abs(y_sv - y_pred);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   3) Do K-fold cross validation on hyper-parameters for \nu-SVR  %%                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Parameter grid search SVR');

% Set these parameters!
svm_type        = '1';        % SVR Type (0:epsilon-SVR, 1:nu-SVR)
kernel_type     = 2;          % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
limits_C        = [1 500];    % Limits of penalty C
limits_nu       = [0.01 0.5]; % Limits of epsilon
limits_w        = [2 20];     % Limits of kernel width \sigma
step            = 5;          % Step of parameter grid 
Kfold           = 3;
metric = 'nmse';

function_type   = {svm_type , kernel_type};
parameters      = vertcat(limits_C, limits_nu, limits_w);

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_regr( X(:), y(:), Kfold, parameters, step, function_type);

%% Get CV statistics
statsSVR = ml_get_cv_grid_states_regression(ctest,ctrain);

% Plot Heatmaps from Grid Search 
cv_plot_options              = [];
cv_plot_options.title        = strcat('$\nu$-SVR :: ', num2str(Kfold),'-fold CV with RBF');
cv_plot_options.para_names  = {'C','\nu', '\sigma'};
cv_plot_options.metrics      = {'nmse'};
cv_plot_options.param_ranges = [cranges{1} ; cranges{2}; cranges{3}];

parameters_used = [cranges{1};cranges{2};cranges{3}];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states_regression(statsSVR,parameters_used,cv_plot_options);

