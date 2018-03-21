%% Example of Kernel Kmeans clustering
% put your example here denys (isolonines + nonlinear decision boundaries,
% BIC, AIC, etc
clear all; close all;

%%%%%%%%%%%%%%%% How to set num_samples %%%%%%%%%%%%%%%%
% If num_samples = 100 is a scalar that will be taken as the total number of
% samples and each class will have an equal number of samples
% If num_samples = [100 200] is a vector, each value will be the number of
% samples per class, the total number of samples = sum(num_samples), note
% that the vector must have the same length as the num_classes variable
num_samples     = 100;
num_classes     = 3;
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
cluster_options.kernel      = 'poly';
cluster_options.kpar        = [0 2];

[result1]                   = ml_clustering(X,cluster_options);

% Plot decision boundary
result1.title      = 'Kernel K ($2$)-Means on Original Data';
result1.plot_labels = {'$x_1$','$x_2$'};
if exist('hd','var') && isvalid(hd), delete(hd);end
hd = ml_plot_class_boundary(X,result1);
