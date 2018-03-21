function [ ] = ml_plot_gmm_pdf(X, Priors, Mu, Sigma )
%ML_PLOT_GMM_PDF Summary of this function goes here
%   Detailed explanation goes here

% Auxiliary Variables
K = length(Priors);

% Contour Function for GMM
xplot = linspace(min(X(1,:)), max(X(1,:)), 100)';
yplot = linspace(min(X(2,:)), max(X(2,:)), 100)';
[X_, Y_] = meshgrid(xplot, yplot);
vals = zeros(size(X_));

for i = 1:length(xplot)
    for j = 1:size(yplot)
        x = [xplot(i);yplot(j)];
        vals(j,i) =  ml_gmm_pdf(x, Priors, Mu, Sigma);
    end
end

% Plot the GMM PDF Contours
figure;
% contour(X_,Y_, vals, 50, 'LineStyle', 'none');hold on;
contour(X_,Y_, vals, 100);hold on;
% surf(X_,Y_, vals, 100);hold on;
colormap jet
colorbar
colors = hsv(K);
ml_plot_centroid(Mu',colors);hold on; 
options.class_names = {};
options.labels      = [];
options.points_size = 30;
options.colors      = [0 1 0.5];
options.plot_figure = true;
ml_plot_data(X',options);
title ('GMM-PDF Contours');

end

