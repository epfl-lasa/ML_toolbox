%% Example of clustering with AIC and BIC computed for K-means with RSS
clear all; close all;

%% Generate Perfect circle

nb_samples  = 100;
phi         = linspace(0,2 * pi,nb_samples);
r           = 10;
X           = [r .* cos(phi(:)), r .* sin(phi(:))];

%% Plot circle points

plot_options                = [];
plot_options.title          = 'Circle';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X,plot_options);
axis square;

%% Generate Random Clusters from GMM

clear all; close all;
num_samples         = 400;
num_classes         = 4;
dim                 = 2;
[X,labels,gmm]      = ml_clusters_data(num_samples,dim,num_classes);
options.title       = 'Random Gaussian';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,options);
axis equal;

%% K-means

cluster_options             = [];
cluster_options.method_name = 'kmeans';
cluster_options.K           = 2;

result1                     = ml_clustering(X,cluster_options,'Start','plus','Distance','sqeuclidean','MaxIter',500);

result1.lambda              = 2;
[rss,aic,bic]               = ml_clustering_eval(X,result1);

% Plot decision boundary
if exist('hd','var') && isvalid(hd), delete(hd);end
hd = ml_plot_class_boundary(X,result1);
%% Search for optimal \lambda value in AIC(RSS)
clc;
cluster_options             = [];
cluster_options.method_name = 'kmeans';

% Compute Maximum RSS values (when K=1,\alpha)
[N,D]       = size(X);
alpha       = N/4;
repeats     = 1;
K           = 1:alpha;
[mus, stds] = ml_clustering_optimise(X,K,repeats,cluster_options,'Start','plus','Distance','sqeuclidean','MaxIter',500);

% Compute lower/upper bounds of \lambda values according to limits derived
% in slide 9,12,13 of TP2-Metrics-Recap
rss_k1         = mus(1,1);
rss_k2         = mus(1,alpha);
upper_lambda   = (rss_k1 - rss_k2) / (alpha*D);
lower_lambda   = (rss_k1) / (D*N);
lambda_range   = [floor(lower_lambda):1:ceil(upper_lambda)+1];

% Plot AIC(RSS) with a constrained range of lambda's
clc;
if exist('h_aic','var')     && isvalid(h_aic),     delete(h_aic);    end
h_aic = figure;hold on;
leg_names = [];
aic_mins = [];
for l=1:length(lambda_range)
    cluster_options.lambda    = lambda_range(l); %Magic number
    repeats                   = 1;
    Ks                        = 1:N;
    [mus, stds]               = ml_clustering_optimise(X,Ks,repeats,cluster_options,'Start','plus','Distance','sqeuclidean','MaxIter',500);        
    plot(mus(2,:),'-');
    hold on;
    [min_aic, min_k] = min(mus(2,:));
    leg_names = [leg_names; {strcat('\lambda= ',num2str(lambda_range(l)))}];
    aic_mins = [aic_mins; [min_aic, min_k]];
end
legend(leg_names);
grid on;
box on;
xlabel('K');
title('AIC(RSS) for K-means')

%% Plot BIC(RSS)

if exist('h_bic','var')     && isvalid(h_bic),     delete(h_bic);    end
h_bic = figure;hold on;
plot(mus(3,:),'-');
grid on;
box on;
xlabel('K');
title('BIC(RSS) for K-means')
