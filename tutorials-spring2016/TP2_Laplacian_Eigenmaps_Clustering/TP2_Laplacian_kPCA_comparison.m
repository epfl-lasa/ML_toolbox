%% Make sure you have added the path of ML_toolbox to your directory.
%
%addpath(genpath(./))
% You have to figure out the number of clusters present in the datasets by
% using different projection techniques
 
clear all; close all;
%% Generate Circle Data

num_samples = 1000;
dim_samples = 2;
num_classes = 2;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);

% Plot original data

plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);


%% Digit dataset 1)
[X,labels] = ml_load_digits_64('data/digits.csv',[0 1 2 3 4 5]);

% Plot images
%   Visualise the images
%

if exist('hi','var') && isvalid(hi), delete(hi);end
idx = randperm(size(X,1));
hi  = ml_plot_images(X(idx(1:64),:),[8 8]);

% Plot Images as data
%   
%   The data is relatively high dimensional (64). We cannot visualise all
%   the scatter plots in this setting. We would have 64 x 64 subplots,
%   matlab cannot handle this very well.
%
%   Here we randomely choose some data points and plot the first 8
%   dimensions. Feel free to change the parameters.

idx                         = randperm(size(X,1));
plot_options                = [];

plot_options.is_eig         = false;
plot_options.labels         = labels(idx(1:64));
plot_options.title          = 'Original Image Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X(idx(1:64),[1 2 3 4 5 6 7 8]),plot_options);

%% Breast-cancer-Wisconsin 2)

[X,labels,class_names] = ml_load_data('data/breast-cancer-wisconsin.csv','csv','last');

% Plot data
plot_options                = [];

plot_options.is_eig         = false;
plot_options.labels         = labels;
plot_options.class_names    = class_names; 
plot_options.title          = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X(:,1:3),plot_options);

%% House-votes 3)

[X,labels,class_names] = ml_load_data('data/house-votes-84.csv','csv','last');

% Plot data
plot_options                = [];

plot_options.is_eig         = false;
plot_options.labels         = labels;
plot_options.class_names    = class_names; 
plot_options.title          = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X(:,1:3),plot_options);


%% Do Laplacian Eigenmaps

options = [];
options.method_name       = 'Laplacian';  
options.nbDimensions      = 10;      % these are the number of eigenvectors to keep.
options.neighbors         = 7;       % this is the number of neighbors to compute the graph
options.sigma             = 0.3;

[proj_LAP_X, mappingLAP]         = ml_projection(X,options);

%% Plot result of Laplacian

if exist('h3','var') && isvalid(h3), delete(h3);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data Laplacian Eigenmaps';


h3 = ml_plot_data(proj_LAP_X(:,[1 2 3]),plot_options);

%% Grid Search on the number of neighbors

options = [];
options.method_name       = 'Laplacian';
options.nbDimensions      = 10;
options.sigma             = 0.3; 

neighborsPars = [5 7 10 15 20]; 

[ eigenvalues ] = ml_neighbors_grid_search(X,options,neighborsPars);

if exist('h_eig_lap','var')     && isvalid(h_eig_lap),     delete(h_eig_lap);    end
h_eig_lap  = ml_plot_kpca_eigenvalues(eigenvalues,neighborsPars);

%% Grid Search on the width of the kernel

options = [];
options.method_name       = 'Laplacian';
options.nbDimensions      = 10;
options.neighbors         = 7; 

sigmaPars = [0.05 0.1 0.3 0.5 1 2]; 

[ eigenvalues ] = ml_kernel_lap_grid_search(X,options,sigmaPars);

if exist('h_eig_lap2','var')     && isvalid(h_eig_lap2),     delete(h_eig_lap2);    end
h_eig_lap2  = ml_plot_kpca_eigenvalues(eigenvalues,sigmaPars);

%% Do kernel PCA

optionts = [];
options.method_name       = 'KPCA';  
options.nbDimensions      = 20;      % these are the number of eigenvectors to keep.
options.kernel            = 'gauss'; % the type of Kernel to use.
options.kpar              = 0.5;     % this is the variance of the Gaussian function

[proj_kPCA_X, mappingKPCA]         = ml_projection(X,options);

%% Plot result of Kernel PCA

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data kPCA';


h2 = ml_plot_data(proj_kPCA_X(:,[1 2 3]),plot_options);

%% Plot Isolines of Kernel PCA


iso_plot_options                    = [];
iso_plot_options.xtrain_dim         = [1 2];          % Dimensions of the orignal data to consider when computing the gramm matrix (since we are doing 2D plots, original data might be of higher dimension)
iso_plot_options.eigen_idx          = [1];            % Eigenvectors to use.
iso_plot_options.b_plot_data        = true;           % If you want to plot the training data on top of the isolines 
iso_plot_options.labels             = labels;         % If you set this field the plotted data will be colored according to class label
iso_plot_options.b_plot_colorbar    = false;          % If you want to plot the colorbar or not.
iso_plot_options.b_plot_eigenvalues = true;

kernel_data                         = [];
kernel_data.alphas                  = mappingKPCA.V;
kernel_data.kernel                  = mappingKPCA.kernel;
kernel_data.kpar                    = [mappingKPCA.param1,mappingKPCA.param2];
kernel_data.xtrain                  = mappingKPCA.X;
kernel_data.eigen_values            = sqrt(mappingKPCA.L);

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end
[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);


%% BIC & AIC (K-means)

cluster_options             = [];
cluster_options.method_name = 'kmeans';
repeats                     = 15;
Ks                          = 1:10;
%                                                    use X or proj_X(:,1:2)
[mus, stds]                 = ml_clustering_optimise(proj_kPCA_X(:,1:2),Ks,repeats,cluster_options,'Start','plus','Distance','sqeuclidean');
%% Plot RSS, AIC and BIC
if exist('h_bic','var')     && isvalid(h_bic),     delete(h_bic);    end
h_bic                       = ml_plot_rss_aic_bic(mus,stds,Ks);

