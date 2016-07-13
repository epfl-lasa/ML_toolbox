%% Test Derivative of logarithm Gaussian Mixture Regression
%% Generate 2D Gaussian
a = -5;
b =  5;
nbSamples = 5;
Priors = ones(1,nbSamples)./nbSamples; 
Mu     = a + (b-a).*rand(2,nbSamples);
Sigma = [];
for k=1:nbSamples
    Sigma(:,:,k) = rand(2,2); 
    Sigma(:,:,k) = 0.5 * (Sigma(:,:,k)  + Sigma(:,:,k)') + eye(2,2) .* 1;
end

%% Plot

close all;
figure; hold on; box on;
plot_gmm_contour(gca,Priors,Mu,Sigma,[0 0 1],3);

xlabel('$\mathbf{x}$','Interpreter','Latex','FontSize',20);
ylabel('$\mathbf{y}$','Interpreter','Latex','FontSize',20);
set(gca,'FontSize',12);
axis equal;

%%
in  = 1;
out = 2;
x   = 3;

Mu_x  = Mu(1,:);
Mu_dx = Mu(2,:);

f = @(Mu_dx)div_gmr(Priors,Mu_x,Mu_dx,Sigma,x,in,out);

[y,dy] = f(Mu_dx)


%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-20,'TolX',1e-20);

[x fval exitflag output] = fminunc(f,Mu_dx,options);