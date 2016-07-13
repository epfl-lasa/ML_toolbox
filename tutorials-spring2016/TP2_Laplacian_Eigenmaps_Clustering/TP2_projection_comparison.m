%%  Projection Techniques for Clustering. We use matlab data.
%
%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));

clear all;
close all;



%% Swiss Roll dataset
load('ml_brokenswiss_example.mat')

% Plot data
plot_options                = [];

plot_options.is_eig         = false;
plot_options.labels         = labels;
plot_options.title          = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X,plot_options);

%% Digit dataset 1)
[X,labels] = ml_load_digits_64('data/digits.csv',[0 1 2 3 4 5]);

% Plot images
%   Visualise the images
%

if exist('hi','var') && isvalid(hi), delete(hi);end
idx = randperm(size(X,1));
hi  = ml_plot_images(-(X(idx(1:64),:)-1),[8 8]);

% Plot Images as data

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

%% Do PCA to have a comparison

options = [];
options.method_name       = 'PCA';
options.nbDimensions      = 2;

[proj_PCA_X, ~]         = ml_projection(X,options);

if exist('h2','var') && isvalid(h2), delete(h2);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data PCA';

h2 = ml_plot_data(proj_PCA_X(:,1:2),plot_options);



%% Do kPCA

options = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 2;
options.kernel            = 'gauss';
options.kpar              = 5;

[proj_kPCA_X, mappingKPCA] = ml_projection(X,options);

if exist('h3','var') && isvalid(h3), delete(h3);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data kPCA';

h3 = ml_plot_data(proj_kPCA_X(:,1:2),plot_options);



%% Perform Laplacian Eigenmaps

options = [];
options.method_name       = 'Laplacian';
options.nbDimensions      = 2;
options.neighbors         = 10;
options.sigma             = 0.3;

try
    [proj_LAP_X, mappingLAP]  = ml_projection(X,options);
catch
    err('Please enter a higher number of neighbors')
end

if exist('h4','var') && isvalid(h4), delete(h4);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data Laplacian Eigenmaps';

try
    h4 = ml_plot_data(proj_LAP_X(:,1:2),plot_options);
catch
    err('Please enter a higher number of neighbors')
end


%% Perform Isomap

options = [];
options.method_name       = 'Isomap';
options.nbDimensions      = 2;
options.neighbors         = 13;

try
    [proj_ISO_X, mappingISO]  = ml_projection(X,options);
catch
    err('Please enter a higher number of neighbors')
end

if exist('h5','var') && isvalid(h5), delete(h5);end

plot_options            = [];
plot_options.is_eig     = true;
plot_options.labels     = labels;
plot_options.title      = 'Projected data Isomap Eigenmaps';

try
    h5 = ml_plot_data(proj_ISO_X(:,1:2),plot_options);
catch
    err('Please enter a higher number of neighbors')
end

%% Perform kmeans clustering on the original data
options = [];
options.method_name                 = 'kmeans';
options.K                           = 2;

[result] = ml_clustering(X,options,'Distance','sqeuclidean');

if exist('h6','var') && isvalid(h6), delete(h6);end

h6 = ml_plot_class_boundary(X,result);



%% Perform kmeans clustering on the projected data with kPCA
options = [];
options.method_name                 = 'kmeans';
options.K                           = 2;

[resultkPCA] = ml_clustering(proj_kPCA_X,options,'Distance','sqeuclidean');

if exist('h6','var') && isvalid(h6), delete(h6);end

h6 = ml_plot_class_boundary(proj_kPCA_X,resultkPCA);



%% Perform kmeans clustering on the projected data with Laplacian
options = [];
options.method_name                 = 'kmeans';
options.K                           = 2;

[resultLAP] = ml_clustering(proj_LAP_X,options,'Start','plus','Distance','sqeuclidean');

if exist('h7','var') && isvalid(h7), delete(h7);end

h7 = ml_plot_class_boundary(proj_LAP_X,resultLAP);



%% Perform kmeans clustering on the projected data with Isomap
options = [];
options.method_name                 = 'kmeans';
options.K                           = 2;

[resultISO] = ml_clustering(proj_ISO_X,options,'Start','plus','Distance','sqeuclidean');

if exist('h8','var') && isvalid(h8), delete(h8);end

h8 = ml_plot_class_boundary(proj_ISO_X,resultISO);



%% Compute F-measure for clustering after different projections
if exist('h9','var') && isvalid(h9), delete(h9);end

repeat = 15;

options = [];
options.method_name                 = 'kmeans';
options.K   = 2;

F = zeros(repeat,1);
FPCA = zeros(repeat,1);
FkPCA = zeros(repeat,1);
FLap = zeros(repeat,1);
FIso = zeros(repeat,1);

for i = 1:repeat
    [result] = ml_clustering(X,options,'Distance','sqeuclidean');
    [resultPCA] = ml_clustering(proj_PCA_X,options,'Distance','sqeuclidean');
    [resultkPCA] = ml_clustering(proj_kPCA_X,options,'Distance','sqeuclidean');
    [resultLAP] = ml_clustering(proj_LAP_X,options,'Start','plus','Distance','sqeuclidean');
    [resultISO] = ml_clustering(proj_ISO_X,options,'Start','plus','Distance','sqeuclidean');
    F(i) = ml_Fmeasure(result.labels,labels);
    FPCA(i) = ml_Fmeasure(resultPCA.labels,labels);
    FkPCA(i) = ml_Fmeasure(resultkPCA.labels,labels);
    FLap(i) = ml_Fmeasure(resultLAP.labels,labels);
    FIso(i) = ml_Fmeasure(resultISO.labels,labels);
end

means = [mean(F) mean(FPCA) mean(FkPCA) mean(FLap) mean(FIso)];
stds = [std(F) std(FPCA) std(FkPCA) std(FLap) std(FIso)];

h9 = errorbar(means,stds,'or','LineWidth',2,'MarkerSize',6);
title('F-measure for different projections')
ylabel('FMeasure')
err = gca;
set(err,'FontSize',14.0,'XTick',[1 2 3 4 5],'XTickLabel',{'Original', 'PCA' , 'KPCA' , 'Laplacian' , 'Isomap'})


%% Compute F-measure for clustering for different number of clusters
if exist('hk','var') && isvalid(hk), delete(hk);end
clear -vars means stds

repeat = 15;

KRange = 1:10;

options = [];
options.method_name                 = 'kmeans';

for k = 1:length(KRange)

    options.K   = KRange(k);

    F = zeros(repeat,1);
    FPCA = zeros(repeat,1);
    FkPCA = zeros(repeat,1);
    FLap = zeros(repeat,1);
    FIso = zeros(repeat,1);

    for i = 1:repeat
        [result] = ml_clustering(X,options,'Distance','sqeuclidean');
        [resultPCA] = ml_clustering(proj_PCA_X,options,'Distance','sqeuclidean');
        [resultkPCA] = ml_clustering(proj_kPCA_X,options,'Distance','sqeuclidean');
        [resultLAP] = ml_clustering(proj_LAP_X,options,'Start','plus','Distance','sqeuclidean');
        [resultISO] = ml_clustering(proj_ISO_X,options,'Start','plus','Distance','sqeuclidean');
        F(i) = ml_Fmeasure(result.labels,labels);
        FPCA(i) = ml_Fmeasure(resultPCA.labels,labels);
        FkPCA(i) = ml_Fmeasure(resultkPCA.labels,labels);
        FLap(i) = ml_Fmeasure(resultLAP.labels,labels);
        FIso(i) = ml_Fmeasure(resultISO.labels,labels);
    end

    means(k,:) = [mean(F) mean(FPCA) mean(FkPCA) mean(FLap) mean(FIso)];
    stds(k,:) = [std(F) std(FPCA) std(FkPCA) std(FLap) std(FIso)];

end

hk = figure;
hold on;
for k = 1:5
    plot(means(:,k),'LineWidth',2);
end
title('F-measure for different projections')
ylabel('FMeasure')
legend({'Original', 'PCA' , 'KPCA' , 'Laplacian' , 'Isomap'})


%% Compute F-measure for clustering with different variances for KPCA
if exist('h10','var') && isvalid(h10), delete(h10);end

repeat = 15;

Range = [0.05 0.1 0.5 1 5 10];

means = zeros(length(Range),1);
stds = zeros(length(Range),1);

for k = 1:length(Range)
    options = [];
    options.method_name       = 'KPCA';
    options.nbDimensions      = 2;
    options.kernel            = 'gauss';
    options.kpar = Range(k);
    
    [proj_kPCA_X, ~]         = ml_projection(X,options);

    options = [];
    options.method_name                 = 'kmeans';
    options.K   = 2;

    FkPCA = zeros(repeat,1);

    for i = 1:repeat
        [resultkPCA] = ml_clustering(proj_kPCA_X,options,'Distance','sqeuclidean');
        FkPCA(i) = ml_Fmeasure(resultkPCA.labels,labels);

    end

    means(k) = mean(FkPCA);
    stds(k) = std(FkPCA);
end

h10 = errorbar(means,stds,'r','LineWidth',2,'MarkerSize',6);
title('F-measure for different width for KPCA')
xlabel('Variance of the gaussian Kernel')
ylabel('FMeasure')
err = gca;
set(err,'FontSize',14.0,'XTick',1:length(Range),'XTickLabel',num2str(Range'))


%% Compute F-measure for clustering with different neighbors for Laplacian Eigenmaps
if exist('h11','var') && isvalid(h11), delete(h11);end

repeat = 15;

neighborsRange = [5 10 15 20 25 40];

means = zeros(length(neighborsRange),1);
stds = zeros(length(neighborsRange),1);

for k = 1:length(neighborsRange)
    options = [];
    options.method_name       = 'Laplacian';
    options.nbDimensions      = 2;
    options.neighbors         = neighborsRange(k);
    options.sigma             = 0.3;
    try
        [proj_LAP_X, ~]         = ml_projection(X,options);
    catch
        err('Please enter a higher number of neighbors as first number of your range of search')
    end
        
    options = [];
    options.method_name                 = 'kmeans';
    options.K   = 2;

    FLap = zeros(repeat,1);

    for i = 1:repeat
        [resultLAP] = ml_clustering(proj_LAP_X,options,'Start','plus','Distance','sqeuclidean');
        FLap(i) = ml_Fmeasure(resultLAP.labels,labels);
    end

    means(k) = mean(FLap);
    stds(k) = std(FLap);
end

h11 = errorbar(means,stds,'r','LineWidth',2,'MarkerSize',6);
title('F-measure for different neighbors for Laplacian')
xlabel('Number of neighbors')
ylabel('FMeasure')
err = gca;
set(err,'FontSize',14.0,'XTick',1:length(neighborsRange),'XTickLabel',num2str(neighborsRange'))


%% Compute F-measure for clustering with different widths for Laplacian Eigenmaps
if exist('h11','var') && isvalid(h11), delete(h11);end

repeat = 15;

sigmaRange = [0.1 0.3 0.5 1 2 4];

means = zeros(length(sigmaRange),1);
stds = zeros(length(sigmaRange),1);

for k = 1:length(neighborsRange)
    options = [];
    options.method_name       = 'Laplacian';
    options.nbDimensions      = 6;
    options.neighbors         = 15;
    options.sigma             = sigmaRange(k);
    try
        [proj_LAP_X, ~]         = ml_projection(X,options);
    catch
        err('Please enter a higher number of neighbors')
    end

    options = [];
    options.method_name                 = 'kmeans';
    options.K   = 2;

    FLap = zeros(repeat,1);

    for i = 1:repeat
        [resultLAP] = ml_clustering(proj_LAP_X,options,'Start','plus','Distance','sqeuclidean');
        FLap(i) = ml_Fmeasure(resultLAP.labels,labels);
    end

    means(k) = mean(FLap);
    stds(k) = std(FLap);
end

h11 = errorbar(means,stds,'r','LineWidth',2,'MarkerSize',6);
title('F-measure for different neighbors for Laplacian')
xlabel('Sigma')
ylabel('FMeasure')
err = gca;
set(err,'FontSize',14.0,'XTick',1:length(sigmaRange),'XTickLabel',num2str(sigmaRange'))



%% Compute F-measure for clustering with different neighbors for Isomap
if exist('h12','var') && isvalid(h12), delete(h12);end

repeat = 15;

neighborsRange = [13 15 20 30];

means = zeros(length(neighborsRange),1);
stds = zeros(length(neighborsRange),1);

for k = 1:length(neighborsRange)
    options = [];
    options.nbDimensions      = 2;
    options.neighbors         = neighborsRange(k);    
    options.method_name       = 'Isomap';

    try
        [proj_ISO_X, ~]         = ml_projection(X,options);
    catch
        err('Please enter a higher number of neighbors as first number of your range of search')
    end
    
    options = [];
    options.method_name                 = 'kmeans';
    options.K   = 2;

    FIso = zeros(repeat,1);

    for i = 1:repeat
        [resultISO] = ml_clustering(proj_ISO_X,options,'Start','plus','Distance','sqeuclidean');
        FIso(i) = ml_Fmeasure(resultISO.labels,labels);
    end

    means(k) = mean(FIso);
    stds(k) = std(FIso);
end

h12 = errorbar(means,stds,'r','LineWidth',2,'MarkerSize',6);
title('F-measure for different neighbors for Isomap')
xlabel('Number of neighbors')
ylabel('FMeasure')
err = gca;
set(err,'FontSize',14.0,'XTick',1:length(neighborsRange),'XTickLabel',num2str(neighborsRange'))
