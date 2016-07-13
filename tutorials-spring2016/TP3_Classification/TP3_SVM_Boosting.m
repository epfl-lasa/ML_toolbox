%% Part Three of Assignment III  [Advanced Machine Learning]
%% Classification. Make sure you have added the path of ML_toolbox to your directory.
%
clear all;
close all;

%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));
%% You have to compare performance of C-SVM and Boosting on dataset with outliers, noise and unbalanced classes
%% %%%%%%%%%%%%%%%%%%%
% 1) Choose a Dataset
%%%%%%%%%%%%%%%%%%%%%%
%% 1a) Generate Concentric Circle Data
changingDataMethod = 'no';
num_samples = 200;
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

%% 1b) Generate two random clusters
changingDataMethod = 'no';
num_samples = 50;
dim_samples = 2;
num_classes = 2;

X           = [randn(num_samples,2) ; randn(num_samples,2) + 5];
labels      = [ones(num_samples,1) ; ones(num_samples,1) + 1];
labels      = ml_2binary(labels)';

% Randomize indices of dataset
rand_idx = randperm(2*num_samples);
X = X(rand_idx,:);
labels = labels(rand_idx);

% Plot data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Clusters Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
legend('Class 1', 'Class -1')
axis equal

%% 1c) Generate Checkerboard Data
changingDataMethod = 'no';
num_samples_p_quad = 200; % Number of points per quadrant
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

%% 1d) Load Very Non-linear data
changingDataMethod = 'no';
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

%% 1e) Load Ripley Dataset
changingDataMethod = 'no';
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

%% %%%%%%%%%%%%%%%%%%%%
% 2) Change the Dataset
%%%%%%%%%%%%%%%%%%%%%%%
%% 2a) Add some outliers in the dataset
    percentageOfOutliers = 20; % Choose a percentage of outliers in each class

    labelsTest = labels;
    
    XNoise = X;

    labelsNoise = ml_generate_outliers_2D(labels,percentageOfOutliers);

    changingDataMethod = 'outliers';

%% 2b) Add some noise in the dataset
    percentageOfNoisyData = 25; % Choose a percentage of noisy data in each class
    
    labelsNoise = labels;

    XNoise = ml_generate_noise_2D(X,labels,percentageOfNoisyData);

    changingDataMethod = 'noise';

%% 2c) Generate an unbalanced dataset
    percentageOfRemovedData = 50; % Choose a percentage of data to remove from one class

    [XNoise, labelsNoise] = ml_generate_unbalance_2D(X,labels,percentageOfRemovedData);

    changingDataMethod = 'unbalance';

%% 2d) Plot the changes

plot_options.labels = labelsNoise;

if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = ml_plot_data(XNoise,plot_options);
legend('Class 1', 'Class 0')
axis equal

%% %%%%%%%%%%%%%%%%%%%%%%%%
% 3) Perform classification
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3a) C-SVM
options.svm_type = 0;    % 0: C-SVM, 1: nu-SVM
options.C        = 50;   % Cost (C \in [1,1000]) in C-SVM
options.sigma    = 2;    % radial basis function: exp(-gamma*|u-v|^2), gamma = 1/(2*sigma^2)

[predict_labels, model] = svm_classifier(XNoise, labelsNoise, options, []);

% Plot SVM decision boundary
if exist('hc1','var') && isvalid(hc1), delete(hc1);end
hc1 = ml_plot_svm_boundary( XNoise, labelsNoise, model, options, 'draw');

% Perform cross-validation 

options.K        = 10;   % number of folders for the cross validation

fsvm = @(XNoise,labelsNoise,model)svm_classifier(XNoise, labelsNoise, options, model);
if(strcmp(changingDataMethod,'outliers'))
    [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fsvm,labelsTest);
else
    [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fsvm);
end

test_eval_svm = [mean(test_eval.accuracy), std(test_eval.accuracy)];
train_eval_svm = [mean(train_eval.accuracy), std(train_eval.accuracy)];

%% 3b) Boosting
options.nbWeakClassifiers = 50;

[classestimate,model,D]= adaboost_classifier(XNoise,labelsNoise,options.nbWeakClassifiers,[]);
fboost                      = @(XNoise)adaboost_classifier(XNoise,[],[],model);

% Plot strong classifier sign[C(x)]

c_options         = [];
plot_data_options = [];

c_options.title   = ['AdaBoost  ' num2str(length(model)) ' models'];
plot_data_options.weights = ml_scale(D,1,options.nbWeakClassifiers);

if exist('hc2','var') && isvalid(hc2), delete(hc2);end
hc2 = ml_plot_classifier(fboost,XNoise,labelsNoise,c_options,plot_data_options);

% Perform cross-validation 

options.K        = 10;   % number of folders for the cross validation

fboost = @(XNoise,labelsNoise,model)adaboost_classifier(XNoise,labelsNoise,options.nbWeakClassifiers,model);
if(strcmp(changingDataMethod,'outliers'))
    [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fboost,labelsTest);
else
    [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fboost);
end

test_eval_boost = [mean(test_eval.accuracy), std(test_eval.accuracy)];
train_eval_boost = [mean(train_eval.accuracy), std(train_eval.accuracy)];

%% 3c) Plot comparison

figure
bar([train_eval_svm(1) test_eval_svm(1); train_eval_boost(1) test_eval_boost(1)]);
err = gca;
set(err,'FontSize',14.0,'XTick',[1 2],'XTickLabel',{'C-SVM', 'AdaBoost'})
hold on
errorbar([0.86 1.14 1.86 2.14],[train_eval_svm(1) test_eval_svm(1) train_eval_boost(1) test_eval_boost(1)],[train_eval_svm(2) test_eval_svm(2) train_eval_boost(2) test_eval_boost(2)], '+k', 'LineWidth', 2)
legend('Training set', 'Testing set');
ylabel('Accuracy')
title(['Comparison of SVM and Boosting after "' changingDataMethod '" change'])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4) Evaluate the influence of the changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    XOriginal = X;
    labelsOriginal = labels;

    changingDataMethod = 'outliers'; %'outliers' or 'noise' or 'unbalance'
    rangePercentage = [0 5 10 15 20 25 30 35 40 45 50];

    options.K = 10;

    for i = 1:length(rangePercentage)
        switch changingDataMethod
            case 'outliers'
                labelsTest = labelsOriginal;
                labelsNoise = ml_generate_outliers_2D(labelsOriginal,rangePercentage(i));
            case 'noise'
                XNoise = ml_generate_noise_2D(XOriginal,labelsOriginal,rangePercentage(i));
            case 'unbalance'
                [XNoise, labelsNoise] = ml_generate_unbalance_2D(XOriginal,labelsOriginal,rangePercentage(i));
        end

        %Cross validation SVM and Boosting
        options.svm_type = 0;
        options.C        = 50;   
        options.sigma    = 2; 
        fsvm = @(XNoise,labelsNoise,model)svm_classifier(XNoise, labelsNoise, options, model);
        if(strcmp(changingDataMethod,'outliers'))
            [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fsvm,labelsTest);
        else
            [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fsvm);
        end
        test_eval_svm(i,:) = [mean(test_eval.accuracy), std(test_eval.accuracy)];
        train_eval_svm(i,:) = [mean(train_eval.accuracy), std(train_eval.accuracy)];

        options.nbWeakClassifiers = 60;
        fboost = @(XNoise,labelsNoise,model)adaboost_classifier(XNoise,labelsNoise,options.nbWeakClassifiers,model);
        if(strcmp(changingDataMethod,'outliers'))
            [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fboost,labelsTest);
        else
            [test_eval,train_eval] = ml_kcv(XNoise,labelsNoise,options.K,fboost);
        end
        test_eval_boost(i,:) = [mean(test_eval.accuracy), std(test_eval.accuracy)];
        train_eval_boost(i,:) = [mean(train_eval.accuracy), std(train_eval.accuracy)];

    end
    figure
%     errorbar(train_eval_svm(:,1),train_eval_svm(:,2),'LineWidth',2)
    hold on
    errorbar(test_eval_svm(:,1),test_eval_svm(:,2),'LineWidth',2)
%     errorbar(train_eval_boost(:,1),train_eval_boost(:,2),'LineWidth',2)
    errorbar(test_eval_boost(:,1),test_eval_boost(:,2),'LineWidth',2)
%     plot(train_eval_svm(:,1),'LineWidth',2)
%     hold on
%     plot(test_eval_svm(:,1),'LineWidth',2)
%     plot(train_eval_boost(:,1),'LineWidth',2)
%     plot(test_eval_boost(:,1),'LineWidth',2)
    legend('Testing SVM','Testing AdaBoost')
    err = gca;
    set(err,'FontSize',14.0,'XTick',1:length(rangePercentage),'XTickLabel',num2str(rangePercentage'))
    ylabel('Accuracy')
    xlabel('Percentage of changed data')
    title(['Comparison of SVM and Boosting after "' changingDataMethod '" change'])








%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid Search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Grid search C-SVM with CV
options.svm_type   = 0;   % SVM Type (0:C-SVM, 1:nu-SVM)
options.limits_C   = [1, 200]; % Limits of penalty nu
options.limits_w   = [0.1, 5]; % Limits of kernel width \sigma
options.steps      = 20; % Step of parameter grid 
options.K          = 10; % K-fold CV parameter

range_p1 = linspace(options.limits_C(1), options.limits_C(2), options.steps);
range_p2 = linspace(options.limits_w(1), options.limits_w(2), options.steps);

% Do Grid Search
for i=1:length(range_p1)
    for j=1:length(range_p2)
        options.C       = range_p1(i);
        options.sigma    = range_p2(j);
        
        fsvm = @(X,labels,model)svm_classifier(X, labels, options, model);        
        if(strcmp(changingDataMethod,'outliers'))
            [test_eval,train_eval] = ml_kcv(X,labels,options.K,fsvm,labelsTest);
        else
            [test_eval,train_eval] = ml_kcv(X,labels,options.K,fsvm);
        end 

        ctest{i,j}  = test_eval;
        ctrain{i,j} = train_eval;
    end
end

% Extract parameter ranges
range_C  = range_p1;
range_w  = range_p2;

% Get CV statistics
stats = ml_get_cv_grid_states(ctest,ctrain);

% Visualize Grid-Search Heatmap
cv_plot_options              = [];
cv_plot_options.title        = strcat('C-SVM :: ', num2str(options.K),'-fold CV');
cv_plot_options.param_names  = {'C', '\sigma'};
cv_plot_options.param_ranges = [range_C ; range_w];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

%% Grid search AdaBoost with CV

% range of number of weak classifiers (decision stumps) 
range_weak_c = [1,10,20,30,40,50,60,70,80,90,100];

% K-fold CV parameter
options.K = 10;

% Store results
ctest  = cell(options.K,1);
ctrain = cell(options.K,1);

disp('Grid search AdaBoost');
disp('...');
num_para = length(range_weak_c);
for i=1:num_para
    disp([num2str(i) '/' num2str(num_para)]);
    
    fboost = @(X,labels,model)adaboost_classifier(X,labels,range_weak_c(i),model);
    
    if(strcmp(changingDataMethod,'outliers'))
        [test_eval,train_eval] = ml_kcv(X,labels,options.K,fboost,labelsTest);
    else
        [test_eval,train_eval] = ml_kcv(X,labels,options.K,fboost);
    end    
    
    ctest{i}  = test_eval;
    ctrain{i} = train_eval;
    
end

% Get CV statistics

stats = ml_get_cv_grid_states(ctest,ctrain);

%% Plot CV statistics

cv_plot_options        = [];
cv_plot_options.title   = [num2str(options.K) '-fold CV'];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

hAllAxes            = findobj(gcf,'type','axes');
hAllAxes.XTick      = 1:11;
hAllAxes.XTickLabel = strread(num2str(range_weak_c),'%s');