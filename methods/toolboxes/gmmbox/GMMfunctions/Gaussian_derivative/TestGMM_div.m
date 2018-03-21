%% Check that the deriviative of GMM is correct
clear all;
%%

% value function
Q = @(X,Y) exp(-0.5 .* (X.^2 + Y.^2));

% Gaussian Mixture Model
gmm.Priors = 1;
gmm.Mu(:,1) = [-8,8]';
gmm.Sigma(:,:,1) = [1,0.5;0.5,2].^2;

xs      = linspace(-10,10,20);
[Xs,Ys] = meshgrid(xs,xs);

XData = [Xs(:),Ys(:)]';


%[dPriors,dMu,dSigma ] = log_gmm_div(XData,gmm.Priors,gmm.Mu,gmm.Sigma );

[dPriors,dMu,dSigma] = EM(XData,gmm.Priors,gmm.Mu,gmm.Sigma);


%% Plot
xs      = linspace(-10,10,100);
[Xs,Ys] = meshgrid(xs,xs);
Zs      = Q(Xs,Ys);

close all;
figure; hold on;
h_q = pcolor(Xs,Ys,Zs);
shading interp;

h_gmm = plot_gmm_contour(gca,dPriors,dMu,dSigma,[1 0 0],1);
colorbar;
title('initial setting');
%legend([h_q,h_gmm],'V(x)','pi(x)');

%% Iteration


close all;
hf = figure; hold on;
scatter(XData(1,:),XData(2,:),2);
h_gmm = plot_gmm_contour(gca,gmm.Priors,gmm.Mu,gmm.Sigma,[1 0 0],3);
colorbar;
ht = title('iter(1)');

%%

Max_iter = 10;
alpha    = 0.1;
bRecord  = true;

if bRecord
   LLs = [];
end

for n=1:Max_iter
    
    LL       = -sum(log(gmm_pdf(XData,gmm.Priors,gmm.Mu,gmm.Sigma)));

    
    disp(['iter(' num2str(n) ')  -LogLik: ' num2str(LL)]);
    
    [dPriors,dMu,dSigma ] = log_gmm_div(XData,gmm.Priors,gmm.Mu,gmm.Sigma ); % gradient
    
    gmm.Mu    = gmm.Mu    + alpha .* dMu;
    gmm.Sigma = gmm.Sigma + alpha .* dSigma;
    

    plot_gmm_contour_data(h_gmm,gmm.Priors,gmm.Mu,gmm.Sigma);
    

    if bRecord
        LLs = [LLs;LL];
    end
    
    set(ht,'String',['iter(' num2str(n) ')']);
    
    pause(0.1);

end

%% Plot log-likelihood
figure; hold on;
plot(LLs);
legend('Log likelihood');
xlabel('iter');
ylabel('-LL');


