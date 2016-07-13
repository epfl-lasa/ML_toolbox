%% Assignment II  [Advanced Machine Learning]
%
%   Now that you had the chance to understand how to use kernel PCA as a 
%   to deduce the number of eigenvectors you do the same but with a real
%   data set.
%
%%
clear all; close all;
%% 1) Digit dataset
[X,labels] = ml_load_digits_64('data/digits.csv',[0 1 2 3 4 5]);

%% 2) Breast-cancer-Wisconsin

[X,labels,class_names] = ml_load_data('data/breast-cancer-wisconsin.csv','csv','last');

%% House-votes 3)

[X,labels,class_names] = ml_load_data('data/house-votes-84.csv','csv','last');

%% Plot images
%   Visualise the images
%

if exist('hi','var') && isvalid(hi), delete(hi);end
idx = randperm(size(X,1));
hi  = ml_plot_images(X(idx(1:64),:),[8 8]);

%% Plot Images as data
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

%% Plot data
plot_options                = [];

plot_options.is_eig         = false;
plot_options.labels         = labels;
plot_options.class_names    = class_names; 
plot_options.title          = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X(:,1:3),plot_options);

%% Finding the right K
%
%   As you have seen in the scatter plot, it is not straightforward to make
%   out the different clusters. Well we would hopefully expect the number
%   of clusters to match the number of classes. We will not use kPCA to try
%   and determine this.
%

%   As you have seen the Gaussian cluster dataset, the results of kPCA
%   will depend on the chosen parameter of the kernel function. We will try
%   with the gaussian radial basis kernel (fee free to try other kernels).
%
%

optionts                  = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 20;
options.kernel            = 'gauss';
options.kpar              = 2;          % if poly this is the offset
%options.kpar(2)           = 0;         % if poly this is the degree

%kpars                     = [0.5,1,1.5,2,2.5,3,3.5,10];  % image-data
%kpars                      = [1,2,3,4,5,10,20];           % cancer
kpars                     = [0.5,1,1.5,2,2.5,3,5];         % republican-vote


[eigenvalues]             = ml_kernel_grid_search(X,options,kpars);

% Lets plot the eigenvalues

if exist('handle_eig','var') && isvalid(handle_eig), delete(handle_eig);end
handle_eig = ml_plot_kpca_eigenvalues(eigenvalues,kpars);

%% Re-run KPCA with the chosen parameter

%options.kpar              = 1.5;   
options.kpar              = 1.8;   
[proj_X, mapping]         = ml_projection(X,options);


if exist('h2','var') && isvalid(h2), delete(h2);end
plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data kPCA';

h2                      = ml_plot_data(proj_X(:,[1,2,3]),plot_options);


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









