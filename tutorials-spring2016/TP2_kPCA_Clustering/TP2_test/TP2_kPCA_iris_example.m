%%  kPCA example to determine the number of clusters. We use matlab data.
%
%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));

clear all;
close all;

%% You have to figure out the number of clusters present in the datasets
%% by using kernel-PCA
%% Generate Circle Data


%% Plot original data

load fisheriris
X = meas;
clear meas;

[labels,classes] = ml_string2label(species);

options.labels   = labels;
options.title    = 'Iris';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X(:,1:3),options);

%% Do Kernel PCA

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 10;
options.kernel            = 'gauss';
options.kpar              = 2;     % if poly this is the offset

[proj_X, mapping]         = ml_projection(X,options);

%% Plot result of Kernel PCA

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Iris projected kPCA';

h2 = ml_plot_data(proj_X(:,1:2),plot_options);

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

%%

iso_plot_options.eigen_idx          = [1 2 3 4];          % Eigenvectors to use.
iso_plot_options.b_plot_data        = false;          % Lets not plot the data this time.

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
if exist('h_eig','var')     && isvalid(h_eig),     delete(h_eig);    end

[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);


