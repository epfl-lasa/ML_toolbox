%% Example of how to use ml_clustering
clear all; close all;
%%

num_samples     = 200;
num_classes     = 3;
dim             = 3;
[X,labels,gmm]  = ml_clusters_data(num_samples,dim,num_classes);

options.labels   = labels;
options.title    = 'Random Clusters';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal

%% Clustering K-means

% k-means clustering
cluster_options.method_name = 'kmeans';
cluster_options.K           = 2;
[result]                    = ml_clustering(X,cluster_options,'Start','plus','Distance','sqeuclidean');

% Plot the result of the clustering
plot_options.labels         = result.labels;
plot_options.title          = 'Kmeans Clusters';
if exist('hc','var') && isvalid(hc), delete(hc);end
hc = ml_plot_data(X,plot_options);
ml_plot_centroid(result.centroids);
axis equal

%% Clustering Kernel-K-means

cluster_options.method_name = 'kernel-kmeans';
cluster_options.K           = 2;
cluster_options.kernel      = 'gauss';
cluster_options.kpar        = 0.1;

[result1]                    = ml_clustering(X,cluster_options);

%% Plot decision boundary
if exist('hd','var') && isvalid(hd), delete(hd);end
hd = ml_plot_class_boundary(X,result);
axis equal;

%% Evaluation

% first compute the confusion matrix
f = @(X)kmeans_classifier(X,result.centroids,result.distance);
M = ml_confusion_matrix(X,labels,f);

M

% comptute precision, recall, F1 and accuracy

[A,P,R,F] = ml_evaluation(M);

A
P
R
F



