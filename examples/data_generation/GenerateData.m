%% Example of how to generate different data sets and how to plot them;
 
clear all; close all;

%% Plot multiple concentric 2D circles

num_samples = 10000;
dim_samples = 2;
num_classes = 10;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);


if exist('h1','var') && isvalid(h1), delete(h1);end
plot_options            = [];
plot_options.labels     = labels;
plot_options.title      = 'Circles';

h1 = ml_plot_data(X,plot_options);

%% Plot multiple concentric 3D circles

num_samples = 10000;
dim_samples = 3;
num_classes = 10;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);


if exist('h1','var') && isvalid(h1), delete(h1);end
plot_options            = [];
plot_options.labels     = labels;
plot_options.title      = 'Circles';

h1 = ml_plot_data(X,plot_options);
axis square;

%% Generate Gaussian Clusters

num_samples = 1800;
num_classes = 5;
dim         = 3;

[X,labels,gmm] = ml_clusters_data(num_samples,dim,num_classes);


%options.labels   = labels;
options.title    = 'Random Gaussian';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal;