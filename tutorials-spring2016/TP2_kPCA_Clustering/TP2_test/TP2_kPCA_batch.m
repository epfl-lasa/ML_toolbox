%% Part One of Assignment II  [Advanced Machine Learning]
%% Clustering. Make sure you have added the path of ML_toolbox to your directory.
%
%
%% ----------> run from ML_toolbox directory: >> addpath(genpath('./'));

clear all;
close all;

%% You have to figure out the number of clusters present in the datasets
%% by using kernel-PCA
%% Generate Circle Data

num_samples = 1000;
dim_samples = 2;
num_classes = 2;

[X,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);

%% Plot original data

plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% Do Grid search on the parameters of kernel PCA

optionts = [];
options.method_name       = 'KPCA';
options.nbDimensions      = 10;
options.kernel            = 'gauss';
options.kpar              = 10;     % if poly this is the offset

kpars = [0.001,0.01, 0.05,0.1,0.2, 0.5,1,2,5,10,15,20]; 



[ eigenvalues ] = ml_kernel_grid_search(X,options,kpars);

%% Plot Eigenvalues (figure 1)

if exist('h4','var') && isvalid(h4), delete(h4);end
h4 = figure; 
hold on;

[num_para,num_eigval] = size(eigenvalues);
colors                = flipud(jet(num_para));
idx_plot              = [1,2,3,4,5,7,8,9];

for i=1:length(idx_plot)
   plot(eigenvalues(idx_plot(i),:),'-o','Color',colors(idx_plot(i),:),'MarkerFaceColor',colors(idx_plot(i),:));
end
box on; grid on;
set(gca,'FontSize',14);
xlabel('Eigenvectors');
ylabel('Eigenvalues');
legend(strread(num2str(kpars),'%s'));
xlim([1,10]);

%% Plot Eigenvalues (figure 2)
if exist('h3','var') && isvalid(h3), delete(h3);end
h3 = figure; 
hold on;

[num_para,num_eigval] = size(eigenvalues);
colors                = flipud(jet(num_para));

for i=1:num_eigval
    eigen_values = eigenvalues(idx_plot,i)';
    plot(eigen_values,'-s','Color',colors(i,:));
end

box on; grid on;
set(gca,'FontSize',14);
set(gca,'xtick',1:length(idx_plot));
set(gca,'xticklabel',strread(num2str(kpars(idx_plot))));
ax = gca;
ax.XTickLabelRotation=45;
xlim([1,length(idx_plot)]);
xlabel('Variance (parameter)');
ylabel('Eigenvalues');


