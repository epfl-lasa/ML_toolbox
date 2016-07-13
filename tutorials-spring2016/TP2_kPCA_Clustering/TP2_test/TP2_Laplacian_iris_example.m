%%  Laplacian Eigenmaps example to determine the number of clusters. We use matlab data.
%
%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));

clear all;
close all;

%% You have to figure out the number of clusters present in the datasets
%% by using Laplacian Eigenmap

%% Plot original data

load fisheriris
X = meas;
clear meas;

[labels,classes] = ml_string2label(species);

options.labels   = labels;
options.title    = 'Iris';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X(:,1:3),options);

%% Do Laplacian EigenMaps

options = [];
options.method_name       = 'Laplacian';
options.nbDimensions      = 4;
options.neighbors         = 'adaptative';

[proj_X, mapping]         = ml_projection(X,options);

%% Plot result of Laplacian Eigenmaps

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Iris projected Laplacian Eigenmaps';

h2 = ml_plot_data(proj_X(:,1:2),plot_options);

%% Plot figure of the eigenvalues
    
handle_eig = figure;

xs = 1:length(mapping.val);
plot(xs,sort(mapping.val,'descend'),'-s');
set(gca,'Xtick',xs);
xlabel('eigenvectors');
ylabel('eigenvalues');
  
    
