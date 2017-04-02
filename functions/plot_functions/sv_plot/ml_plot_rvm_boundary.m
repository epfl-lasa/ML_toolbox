function [handle]  = ml_plot_rvm_boundary( data, labels, model, varargin)
% ML_PLOT_RVM_BOUNDARY plots the training data
%   and decision boundary, given a model produced by LIBSVM
%   input ----------------------------------------------------------------
%
%       o data      : (1 x 1), number of data points to generate.
%
%       o labels    : (1 x 1), dimension of the data. [2 or 3]
%
%       o model     : (1 x 1), number of classes.
%
%       o options   : struct
%
%       o varargin  : string, if 'draw' draw contours otherwise, don't
%
%%  Plot function
handle = figure('Color', [1 1 1]);
labels(find(labels==-1)) = 0;

% Parse model params
weights = model.weights;
kernel_ = model.kernel_;
width   = model.width;
bias    = model.bias;
RVs     = model.RVs;
acc     = model.predict_accuracy;
N_RVs   = model.N_RVs;

% Make classification predictions over a grid of values
xplot = linspace(min(data(:,1)), max(data(:,1)), 100)';
yplot = linspace(min(data(:,2)), max(data(:,2)), 100)';
[grid1, grid2] = meshgrid(xplot, yplot);
Xgrid = [grid1(:),grid2(:)];

% Evaluate RVM
PHI		= SB1_KernelFunction(Xgrid,RVs,kernel_,width);
y_grid  = PHI*weights + bias;

% apply sigmoid for probabilities (option)
p_grid	= 1./(1+exp(-y_grid));

% Plot the RVM Contours
colormap hot
if (size(varargin, 2) == 1) && strcmp(varargin{1}, 'draw')
    contourf(grid1,grid2, reshape(p_grid,size(grid1)), 50, 'LineStyle', 'none');
    legend_names = {'Decision values (p(x))', 'Class 1','Class 0', 'p=0.5', 'p=0.75', 'p=0.25'};
    colorbar
elseif (size(varargin, 2) == 1) && strcmp(varargin{1}, 'surf')
    surf(grid1,grid2, reshape(p_grid,size(grid1))); shading interp;
    legend_names = {'Decision Values f(x)','f(x)=0', 'f(x)= +1','f(x)=-1','Class 1','Class -1'};
    colorbar
else    
    legend_names = {'Class 1','Class 0', 'p=0.5', 'p=0.75', 'p=0.25'};
end
hold on;

% Plot the training data on top of the boundary
pos = find(labels == 1);
neg = find(labels == 0);
plot(data(pos,1), data(pos,2), 'ko', 'MarkerFaceColor', 'r'); hold on;
plot(data(neg,1), data(neg,2), 'ko', 'MarkerFaceColor', 'g'); hold on;

% Show decision boundaries p=0.5 (y=0) and illustrate p=0.75(y=1) and p=0.25(y=-1)
contour(grid1,grid2,reshape(y_grid,size(grid1)),[0.5 0.5],'-', 'LineWidth', 2,  'Color', 'k');
contour(grid1,grid2,reshape(y_grid,size(grid1)),[0.75 0.75],'-', 'LineWidth',0.5, 'Color', 'r');
contour(grid1,grid2,reshape(y_grid,size(grid1)),[0.25 0.25],'-', 'LineWidth',0.5, 'Color', 'g');

% Show relevance vectors       
scatter(RVs(:,1),RVs(:,2),70,'o','MarkerEdgeColor', [1 1 1], 'LineWidth', 2);       
legend(legend_names,'Location','NorthWest')
hold off
title(sprintf('RVM \\sigma = %g, RV = %d, Acc = %g', width, N_RVs, acc), 'Interpreter','tex','FontSize', 20, 'FontWeight', 'Normal');     

axis tight
grid on
box on

end
