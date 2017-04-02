function [handle]  = ml_plot_svm_boundary( data, labels, model, svm_options, varargin)
% ML_PLOT_SVM_BOUNDARY plots the training data
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

% Check Labels
labels(find(labels==0)) = -1;

% Create Figure
handle = figure('Color',[1 1 1]); 
hold on

% Get Accuracy of Current Model on Data 
[~, predict_accuracy, ~] = svm_predict(data, labels, model);

% Make classification predictions over a grid of values
xplot = linspace(min(data(:,1)), max(data(:,1)), 100)';
yplot = linspace(min(data(:,2)), max(data(:,2)), 100)';
[X, Y] = meshgrid(xplot, yplot);
vals = zeros(size(X));

for i = 1:size(X, 2)
   x = [X(:,i),Y(:,i)];
   % Need to use evalc here to suppress LIBSVM accuracy printouts
   [T,predicted_labels, accuracy, decision_values] = evalc('svmpredict(ones(size(x(:,1))), x, model)');
   clear T;
   vals(:,i) = decision_values;
end

% Plot the SVM Contours
colormap hot
if (size(varargin, 2) == 1) && strcmp(varargin{1}, 'draw')
    contourf(X,Y, vals, 50, 'LineStyle', 'none');
    legend_names = {'Decision Values f(x)','f(x)=0', 'f(x)= +1','f(x)=-1','Class 1','Class -1'};
    colorbar
elseif (size(varargin, 2) == 1) && strcmp(varargin{1}, 'surf')
    surf(X,Y, vals); shading interp;
    legend_names = {'Decision Values f(x)','f(x)=0', 'f(x)= +1','f(x)=-1','Class 1','Class -1'};
    colorbar
else
    legend_names = {'f(x)=0', 'f(x)= +1','f(x)=-1','Class 1','Class -1'};        
end

% Plot the SVM Decision Boundaries
contour(X,Y, vals, [0 0], 'LineWidth', 2, 'Color', 'k');

contour(X,Y, vals, [1 1], 'LineWidth', 2, 'Color', 'r');
% contour(X,Y, vals, [2 2], 'LineWidth', 0.5, 'Color', 'r');
contour(X,Y, vals, [-1 -1], 'LineWidth', 2, 'Color', 'g');
% contour(X,Y, vals, [-2 -2], 'LineWidth', 0.5, 'Color', 'g');


% Plot the training data on top of the boundary
pos = find(labels == 1);
neg = find(labels == -1);
plot(data(pos,1), data(pos,2), 'ko', 'MarkerFaceColor', 'r'); hold on;
plot(data(neg,1), data(neg,2), 'ko', 'MarkerFaceColor', 'g'); hold on;

% Extract some learnt parameters and options
SVs              = full(model.SVs);
svm_type         = svm_options.svm_type;
N_SVs            = sum(model.nSV);
accuracy         = predict_accuracy(1)/100;

% Check if Kernel Type Exists
if isfield(svm_options,'kernel_type')
    kernel_type = svm_options.kernel_type;
else
    kernel_type = 0;
end

% Plot Support Vectors
scatter(SVs(:,1),SVs(:,2),70,'o','MarkerEdgeColor', [1 1 1], 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5);
legend(legend_names,'Location','NorthWest');

switch svm_type
    case 0
            switch kernel_type
                case 0 
                    title(sprintf('C = %4.2f, \\sigma = %g, SV = %d, Acc = %3.3f', svm_options.C, svm_options.sigma, N_SVs, accuracy), 'Interpreter','tex','FontSize', 20, 'FontWeight', 'Normal', 'FontName', 'Times');        
                case 1
                    title(sprintf('C = %4.2f, degree = %d, coeff =%d, SV = %d, Acc = %3.3f', svm_options.C, svm_options.degree, svm_options.coeff, N_SVs, accuracy), 'Interpreter','LaTex','FontSize', 20);        
            end
    case 1         
            switch kernel_type
                case 0
                    title(sprintf('\\nu = %4.3f, \\sigma = %g, SV = %d, Acc = %3.3f', svm_options.nu, svm_options.sigma, N_SVs, accuracy), 'Interpreter','tex','FontSize', 20, 'FontWeight', 'Normal', 'FontName', 'Times');
                case 1
                    title(sprintf('\\nu = %4.3f, degree = %d, coeff =%d, SV = %d, Acc = %1.3f', svm_options.nu, svm_options.degree, svm_options.coeff, N_SVs, accuracy),'Interpreter','tex','FontSize', 20, 'FontWeight', 'Normal', 'FontName', 'Times');
            end

end

axis tight
grid on
box on

end

