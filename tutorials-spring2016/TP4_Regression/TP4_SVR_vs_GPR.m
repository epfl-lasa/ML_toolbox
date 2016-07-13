%% Comparison of SVR and GPR on real-world dataset
clear all;
close all;
%% Load real data

fileName            = 'data/winequality-red.csv';%'data/winequality-white.csv'%
data                = csvread(fileName);
samples             = size(data,1);

X = data(:,1:end-1);
y = data(:,end);

% Plot data
options             = [];
options.points_size = 10;
options.title       = 'Wine Quality data';
options.labels      = floor(y);

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data(X,options);

% Normalized the data

for column = 1:size(X,2)
        X(:,column)=(X(:,column)-min(X(:,column)))/(max(X(:,column))-min(X(:,column)));
end


%% Remove data

percentageOfRemovedData     = 50; % Choose the percentage of data to remove

nbRemovedData               = ceil(samples*percentageOfRemovedData/100);
rndIndices                  = randperm(samples,nbRemovedData);

Xbis                        = X(rndIndices,:);
ybis                        = y(rndIndices,:);

%% Gaussian Process

%First perform grid search to have an idea of the hyperparameters

disp('Parameter grid search GP');

function_type = {'GPR'};
epsilons = [0.001 0.01];
rbf_vars = [10 100];
parameters = vertcat(epsilons, rbf_vars);
step = 2;
Kfold = 10;
metric = 'nmse';

% Do grid search
[ test, train , ranges ] = ml_grid_search_regr( X, y, Kfold, parameters, step, function_type);

% Get CV statistics
[ statsGPR ] = ml_get_cv_grid_states_regression(test,train);

% Get optimal parameters and metrics for these ones
[min_metricGPR,indGPR] = min(statsGPR.test.(metric).mean(:));
[eps_min, w_min] = ind2sub(size(statsGPR.test.(metric).mean),indGPR);
epsilon_opt = ranges{1}(eps_min);
width_opt = ranges{2}(w_min);

%% Test GPR

% Test model with optimal parameter or choose some parameter
modelGPR.Xtrain = Xbis;
modelGPR.Ytrain = ybis;
epsilon = 0.01;%epsilon_opt;
width = 15;%width_opt;
clear test train;
fGPR = @(Xbis,ybis,modelGPR)ml_gpr(Xbis, ybis, modelGPR, epsilon, width, 'gpml');
[test{1},train{1}]  = ml_kcv(Xbis,ybis,10,fGPR,'regression');

statsGPR = ml_get_cv_grid_states_regression(test,train);


%% SVR

%First perform grid search to have an idea of the hyperparameters

disp('Parameter grid search SVR');

svm_type        = '0';       % SVR Type (0:epsilon-SVR, 1:nu-SVR)
kernel_type     = 2;         % 0: linear: u'*v, 1: polynomial: (gamma*u'*v + coef0)^degree, 2: radial basis function: exp(-gamma*|u-v|^2)
function_type   = {svm_type , kernel_type};
limits_C        = [1 30];  % Limits of penalty C
limits_epsilon  = [0.05 1];  % Limits of epsilon
limits_w        = [0.25 2]; % Limits of kernel width \sigma
parameters      = vertcat(limits_C, limits_epsilon, limits_w);
step            = 3;        % Step of parameter grid 
Kfold           = 10;
metric = 'nmse';

% Do Grid Search
[ ctest, ctrain , cranges ] = ml_grid_search_regr( X, y, Kfold, parameters, step, function_type);

% Get CV statistics
statsSVR = ml_get_cv_grid_states_regression(ctest,ctrain);

% Get optimal parameters
[min_metricSVR,indSVR] = min(statsSVR.test.(metric).mean(:));
[C_min, epsilon_min, sigma_min] = ind2sub(size(statsSVR.test.(metric).mean),indSVR);
C_opt = cranges{1}(C_min);
epsilon_opt = cranges{2}(eps_min);
sigma_opt = cranges{3}(sigma_min);

%% Test SVR

% Test model with optimal parameter or choose some parameter
clear svr_options
svr_options.svr_type    = 0;
svr_options.C           = 10;%C_opt;    
svr_options.epsilon     = 0.000001;%epsilon_opt; 
svr_options.kernel_type = 2;%kernel_type;
svr_options.sigma       = 0.5;%sigma_opt;
model = [];
clear test train;

fSVR = @(Xbis,ybis,model)svm_regressor(Xbis, ybis, svr_options,model);
[test{1},train{1}]  = ml_kcv(Xbis,ybis,10,fSVR,'regression');

[ statsSVR ] = ml_get_cv_grid_states_regression(test,train);

%% Compare the performance of GPR and SVR for the metric you choose after grid search

metric = 'nmse';

%  - mean squared error                               (mse)
%  - normalised mean squared error                    (nmse)


if exist('h3','var') && isvalid(h3), delete(h3);end
h3 = errorbar(1,statsGPR.test.(metric).mean, statsGPR.test.(metric).std,'rx','LineWidth',2);
hold on
errorbar(2,statsSVR.test.(metric).mean, statsSVR.test.(metric).std,'bx','LineWidth',2);
ax=gca;
set(ax,'XTick',[1 2])
set(ax, 'XTickLabel', {'GPR';'SVR'})
ylabel(metric)
title(['Comparison of GPR and SVR with the metric : ' metric]) 
