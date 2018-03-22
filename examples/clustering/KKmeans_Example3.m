%% Example of Kernel Kmeans clustering

%% 1a) Draw a 'Symmetric' Dataset around the origin
clear all; close all;
[X, labels] = ml_draw_data();
X = X'; labels = labels';
hold on; scatter(0,0,150,'k+', 'LineWidth',5)
axlim = axis;

%% 1b) Shift the dataset
origin_offset    = [-50 0]'; % Set the origin of the sampled data
X = bsxfun(@plus,X', origin_offset)';

% Plotting function
options.labels   = labels;
options.title    = 'Shifted Random Clusters';
if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = ml_plot_data(X,options);
hold on; scatter(0,0,150,'k+', 'LineWidth',5)
axis equal
axlim = axis;

%% 2) Apply Kernel K-Means on Dataset
cluster_options.method_name = 'kernel-kmeans';
cluster_options.K           = 2;
cluster_options.kernel      = 'poly'; % options: 'gauss' or 'poly'
cluster_options.kpar        = [0 2];  % 'gauss': kpar = sigma, 'poly': kpar = [offset degree]
[result_kkmeans]            = ml_clustering(X,cluster_options);

% Plot decision boundary
result_kkmeans.title      = 'Kernel K ($2$)-Means on Original Data';
result_kkmeans.plot_labels = {'$x_1$','$x_2$'};
result_kkmeans.axis_limits = axlim;
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

% if exist('h_isoline','var') && isvalid(h_isoline), delete(h_isoline);end
[h_isoline,h_eig] = ml_plot_isolines(iso_plot_options,kernel_data);
