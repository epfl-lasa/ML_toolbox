%% Example of plotting a 2D Gaussian Mixture Model
clear all;
%% 1) Generate a random GMM


rot_mat = @(theta) [cos(theta), -sin(theta);sin(theta) cos(theta)];

Priors       = [0.3,0.3,0.3];
Priors       = Priors./sum(Priors);

Mu(:,1)      = [-2 0]';
Mu(:,2)      = [2 1]';
Mu(:,3)      = [0 -2]';
Sigma        = [];
Sigma(:,:,1) = rot_mat(pi/5)  * [3,0;0,0.1];
Sigma(:,:,2) = rot_mat(-pi/5) * [3,0;0,0.1];
Sigma(:,:,3) = rot_mat(pi/10) * [3,0;0,0.1];


%% Plot the Contours of the GMM


close all;
figure; 
hold on; grid on;
plot_gmm_contour(gca,Priors,Mu,Sigma,[0 0 1]);
box on;