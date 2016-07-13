%% Example of Kernel Kmeans clustering
% put your example here denys (isolonines + nonlinear decision boundaries,
% BIC, AIC, etc
clear all; close all;
%%
num_samples     = 100;
num_classes     = 2;
dim             = 2;
[X,labels,gmm]  = ml_clusters_data(num_samples,dim,num_classes);

options.labels   = labels;
options.title    = 'Random Clusters';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal

%% Do K-kmeans 

cluster_options.method_name = 'kernel-kmeans';
cluster_options.K           = 2;
cluster_options.kernel      = 'gauss';
cluster_options.kpar        = 0.1;

[result1]                   = ml_clustering(X,cluster_options);

%% Plot decision boundary
if exist('hd','var') && isvalid(hd), delete(hd);end
hd = ml_plot_class_boundary(X,result1);


%% Plot isolines