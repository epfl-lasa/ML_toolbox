%% Load example Data
clear all;
load('/home/guillaume/MatlabWorkSpace/Gaussian/MergeGMMs/Data/X1.mat');
load('/home/guillaume/MatlabWorkSpace/Gaussian/MergeGMMs/Data/X2.mat');
%% Plot data

close all;
figure; grid on; box on; hold on;
plot(X1(:,1),X1(:,2),'-b');
plot(X2(:,1),X2(:,2),'-r');
legend('X1','X2');
axis equal;
title('training data for GMMs');


%% GMM model for X1
options = statset('Display','final','MaxIter',1000);

GMModel = fitgmdist(X1,80,'Options',options,'CovarianceType','full','RegularizationValue',1e-03,'Replicates',5,'Start','plus');

gmm_x1.Priors = GMModel.ComponentProportion;
gmm_x1.Mu     = GMModel.mu';
gmm_x1.Sigma  = GMModel.Sigma;


GMModel       = fitgmdist(X2,80,'Options',options,'CovarianceType','full','RegularizationValue',1e-03,'Replicates',5,'Start','plus');
gmm_x2.Priors = GMModel.ComponentProportion;
gmm_x2.Mu     = GMModel.mu';
gmm_x2.Sigma  = GMModel.Sigma;


%% Plot Two orignial GMM

close all;
figure; grid on; box on; hold on;
plot_gmm_contour(gca,gmm_x1.Priors,gmm_x1.Mu,gmm_x1.Sigma,[0 0 1],3);
plot_gmm_contour(gca,gmm_x2.Priors,gmm_x2.Mu,gmm_x2.Sigma,[1 0 0],3);
title('GMM (1) & (2)');
axis equal;

%% Merge GMM (1) & (2)
options     = statset('Display','off','MaxIter',1000);
[gmm_x3] = merge_gmms(gmm_x1,X1,gmm_x2,X2,0.1,options);



%% Plot merged GMM

figure; grid on; box on; hold on;
plot_gmm_contour(gca,gmm_x3.Priors,gmm_x3.Mu,gmm_x3.Sigma,[0 0.8 0],3);
title('GMM (3)');
axis equal;



%% Learn GMM

options = statset('Display','final','MaxIter',1000);
K       = 100;
BIC     = zeros(K,1);
AIC     = zeros(K,1);

tic
parfor k = 1:K
    disp(['k(' num2str(k) ')']);
    GMModel = fitgmdist(X2,k,'Options',options,'CovarianceType','full','RegularizationValue',1e-03,'Replicates',1,'Start','plus');
    BIC(k)  = GMModel.BIC;
    AIC(k)  = GMModel.AIC;
end
toc

%%

figure; hold on;
plot(BIC,'-r');
plot(AIC,'-b');
legend('BIC','AIC');
xlabel('k');
title(' AIC & BIC vs K');


