%% Test of Gaussian Mixture Model derivative
%% Initial GMMs and Data
clear all;
%%
gmm_gt.Priors = [0.33 0.33 0.33];
gmm_gt.Priors  = gmm_gt.Priors ./ sum(gmm_gt.Priors);
gmm_gt.Mu(:,1) = [-10,5];
gmm_gt.Mu(:,2) = [0,0];
gmm_gt.Mu(:,3) = [10,-5];
gmm_gt.Sigma(:,:,1) = [2 1;
                       1 2].^2;
gmm_gt.Sigma(:,:,2) = [5, 0.9;
                       0.9, 1].^2;
gmm_gt.Sigma(:,:,3) = [2 0;0 1].^2;
XData = gmm_sample(500,gmm_gt.Priors,gmm_gt.Mu,gmm_gt.Sigma);

gmm.Priors = ones(1,3); 
gmm.Priors = gmm.Priors ./ sum(gmm.Priors);
gmm.Mu(:,1) = [-12 5]';
gmm.Mu(:,2) = [-5 -1]';
gmm.Mu(:,3) = [15 -6]';
gmm.Sigma(:,:,1) = eye(2,2);
gmm.Sigma(:,:,2) = eye(2,2);
gmm.Sigma(:,:,3) = eye(2,2);

red   = repmat([1 0 0],size(XData,2),1);
green = repmat([0 1 0],size(XData,2),1);
blue  = repmat([0 0 1],size(XData,2),1);

%[dPriors,dMu,dSigma,res] = log_gmm_div(XData,gmm.Priors,gmm.Mu,gmm.Sigma);
[dPriors,dMu,dSigma,res] = EM(XData,gmm.Priors,gmm.Mu,gmm.Sigma);

colors = red .* repmat(res(:,1),1,3) +  green .* repmat(res(:,2),1,3) +  blue .* repmat(res(:,3),1,3);

close all;
figure; hold on; box on; grid on;
h_gmm1 = plot_gmm_contour(gca,gmm_gt.Priors,gmm_gt.Mu,gmm_gt.Sigma,[1 0 0],1);
h_gmm2 = plot_gmm_contour(gca,gmm.Priors,gmm.Mu,gmm.Sigma,[0 0 1],3);
hold on;

scatter(XData(1,:),XData(2,:),10,colors,'filled');

dir = dMu - gmm.Mu;

quiver(gmm.Mu(1,:),gmm.Mu(2,:),dir(1,:),dir(2,:),0.4,'LineWidth',2,'Color',[1 0 1]);


ht = title('k(1)');
axis equal;



%% Gradient ascent on Likelihood of data

Max_iter = 1;
alpha    = 0.001;
bRecord  = true;

if bRecord
   LLs = [];
end

for n=1:Max_iter
    
    LL       = -sum(log(gmm_pdf(XData,gmm.Priors,gmm.Mu,gmm.Sigma)));

    
    disp(['iter(' num2str(n) ')  -LogLik: ' num2str(LL)]);
    
  %  [dPriors,dMu,dSigma ] = log_gmm_div(XData,gmm.Priors,gmm.Mu,gmm.Sigma); % gradient
[   dPriors,dMu,dSigma,res] = EM(XData,gmm.Priors,gmm.Mu,gmm.Sigma);
    gmm.Priors = dPriors;  
    gmm.Mu     = dMu;
    gmm.Sigma  = dSigma;
%     gmm.Priors = gmm.Priors ./ sum(gmm.Priors);
% 
% 
     plot_gmm_contour_data(h_gmm2,gmm.Priors,gmm.Mu,gmm.Sigma);
%     

    if bRecord
        LLs = [LLs;LL];
    end
    
    set(ht,'String',['iter(' num2str(n) ')']);
    
    pause(0.5);

end

%% Plot log-likelihood
figure; hold on;
plot(LLs);
legend('Log likelihood');
xlabel('iter');
ylabel('-LL');

