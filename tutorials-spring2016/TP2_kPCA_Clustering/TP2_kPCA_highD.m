%% Assignment II  [Advanced Machine Learning]
%%  kPCA example to determine the number of clusters. 
%% Make sure you have added the path of ML_toolbox to your directory.
%
% [  High dimensional clusters  ]
% You have to figure out the number of clusters present in the datasets by using kernel-PCA

clear all;  close all;
%% Generate some random data from a Gaussian Mixture Model

num_samples         = 1800;
num_classes         = 5;
dim                 = 10;
[X,labels,gmm]      = ml_clusters_data(num_samples,dim,num_classes);

%options.labels      = labels;
options.title       = 'Random Gaussian';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal;

%% Do Kernel PCA

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 15;
options.kernel            = 'gauss';
options.kpar              = 5;     % if poly this is the offset

[proj_X, mapping]         = ml_projection(X,options);

%% Plot result of Kernel PCA

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'High-D projected kPCA';

if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = ml_plot_data(proj_X(:,1:3),plot_options);


%% Plot Isolines of Kernel PCA

iso_plot_options                    = [];
iso_plot_options.xtrain_dim         = [1 2];          % Dimensions of the orignal data to consider when computing the gramm matrix (since we are doing 2D plots, original data might be of higher dimension)
iso_plot_options.eigen_idx          = [3];            % Eigenvectors to use.
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

iso_plot_options.eigen_idx          = [1 2 3 4 5];          % Eigenvectors to use.
%iso_plot_options.b_plot_data        = false;          % Lets not plot the data this time.

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end

[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);

%% Grid Search on the Gaussian kernel hyperparameter

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 10;
options.kernel            = 'gauss';
options.kpar              = 0.4;     % if poly this is the offset

kpars = [0.1,1,2,3,4,5,6,7,10,15]; 

[ eigenvalues ] = ml_kernel_grid_search(X,options,kpars);

if exist('h_eig2','var')     && isvalid(h_eig2),     delete(h_eig2);    end
h_eig2  = ml_plot_kpca_eigenvalues(eigenvalues,kpars);


%% BIC & AIC (K-means)
%
%   Lets see if we can find the number of clusters through RSS, AIC and BIC
%

cluster_options             = [];
cluster_options.method_name = 'kmeans';
repeats                     = 15;
Ks                          = 1:10;
%                                                    use X or proj_X(:,1:3)
[mus, stds]                 = ml_clustering_optimise(proj_X(:,1:3),Ks,repeats,cluster_options,'Start','plus','Distance','sqeuclidean');
%% Plot RSS, AIC and BIC
if exist('h_bic','var')     && isvalid(h_bic),     delete(h_bic);    end
h_bic                       = ml_plot_rss_aic_bic(mus,stds,Ks);



