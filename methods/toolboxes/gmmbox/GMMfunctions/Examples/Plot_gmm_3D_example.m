%% Example of plotting a 3D Gaussian Mixture Model
%% 1) Generate a random GMM
clear all;


Priors          = [0.5,0.5];
Mu(:,1)         = [0 0 0]';
Mu(:,2)         = [1 1 1]';
Sigma(:,:,1)    = eye(3,3) .* 0.05;
Sigma(:,:,2)    = eye(3,3) .* 0.01;

%%
gmm        = [];
gmm.Priors = Priors;
gmm.Mu     = Mu;
gmm.Sigma  = Sigma;

%% Plot 3D GMM

close all;
hf = figure; hold on;

%alpha   = rescale(gmm.Priors,min(gmm.Priors),max(gmm.Priors),0.1,0.8);
handles = plot3dGaussian(gmm.Priors, gmm.Mu, gmm.Sigma );


for i=1:size(handles,1)
    set(handles(i),'FaceLighting','phong','FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.9,'AmbientStrength',0.1,'EdgeColor','none');
end

camlight

set(gca, 'color', 'none');
grid on; box on; 

axis equal;
