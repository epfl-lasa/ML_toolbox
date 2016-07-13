%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Examples for Support Vector Regression variants \epsilon-SVR,\nu-SVR, RVR (1D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%% RUN THIS IF SVM FUNCTIONS DON'T WORK <only once> (Go to ML_toolbox Root Dir)
ML_toolbox_path = pwd;
cd './methods/toolboxes/libsvm/matlab'
make
cd(ML_toolbox_path)

%% %%%%%%%%%%%%%%%%%
%  Generate a Dataset
%%%%%%%%%%%%%%%%%%%%%%

%%  (Example 0) Generate Data from a noisy line

nbSamples = 50;
epsilon   = 5;
x_limits  = [0, 100];

% Generate True function and data
X         = linspace(x_limits(1),x_limits(2),nbSamples)';
y_true    = -0.5*X;
y         = y_true + normrnd(0,epsilon,1,nbSamples)';


X = X(:);
y = y(:);

% Plot data
options             = [];
options.points_size = 15;
options.title       = 'Example 1D Linear Training Data'; 
ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function and Data
plot(X,y_true,'--k','LineWidth',2);
legend({'data','y = f(x)'})

%%  (Example 1) Generate Data from sine function

nbSamples = 100;
epsilon   = 0.5;
x_limits  = [0, 100];

% Generate True function and data
X         = linspace(x_limits(1),x_limits(2),nbSamples)';
y_true    = sin(X*0.05);
y         = y_true + normrnd(0,epsilon,1,nbSamples)';


X = X(:);
y = y(:);

% Plot data
options             = [];
options.labels      = [];
options.points_size = 15;
options.title       = 'Example 1D Non-linear Training Data';  
ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function and Data
plot(X,y_true,'--k','LineWidth',2);
legend({'data','y = f(x)'})

%% (Example 2) Generate Data from a sinc function
clear all
% Set parameters for sinc function data 
nbSamples = 200;
epsilon   = 0.1;
y_offset  = 0.5;
x_limits  = [-5, 5];

% Generate True function and data
X = linspace(x_limits(1),x_limits(2),nbSamples) ;
y_true = sinc(X) + y_offset ;
y = y_true + normrnd(0,epsilon,1,nbSamples);

X = X(:);
y = y(:);

% Plot data
options             = [];
options.labels      = [];
options.points_size = 15;
options.title       = 'Example 1D Non-linear Training Data'; 
ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function and Data
plot(X,y_true,'--k','LineWidth',2);
legend({'data','y = f(x)'})


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     SUPPORT VECTOR REGRESSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2a) epsilon-SVR + Linear Kernel
clear svr_options
% SVR OPTIONS
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 1;    % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 50; % set the epsilon in loss function of epsilon-SVR 
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
svr_options.C           = 10;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 0.5; % set the epsilon in loss function of epsilon-SVR 
% Kernel OPTIONS
svr_options.kernel_type = 1;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.degree      = 3;    % polynomial kernel: (<x,x^i> + coeff)^degree, when coeff=0 homogeneous, coeff>=1 inhomogeneous
svr_options.coeff       = 1;    % polynomial kernel: ..


% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% 2c) epsilon-SVR + RBF Kernel
% SVR OPTIONS
clear svr_options
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 10;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 0.3;  % set the epsilon in loss function of epsilon-SVR 
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
svr_options.sigma       = 0.50;   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Calculate the estimated epsilon from nu-svr
X_sv = X(model.sv_indices(1),:);
y_sv = y(model.sv_indices(1),:);
[y_pred] = svmpredict(1, X_sv,model);
svr_options.epsilon = abs(y_sv - y_pred)

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%        Do K-fold cross validation on hyper-parameters for \epsilon-SVR
%                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Parameter grid search SVR');

svm_type        = '0';       % SVR Type (0:epsilon-SVR, 1:nu-SVR)
kernel_type     = 2;         % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
function_type   = {svm_type , kernel_type};
limits_C        = [1 500];  % Limits of penalty C
limits_epsilon  = [0.05 1];  % Limits of epsilon
limits_w        = [0.25 2]; % Limits of kernel width \sigma
parameters      = vertcat(limits_C, limits_epsilon, limits_w);
step            = 5;        % Step of parameter grid 
Kfold           = 10;
metric = 'nmse';

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_regr( X(:), y(:), Kfold, parameters, step, function_type);

%% Get CV statistics
statsSVR = ml_get_cv_grid_states_regression(ctest,ctrain);

% Plot Heatmaps from Grid Search 
cv_plot_options              = [];
cv_plot_options.title        = strcat('$\epsilon$-SVR :: ', num2str(Kfold),'-fold CV with RBF');
cv_plot_options.para_names  = {'C','\epsilon', '\sigma'};
cv_plot_options.metrics      = {'nmse'};
cv_plot_options.param_ranges = [cranges{1} ; cranges{2}; cranges{3}];

parameters_used = [cranges{1};cranges{2};cranges{3}];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states_regression(statsSVR,parameters_used,cv_plot_options);


%% Get optimal parameters and plot result
[min_metricSVR,indSVR] = min(statsSVR.test.(metric).mean(:));
[C_min, eps_min, sigma_min] = ind2sub(size(statsSVR.test.(metric).mean),indSVR);
C_opt = cranges{1}(C_min);
epsilon_opt = cranges{2}(eps_min);
sigma_opt = cranges{3}(sigma_min);

% Test model with optimal parameter
clear svr_options
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = C_opt;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = epsilon_opt;  % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
svr_options.kernel_type = kernel_type;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = sigma_opt;   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)
clear model
[YSVR, modelSVR] = svm_regressor(X, y, svr_options, []);


% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, modelSVR, svr_options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%        Do K-fold cross validation on hyper-parameters for \nu-SVR
%                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Parameter grid search SVR');

svm_type        = '1';       % SVR Type (0:epsilon-SVR, 1:nu-SVR)
kernel_type     = 2;         % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
function_type   = {svm_type , kernel_type};
limits_C        = [1 500];  % Limits of penalty C
limits_nu       = [0.01 0.5];  % Limits of epsilon
limits_w        = [0.25 2]; % Limits of kernel width \sigma
parameters      = vertcat(limits_C, limits_nu, limits_w);
step            = 5;        % Step of parameter grid 
Kfold           = 10;
metric = 'nmse';

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

%% Get optimal parameters and plot result

[min_metricSVR,indSVR] = min(statsSVR.test.(metric).mean(:));
[C_min, nu_min, sigma_min] = ind2sub(size(statsSVR.test.(metric).mean),indSVR);
C_opt = cranges{1}(C_min);
nu_opt = cranges{2}(nu_min);
sigma_opt = cranges{3}(sigma_min);

% Test model with optimal parameter
clear svr_options
svr_options.svr_type    = 1;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = C_opt;   % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.nu          = nu_opt;  % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
svr_options.kernel_type = kernel_type;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = sigma_opt;   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)
clear model
[YSVR, modelSVR] = svm_regressor(X, y, svr_options, []);

% Calculate the estimated epsilon from nu-svr
X_sv = X(modelSVR.sv_indices(1),:);
y_sv = y(modelSVR.sv_indices(1),:);
[y_pred] = svmpredict(1, X_sv,modelSVR);
svr_options.epsilon = abs(y_sv - y_pred);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, modelSVR, svr_options);

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
rvr_options.width   = 10;

% Train RVR Model
clear model
[~, model] = rvm_regressor(X,y,rvr_options,[]);

% Plot RVR function 
ml_plot_rvr_function(X, y, model, rvr_options);


%% K-fold cross validation 

Kfold = 10;

disp('Parameter grid search RVR');

%Set RVR OPTIONS%
rvr_options.useBias = true;
rvr_options.maxIts  = 100;

%Set Kernel OPTIONS%
rvr_options.kernel_ = 'gauss';

rbf_vars = [0.05:0.05:0.5];

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


%% Get optimal parameters and plot result
[min_metricSVR,indSVR] = min(stats.test.('nmse').mean(:));
[sigma_min] = ind2sub(size(stats.test.('nmse').mean),indSVR);
sigma_opt = rbf_vars(sigma_min);

clear rvr_options

%Set RVR OPTIONS%
rvr_options.useBias = true;
rvr_options.maxIts  = 100;

%Set Kernel OPTIONS%
rvr_options.kernel_ = 'gauss';
rvr_options.width   = sigma_opt;

% Train RVR Model
clear model
[~, model] = rvm_regressor(X,y,rvr_options,[]);

% Plot RVR function 
ml_plot_rvr_function(X, y, model, rvr_options);
