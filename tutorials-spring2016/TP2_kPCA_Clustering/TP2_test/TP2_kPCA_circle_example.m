%% Part One of Assignment II  [Advanced Machine Learning]
%% Clustering. Make sure you have added the path of ML_toolbox to your directory.
%
%
%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));

clear all;
close all;

%% You have to figure out the number of clusters present in the datasets
%% by using kernel-PCA
%% Generate Circle Data

num_samples = 1000;
dim_samples = 2;
num_classes = 2;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);

%% Plot original data


plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% Do kernel PCA

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 20;
options.kernel            = 'gauss';
options.kpar              = 2;     % if poly this is the offset
%options.kpar(2)           = 0;      % if poly this is the degree
options.neighbors         = 7;

[proj_X, mapping]         = ml_projection(X,options);


%% Plot result of Kernel PCA

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data kPCA';


h2 = ml_plot_data(proj_X(:,[1:4]),plot_options);

%% Plot Isolines of Kernel PCA


iso_plot_options                    = [];
iso_plot_options.xtrain_dim         = [1 2];          % Dimensions of the orignal data to consider when computing the gramm matrix (since we are doing 2D plots, original data might be of higher dimension)
iso_plot_options.eigen_idx          = [1];            % Eigenvectors to use.
iso_plot_options.b_plot_data        = true;           % If you want to plot the training data on top of the isolines 
iso_plot_options.labels             = labels;         % If you set this field the plotted data will be colored according to class label
iso_plot_options.b_plot_colorbar    = false;          % If you want to plot the colorbar or not.
iso_plot_options.b_plot_eigenvalues = true;

kernel_data                         = [];
kernel_data.alphas                  = mapping.V;
kernel_data.kernel                  = mapping.kernel;
kernel_data.kpar                    = [mapping.param1,mapping.param2];
kernel_data.xtrain                  = mapping.X;
kernel_data.eigen_values            = sqrt(mapping.L);

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end
[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);

%% Example Plot first 4 eigenvectors

iso_plot_options.eigen_idx          = [1 2 3 4];          % Eigenvectors to use.
iso_plot_options.b_plot_data        = false;          % Lets not plot the data this time.

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end

[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);


