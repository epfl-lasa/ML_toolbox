%% Example of Kernel Kmeans clustering
clear all; close all;
%% 1a) Generate a Dataset
%%%%%%%%%%%%%%%% How to set num_samples %%%%%%%%%%%%%%%%
% If num_samples = 100 is a scalar that will be taken as the total number of
% samples and each class will have an equal number of samples
% If num_samples = [100 200] is a vector, each value will be the number of
% sampler per class, the total number of sample sum(num_samples), note
% the vector must have the same length as the num_classes variable
num_samples     = [100 100];
num_classes     = 2;
dim             = 2;
[X,labels,gmm]  = ml_clusters_data(num_samples,dim,num_classes);

options.labels   = labels;
options.title    = 'Random Clusters';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal

%% 1b) OPTIONAL: Remove points from one of the classes
percentage = 99; % percentage of data to remove in one of the classes
[X, labels] = ml_generate_unbalance_2D(X,labels, percentage);
options.labels   = labels;
options.title    = 'New Random Clusters';
if exist('h2','var') && isvalid(h2), delete(h2);end
h1 = ml_plot_data(X,options);
axis equal

%% 2) Apply Kernel K-Means on Dataset
cluster_options.method_name = 'kernel-kmeans';
cluster_options.K           = 2;
cluster_options.kernel      = 'poly'; % options: 'gauss' or 'poly'
cluster_options.kpar        = [0 2];  % 'gauss': kpar = sigma, 'poly': kpar = [offset degree]
[result_kkmeans]                   = ml_clustering(X,cluster_options);

% Plot decision boundary
result_kkmeans.title      = 'Kernel K ($2$)-Means on Original Data';
result_kkmeans.plot_labels = {'$x_1$','$x_2$'};
% if exist('hd','var') && isvalid(hd), delete(hd);end
hd = ml_plot_class_boundary(X,result_kkmeans);

%% 3) Visualize Isolines of Eigenvectors
iso_plot_options                    = [];
iso_plot_options.xtrain_dim         = [1 2];     % Dimensions of the orignal data to consider when computing the gramm matrix (since we are doing 2D plots, original data might be of higher dimension)
iso_plot_options.eigen_idx          = [1:cluster_options.K];  % Eigenvectors to use.
iso_plot_options.b_plot_data        = true;      % Plot the training data on top of the isolines 
iso_plot_options.labels             = labels;    % Plotted data will be colored according to class label
iso_plot_options.b_plot_colorbar    = true;      % Plot the colorbar.
iso_plot_options.b_plot_surf        = false;     % Plot the isolines as (3d) surface 

% Construct Kernel Data
kernel_data                         = [];
kernel_data.alphas                  = result_kkmeans.eigens;
kernel_data.kernel                  = result_kkmeans.kernel;
kernel_data.kpar                    = result_kkmeans.kpar;
kernel_data.xtrain                  = X;
kernel_data.eigen_values            = result_kkmeans.lambda;

if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);
