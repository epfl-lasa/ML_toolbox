%% Optimise parameters of GMM through stochastic gradient descent
clear all;
%% Create ground truth GMM

Priors = ones(1,3)./3;
Mu     = [-8 2;0 0; 3 -3]';
Sigma(:,:,1) = [2 0.5; 0.5 1];
Sigma(:,:,2) = [1 0;0  5];
Sigma(:,:,3) = [4 0;0 1];

X = gmm_sample(500,Priors,Mu,Sigma);

%% Plot groud truth GMM & Data

close all;box on; grid on;
plot_gmm_contour(gca,Priors,Mu,Sigma,[0 0 1],1);
plot(X(1,:),X(2,:),'r+');

%% Initial parameters of GMM to train & Data

Priors_I = ones(1,3)./3;
Mu_I     = [ [-8;-2],[8;0],[0;8] ];
for i=1:3
    Sigma_I(:,:,i) = eye(2,2);
end


%% Plot Initial parameters & Data

close all;
figure; hold on;grid on; box on;
plot_gmm_contour(gca,Priors_I,Mu_I,Sigma_I,[0 0 1],1);
plot(X(1,:),X(2,:),'r+');
axis equal;

%% Gradient descent on Likelihood

W           = log_gmm_div_w(X,Priors_I,Mu_I,Sigma_I);
[dMu,dMu_n] = log_gmm_div_mu(X,W,Mu_I,Sigma_I);
dPriors     = log_gmm_div_prior(W,Priors);
dSigma      = log_gmm_div_sigma(X,W,Mu_I + dMu,Sigma_I);

dTSigma = dSigma;

%% Plot gradient direction of Mu

colors = [1 0 0; 
          0 1 0;
          0 0 1];
close all;
figure; hold on;grid on; box on;
plot_gmm_contour(gca,Priors_I,Mu_I,Sigma_I,colors,3);

plot_gmm_contour(gca,Priors_I,Mu_I,dTSigma,[0 0 0],3);


%      (3 x 3) 
color = (colors * W')';
scatter(X(1,:),X(2,:),10,color,'filled');


for k=1:3    
    %(D x N)
    x = repmat(Mu_I(:,k),1,size(dMu_n,2));
    quiver(x(1,:),x(2,:),dMu_n(1,:,k),dMu_n(2,:,k));
    quiver(x(1,1),x(2,1),dMu(1,k),dMu(2,k),'r');
    
end

axis equal;

%% Optimise over mean

Priors_I = ones(1,3)./3;
Mu_I     = [ [-8;-2],[8;0],[0;8] ];
for i=1:3
    Sigma_I(:,:,i) = eye(2,2);
end

Priors_k = Priors_I;
Mu_k     = Mu_I;
Sigma_k  = Sigma_I;

W        = log_gmm_div_w(X,Priors_I,Mu_I,Sigma_I);
color = (colors * W')';
scatter(X(1,:),X(2,:),10,color,'filled');


K       = 1;
logliks = [];
bVision = true;


if bVision
    close all;
    hf = figure; hold on;grid on; box on;
    ghandle = plot_gmm_contour(gca,Priors_k,Mu_k,Sigma_k,colors,3);
    hs      = scatter(X(1,:),X(2,:),10,color,'filled');
    axis equal;
    axis([get(gca,'XLim'),get(gca,'YLim')]);
end

%% Optimisation

K = 1000;

for k=1:K
    
        
    % compute log likelihood
    logliks(k) =  LogLikelihood_gmm(X,Priors_k,Mu_k,Sigma_k);
    
    
    %(D x N x K)
    W       = log_gmm_div_w(X,Priors_k,Mu_k,Sigma_k);
    dPriors = log_gmm_div_prior(W,Priors);
    dMu     = log_gmm_div_mu(X,W,Mu_k,Sigma_k);
%    dSigma  = log_gmm_div_sigma(X,W, Mu_k + dMu,Sigma_k);

    Priors_k = Priors_k + dPriors;
    Priors_k = Priors_k./sum(Priors_k);
    Mu_k     = Mu_k + dMu;
%    Sigma_k  = Sigma_k + 0.001 .* dSigma;
       
 
    disp(['it(' num2str(k) ') loglik: ' num2str(logliks(k))]);

    if bVision
        plot_gmm_contour(gca,Priors_k,Mu_k,Sigma_k,[0 0 1],1,ghandle);
        color = (colors * W')';
        set(hs,'CData',color);
        pause(0.01);
    end
    
    if k > 1
       if abs(logliks(k) - logliks(k-1)) < 1e-8 
            k = K +1;
            disp(['Optimisation finished diff: ' num2str(abs(logliks(k) - logliks(k-1)))]);
       end
    end
    
end

%% Plot Likelihood

figure; hold on;
plot(-logliks);
title('Log lik vs epoch');
xlabel('epoch');

%% Plot result Priors_k, Mu_k, Sigma_k for k=END

close all;
figure; hold on;grid on; box on;
plot_gmm_contour(gca,Priors_k,Mu_k,Sigma_k,[0 0 1],1);
plot(X(1,:),X(2,:),'r+');

for k=1:3
        %(D x N)
    x = repmat(Mu_k(:,k),1,size(dMu,2));
end

axis equal;

%% EM solution

EM(X, Priors_I, Mu_I, Sigma_I,'full');

%%

Priors_I = ones(1,3)./3;
Mu_I     = [ [-8;-2],[8;0],[0;8] ];
for i=1:3
    Sigma_I(:,:,i) = eye(2,2);
end

K       = 50;
options = statset('Display','final','MaxIter',K);
S       = struct('mu',Mu_I','Sigma',Sigma_I,'ComponentProportion',Priors_I);
GMModel = fitgmdist(X',3,'Options',options,'CovarianceType','full','Start',S);

Priors_k        = GMModel.ComponentProportion;
Mu_k            = GMModel.mu';
Sigma_k         = GMModel.Sigma;









