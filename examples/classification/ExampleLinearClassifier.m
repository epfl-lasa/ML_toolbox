%% Simple example of a Linear classifier 
clear all; close all;
%% Generate some data

num_samples     = 500;
num_classes     = 2;
dim             = 2;
[X,labels,gmm]  = ml_clusters_data(num_samples,dim,num_classes);
labels          = ml_2binary(labels);

%%

num_samples     = 500;
dim_samples     = 2;
num_classes     = 2;
[X,labels]      = ml_circles_data(num_samples,dim_samples,num_classes);
labels          = ml_2binary(labels);

%% Plot the data

plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% Learn Weighted linear classifier

w               = ones(length(labels),1) ./ length(labels);

%%
w(X(:,1) > 0)  = 0;
w              = w./sum(w);


%%
[B_hat,mapping] = train_linear_classifier(X,labels,w);

% Make anonymous predictor function

f = @(X)predictor_linear_classifier(X,B_hat,mapping);

% Plot classifier

c_options       = [];
c_options.title = 'Linear classifier';

if exist('hc2','var') && isvalid(hc2), delete(hc2);end
hc2 = ml_plot_classifier(f,X,labels,c_options);

