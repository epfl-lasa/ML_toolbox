%% Part One of Assignment III  [Advanced Machine Learning]
%% Classification. Make sure you have added the path of ML_toolbox to your directory.
%
clear all;
close all;

%% RUN THIS IF SVM FUNCTIONS DON'T WORK <only once> (Go to ML_toolbox Dir)
ML_toolbox_path = pwd;
cd './methods/toolboxes/libsvm/matlab'
make
cd(ML_toolbox_path)

%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));
%% You have to compare performance and model complexity for variants
%% of SVM (C-SVM, nu-SVM, RVM)
%% %%%%%%%%%%%%%%%%%%%
% 1) Choose a Dataset
%%%%%%%%%%%%%%%%%%%%%%
%% 1a) Generate Concentric Circle Data
clear all;
close all;

num_samples = 500;
dim_samples = 2;
num_classes = 2;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);
labels      = ml_2binary(labels)';

% Randomize indices of dataset
rand_idx = randperm(num_samples);
X = X(rand_idx,:);
labels = labels(rand_idx);

% Plot data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Concentric Circles Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
legend('Class 1', 'Class -1')
axis equal

%% 1b) Generate Checkerboard Data
clear all;
close all;

num_samples_p_quad = 100; % Number of points per quadrant
[X,labels] = ml_checkerboard_data(num_samples_p_quad);

% Plot data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Checkerboard Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
legend('Class 1', 'Class -1')
axis equal

%% 1c) Load Very Non-linear data

clear all;
close all;
load('very-nonlinear-data')

% Plot data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Very Non-Linear Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
legend('Class 1', 'Class -1')
axis equal

%% 1d) Load Ripley Dataset

clear all;
close all;

load('rvm-ripley-dataset')

% Plot data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Ripley Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
legend('Class 1', 'Class 0')
axis equal


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     SUPPORT VECTOR MACHINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2a)EXAMPLE SVM OPTIONS FOR C-SVM with RBF Kernel%
clear options
options.svm_type    = 0;    % 0: C-SVM, 1: nu-SVM
options.kernel_type = 0;    % 0: RBF, 1: Polynomial (0 is the default)
options.C           = 1000; % Cost (C \in [1,1000]) in C-SVM
options.sigma       = 0.75; % radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

%% 2b) EXAMLPE SVM OPTIONS FOR nu-SVM with RBF Kernel% 
clear options
options.svm_type    = 1;    % 0: C-SVM, 1: nu-SVM
options.nu          = 0.05; % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
options.sigma       = 1;    % radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

%% 2c) EXAMLPE SVM OPTIONS FOR C-SVM with Polynomial Kernel% 
clear options
options.svm_type    = 1;    % 0: C-SVM, 1: nu-SVM
options.kernel_type = 1;    % 0: RBF, 1: Polynomial
options.nu          = 0.25;  % nu \in (0,1) (upper-bound for misclassifications on margni and lower-bound for # of SV) for nu-SVM
options.degree      = 1;    % polynomial kernel: (<x,x^i> + coeff)^degree
options.coeff       = 0;    % polynomial kernel: (<x,x^i> + coeff)^degree, when coeff=0 homogeneous, coeff>=1 inhomogeneous

%% Train SVM Classifier
[predict_labels, model] = svm_classifier(X, labels, options, []);

% Plot SVM decision boundary
ml_plot_svm_boundary( X, labels, model, options, 'draw');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3) Do grid-search to find 'optimal' hyper-parameters for C-SVM with RBF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3a)  Set options for SVM Grid Search and Execute
clear options
options.svm_type   = 0;         % SVM Type (0:C-SVM, 1:nu-SVM)
options.limits_C   = [1, 200];  % Limits of penalty C
options.limits_w   = [0.25, 2]; % Limits of kernel width \sigma
options.steps      = 20;        % Step of parameter grid 
options.K          = 10;        % K-fold CV parameter

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_class( X, labels, options );

% Extract parameter ranges
range_C  = cranges(1,:);
range_w  = cranges(2,:);

% Get CV statistics
stats = ml_get_cv_grid_states(ctest,ctrain);

% Visualize Grid-Search Heatmap
cv_plot_options              = [];
cv_plot_options.title        = strcat('C-SVM :: ', num2str(options.K),'-fold CV with RBF');
cv_plot_options.param_names  = {'C', '\sigma'};
cv_plot_options.param_ranges = [range_C ; range_w];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

% Find 'optimal hyper-parameters'
[max_acc,ind] = max(stats.test.acc.mean(:));
[C_max, w_max] = ind2sub(size(stats.test.acc.mean),ind);
C_opt = range_C(C_max);
w_opt = range_w(w_max);

%% 3b) Plot Decision Boundary with 'Optimal' Hyper-parameters
options.svm_type = 0;    
options.C        = round(C_opt);
options.sigma    = w_opt; 

% OR

% Manually Choose other hyper-parameters form visually inspecting Heatmap
% options.C        = 21;
% options.sigma    = 0.34; 

% Train SVM Classifier
[predict_labels, model] = svm_classifier(X, labels, options, []);

% Plot SVM decision boundary
ml_plot_svm_boundary( X, labels, model, options, 'draw');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4) Do grid-search to find 'optimal' hyper-parameters for nu-SVM with RBF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4a)  Set options for SVM Grid Search and Execute
clear options
options.svm_type   = 1;           % SVM Type (0:C-SVM, 1:nu-SVM)
options.limits_nu  = [0.01, 0.7]; % Limits of penalty nu
options.limits_w   = [0.1, 1];    % Limits of kernel width \sigma
options.steps      = 20;          % Step of parameter grid 
options.K          = 10;          % K-fold CV parameter

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_class( X, labels, options );

% Extract parameter ranges
nu_range = cranges(1,:);
w_range  = cranges(2,:);

% Get CV statistics 
stats = ml_get_cv_grid_states(ctest,ctrain);

% Visualize Grid-Search Heatmap
cv_plot_options              = [];
cv_plot_options.title        = strcat('\nu-SVM :: ', num2str(options.K),'-fold CV with RBF');
cv_plot_options.param_names  = {'\nu', '\sigma'};
cv_plot_options.param_ranges = [nu_range ; w_range];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

% Find 'optimal hyper-parameters'
[max_acc,ind]   = max(stats.test.acc.mean(:));
[nu_max, w_max] = ind2sub(size(stats.test.acc.mean),ind);
nu_opt = nu_range(nu_max);
w_opt  = w_range(w_max);

%% 4b) Plot Decision Boundary with 'Optimal' Hyper-parameters
clear options
options.svm_type = 1;    
options.nu       = nu_opt;
options.sigma    = w_opt; 

% OR

% Manually Choose other hyper-parameters form visually inspecting Heatmap
% options.nu       = 0.04;
% options.sigma    = 1; 

% Train SVM Classifier
[predict_labels, model] = svm_classifier(X, labels, options, []);

% Plot SVM decision boundary
ml_plot_svm_boundary( X, labels, model, options, 'draw');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5) Do grid-search to find 'optimal' hyper-parameters for SVM with Poly
% Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5a) Do Grid Search on SVM with polynomial kernels
clear options
options.svm_type    = 0;         % SVM Type (0:C-SVM, 1:nu-SVM)
options.kernel_type = 1;         % 0: RBF, 1: Polynomial
options.limits_C    = [1, 100];  % Limits of penalty C
options.limits_d    = [1, 10];   % Limits of polynomial degree
options.coeff       = 1;         % 0:, Homogeneous Polynomial, 1: Inhomogeneous Polynomial,
options.steps       = 10;        % Step of parameter grid 
options.K           = 10;        % K-fold CV parameter

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_class( X, labels, options );

% Extract parameter ranges
range_C  = cranges(1,:);
range_d  = cranges(2,:);

% Get CV statistics
stats = ml_get_cv_grid_states(ctest,ctrain);

% Visualize Grid-Search Heatmap
cv_plot_options              = [];
cv_plot_options.title        = strcat('C-SVM :: ', num2str(options.K),'-fold CV Inhomogeneous Poly');
cv_plot_options.param_names  = {'C', 'degree'};
cv_plot_options.param_ranges = [range_C ; range_d];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

% Find 'optimal hyper-parameters'
[max_acc,ind] = max(stats.test.acc.mean(:));
[C_max, d_max] = ind2sub(size(stats.test.acc.mean),ind);
C_opt = range_C(C_max);
d_opt = range_d(d_max);


%% 4b) Plot Decision Boundary with 'Optimal' Hyper-parameters
clear options
options.svm_type    =  0;    
options.kernel_type = 1;    
options.C           = C_opt;
options.degree      = d_opt;  
options.coeff       = 1;

% Train SVM Classifier
[predict_labels, model] = svm_classifier(X, labels, options, []);

% Plot SVM decision boundary
ml_plot_svm_boundary( X, labels, model, options, 'draw');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     RELEVANCE VECTOR MACHINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6a) Try RVM on Data

clear rvm_options
%Set RVM OPTIONS%
rvm_options.useBias = true;
rvm_options.kernel_ = 'gauss';
rvm_options.width   = 0.75;
rvm_options.maxIts  = 100;

% Train RVM Classifier
[predict_labels, model] = rvm_classifier(X, labels , rvm_options, []);

% Plot RVM decision boundary
ml_plot_rvm_boundary( X, labels, model, 'draw');

%% 6b) Do Grid Search on RVM
clear options
% Set Options for RVM Grid Search
options.limits_w   = [0.25, 1.5];    % Limits of kernel width \sigma
options.steps      = 10;          % Step of parameter grid 
options.K          = 10;          % K-fold CV parameter

% In function (X, labels, options, '')
range_w = linspace(options.limits_w(1), options.limits_w(2), options.steps);

% RVM Params
rvm_options.useBias = true;
rvm_options.kernel_ = 'gauss';
rvm_options.maxIts  = 100;

% Store results
ctest  = cell(options.K,1);
ctrain = cell(options.K,1);

disp('Grid search RVM');
disp('...');
num_param = length(range_w);
for i=1:num_param
    disp([num2str(i) '/' num2str(num_param)]);
    
    rvm_options.width   = range_w(i);
    f = @(X,labels,model)rvm_classifier(X, labels, rvm_options, model);
    [test_eval,train_eval] = ml_kcv(X, labels, options.K, f);
    
    ctest{i}  = test_eval;
    ctrain{i} = train_eval;
    
end

% Get CV statistics
stats = ml_get_cv_grid_states(ctest,ctrain);

% Plot CV statistics
cv_plot_options        = [];
cv_plot_options.title   = [num2str(options.K) '-fold CV'];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

hAllAxes            = findobj(gcf,'type','axes');
hAllAxes.XTick      = 1:options.steps;
hAllAxes.XTickLabel = strread(num2str(range_w),'%s');

%% 6c) Plot Decision Boundary with 'Optimal' Hyper-parameter
[max_acc,ind]   = max(stats.test.acc.mean(:));
w_opt  = range_w(ind);

%OR

%Manually Choose from Test/Train Accuracy
% w_opt = 0.7;

%Set RVM OPTIONS%
rvm_options.useBias = true;
rvm_options.kernel_ = 'gauss';
rvm_options.width   = w_opt;
rvm_options.maxIts  = 100;

% Train RVM Classifier
[predict_labels, model] = rvm_classifier(X, labels , rvm_options, []);

% Plot RVM decision boundary
ml_plot_rvm_boundary( X, labels, model, 'draw');

