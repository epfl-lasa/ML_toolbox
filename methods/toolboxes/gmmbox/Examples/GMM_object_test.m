%% Plot GMM contours with numbers at there there centre
clear all;
%%

K       = 4;
Priors  = [0.4 0.1 0.25 0.25];
Mu      = zeros(2,4);
Mu(:,1) = [0 0]';
Mu(:,2) = [2 2]';
Mu(:,3) = [-3 5]';
Mu(:,4) = [0 -4];
Sigma = repmat(eye(2,2),[1 1 4]);

%% Use the GMM class

clear gmm;
gmm = GMM(Priors,Mu,Sigma);
gmm.color = [1 0 0];

%% Graphics;

figure; hold on;
gmm.draw(gca());
grid on;
axis equal;

%% Test Sampling

X = gmm.sample(500);
plot(gca,X(:,1),X(:,2),'+b');