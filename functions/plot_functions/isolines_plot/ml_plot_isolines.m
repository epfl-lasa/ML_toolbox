function [handle_iso,handle_eig] = ml_plot_isolines(plot_options,kernel_data)
%ML_PLOT_ISOLINES: Plot the isolines of a kernel method.
%
%   input ---------------------------------------------------------------
%
%       o plot_options   : struct
%
%           plot_options.xtrain_dim   : (1 x 2) , dimensions of the orignal
%                                                   data to consider when doing
%                                                   the projection.
%
%           plot_options.eigen_idx   : vector of indicies of the eigenvectors to plot.
%                                       This value cannot be bigger than L
%
%
%       o kernel_data    : struct 
%
%           kernel_data.kernel      = ['gauss','poly','linear']
%           kernel_data.kpar(1)     = sigm or
%           kernel_data.kpar(1)     = p
%           kernel_data.kpar(2)     = c
%           kernel_data.xtrain      = (M x D) : training data points (original
%                                               data).
%           kernel_data.alphas      = (M x L) : eigenvectors
%               
%   output ----------------------------------------------------------------
%
%       o v           : value when projected onto the eigenvetors alpha
%
%   comment ---------------------------------------------------------------
%
%       Each data point of xtest is projected onto every alpha eigenvector.
%
%
%

%% Extract plot options from structure

xtrain_dim          = plot_options.xtrain_dim;      % dimensions of the original data to consdier for the projection
eigen_idx           = plot_options.eigen_idx;       % index of the if the eigenvectors to plot
labels              = [];
b_plot_data         = true;
b_plot_colorbar     = false;
b_plot_eigenvalues  = false;

if isfield(plot_options,'labels'),              labels              = plot_options.labels;              end
if isfield(plot_options,'b_plot_data'),         b_plot_data         = plot_options.b_plot_data;         end
if isfield(plot_options,'b_plot_colorbar'),     b_plot_colorbar     = plot_options.b_plot_colorbar;     end
if isfield(plot_options,'b_plot_eigenvalues'),  b_plot_eigenvalues  = plot_options.b_plot_eigenvalues;  end


%% Extract kernel options

alphas      = kernel_data.alphas;
kernel      = kernel_data.kernel;
kpar        = kernel_data.kpar;
%invsqrtL    = kernel_data.invsqrtL;

%% Get Projection maps

nbSamples   = 50;
% Get the limits of dim1 and dim2
xtrain      = kernel_data.xtrain(:,xtrain_dim);

xs          = linspace(min(xtrain(:,1)),max(xtrain(:,1)),nbSamples);
ys          = linspace(min(xtrain(:,2)),max(xtrain(:,2)),nbSamples);
[Xs,Ys]     = meshgrid(xs,ys);
xtest       = [Xs(:),Ys(:)];

num_eigs    = length(eigen_idx);

proj_v = cell(num_eigs,1);
for k=1:num_eigs
    proj_v{k}  = ml_get_isolines(xtest,xtrain,alphas(:,eigen_idx(k)),kernel,kpar);
end

%% Create label colors if the data is labeled

if ~isempty(labels)
    colors = hsv(length(unique(labels)));
end

%% Plot

handle_eig = [];

num_contour = 20;

handle_iso  = figure;
if num_eigs == 1
    
    contour(Xs,Ys,reshape(proj_v{1},size(Xs)),num_contour);
    
    if b_plot_data == true
        hold on;
        if isempty(labels)
            scatter(kernel_data.xtrain(:,xtrain_dim(1)),kernel_data.xtrain(:,xtrain_dim(2)),10,'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0]);
        else
           hs = scatter(kernel_data.xtrain(:,xtrain_dim(1)),kernel_data.xtrain(:,xtrain_dim(2)),10,colors(labels,:),'filled','MarkerEdgeColor',[0 0 0]);
        end            
    end
    
    eig_val = kernel_data.eigen_values(eigen_idx(1));
    eig_val = round(eig_val * 100) / 100;
    
    title(['Eigen(' num2str(eigen_idx(1)) ')  Eig-val: ' num2str(eig_val) ],'FontSize',14);
    set(gca,'FontSize',14);
    xlabel('x','FontSize',14);
    ylabel('y','FontSize',14);
    colorbar;
    
else
    
    if num_eigs     == 2
        m = 1; n = 2;
    elseif num_eigs == 3
        m = 1; n = 3;
    elseif num_eigs == 4
        m = 2; n = 2;
    elseif num_eigs == 5
        m = 2; n = 3; 
    elseif num_eigs == 6
        m = 2; n = 3;
    end
    
    set(gca, 'LooseInset', get(gca,'TightInset'))
    for p=1:num_eigs
       subaxis(m,n,p,'Spacing', 0.05, 'Padding', 0, 'Margin', 0.05);
       
       contour(Xs,Ys,reshape(proj_v{p},size(Xs)),num_contour);
        if b_plot_data == true
            hold on;
            if isempty(labels)
                scatter(kernel_data.xtrain(:,xtrain_dim(1)),kernel_data.xtrain(:,xtrain_dim(2)),10,'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0]);
            else
                scatter(kernel_data.xtrain(:,xtrain_dim(1)),kernel_data.xtrain(:,xtrain_dim(2)),10,colors(labels,:),'filled','MarkerEdgeColor',[0 0 0]);
            end            
        end
       eig_val = kernel_data.eigen_values(eigen_idx(p));
       eig_val = round(eig_val * 100) / 100;

       title(['Eigen(' num2str(eigen_idx(p)) ') Eig-val: ' num2str(eig_val) ],'FontSize',8);
       xlabel('x','FontSize',8);
       ylabel('y','FontSize',8); 
       set(gca,'FontSize',8);
       if b_plot_colorbar == true, colorbar; end
       axis square;

    end
    
end

%% Plot figure of the eigenvalues

if b_plot_eigenvalues
    
handle_eig = figure;

xs = 1:length(kernel_data.eigen_values);
plot(xs,kernel_data.eigen_values,'-s');
set(gca,'Xtick',xs);
xlabel('eigenvectors');
ylabel('eigenvalues');
  
    
end


