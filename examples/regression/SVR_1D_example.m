%% Examples for Support Vector Regression on 1D Data
clear all;
close all;

%% RUN THIS IF SVM FUNCTIONS DON'T WORK <only once> (Go to ML_toolbox Root Dir)
ML_toolbox_path = pwd;
cd './methods/toolboxes/libsvm/matlab'
make
cd(ML_toolbox_path)

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
%                     SUPPORT VECTOR REGRESSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2a) epsilon-SVR + Linear Kernel
clear svr_options
% SVR OPTIONS
svr_options.svr_type    = 0;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.C           = 1;    % set the parameter C of C-SVC, epsilon-SVR, and nu-SVR 
svr_options.epsilon     = 0.25;  % set the epsilon in loss function of epsilon-SVR 
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
svr_options.epsilon     = 0.75; % set the epsilon in loss function of epsilon-SVR 
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
svr_options.epsilon     = 0.1;  % set the epsilon in loss function of epsilon-SVR 
% Kernel OPTIONS
svr_options.kernel_type = 2;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = 0.5;  %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)


% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

%% 2d) nu-SVR + RBF Kernel
% SVR OPTIONS
clear svr_options
svr_options.svr_type    = 1;    % 0: epsilon-SVR, 1: nu-SVR
svr_options.nu          = 0.1;  % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
svr_options.epsilon     = 0.1;  % set the epsilon in loss function of epsilon-SVR (default 0.1)
% Kernel OPTIONS
svr_options.kernel_type = 2;    % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
svr_options.sigma       = 0.5;   %  radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

% Train SVR Model
clear model
[~, model] = svm_regressor(X, y, svr_options, []);

% Plot SVR Regressive function, support vectors and epsilon tube
ml_plot_svr_function( X, y, model, svr_options);

