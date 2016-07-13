%% Assignment II  [Advanced Machine Learning]
%% Make sure you have added the path of ML_toolbox to your directory.
%
% [  Circle clusters  ]
% You have to figure out the number of clusters present in the datasets by using kernel-PCA
 
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

%% Do kernel PCA
%   Now that you have generated the data we want to find the optimal number
%   of clusters present. Because the clusters are non-linearly seperable we
%   will use kPCA to try and retrive the number of clusters K. We know that
%   there are 2 clusters so hopefully we will be able to retreive this same
%   value.
%

optionts = [];
options.method_name       = 'KPCA';  
options.nbDimensions      = 20;      % these are the number of eigenvectors to keep.
options.kernel            = 'gauss'; % the type of Kernel to use.
options.kpar              = 0.4;     % this is the variance of the Gaussian function

[proj_X, mapping]         = ml_projection(X,options);

%% Plot result of Kernel PCA

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data kPCA';


h2 = ml_plot_data(proj_X(:,[1:2]),plot_options);

%   Ad you can see the clusters are nicely seperated. Ideally we would not
%   want to to look at the projection to determine the number of clusters.
%   Instead we would like to use the eigenvalues as means determining the
%   number of eigenvalues.
%
%
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

%
%   In the eigen-values vs eigenvector plot we see a clear jump from the
%   first eigenvector to the second and then the eigenvalues decreases
%   slowly. This might indicate that there are two clusters.
%
%   We next plot the isolines of the first 4 eigenvectors
%

%% Example Plot first 4 eigenvectors

iso_plot_options.eigen_idx          = [1 2 3 4];         % Eigenvectors to use.
iso_plot_options.b_plot_data        = false;             % Lets not plot the data this time.

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end

[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);

%
%   Here we clearly see that the first cluster is represented by the first
%   eigenvector. 
%
%   The second eigenvector does not fully characterise the second cluster
%   and a few more eigenvectors are required.
%
%   Trying to find the optimal number of clusters in this way is
%   cumbersome. A better way is to do a grid search over the kernel
%   parmeters and check how the eigenvalue-eigenvectors change.
%% Grid Search on the Gaussian kernel hyperparameter

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 10;
options.kernel            = 'gauss';
options.kpar              = 0.4;     % if poly this is the offset

kpars = [0.001,0.01, 0.05,0.1,0.2, 0.5,1,2]; 

[ eigenvalues ] = ml_kernel_grid_search(X,options,kpars);

if exist('h_eig2','var')     && isvalid(h_eig2),     delete(h_eig2);    end
h_eig2  = ml_plot_kpca_eigenvalues(eigenvalues,kpars);

% 
%   Two eigenvectors look like a good bet. Note that at the limits when 
%   the variance is too small and too large the eigenvalues are the same.
%

%% BIC & AIC (K-means)
%
%   Lets see if we can find the number of clusters through RSS, AIC and BIC
%

cluster_options             = [];
cluster_options.method_name = 'kmeans';
repeats                     = 15;
Ks                          = 1:10;
%                                                    use X or proj_X(:,1:2)
[mus, stds]                 = ml_clustering_optimise(proj_X(:,1:2),Ks,repeats,cluster_options,'Start','plus','Distance','sqeuclidean');
%% Plot RSS, AIC and BIC
if exist('h_bic','var')     && isvalid(h_bic),     delete(h_bic);    end
h_bic                       = ml_plot_rss_aic_bic(mus,stds,Ks);






