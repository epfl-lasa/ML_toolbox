%% Test derivative of log Gaussian Conditional log(P(dx|x;\theta))
clear all;
%% Generate 2D Gaussian
a = -5;
b =  5;
nbSamples = 10;
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

%% Check Derivative

clear f;

in  = 1;
out = 2;

x_in  = -2;
x_out = -1;

Mu_in  = Mu(in,:);
Mu_out = Mu(out,:);
Mu_dx  = Mu(out,:);

%[p,Dmu] = div_mu_log_gmc( Priors,Mu_out, Mu_in, Sigma, x_out, x_in, in, out);

f = @(Mu_out)div_mu_log_gmc(Priors,Mu_out, Mu_in, Sigma, x_out, x_in, in, out);

[p,Dmu] = f(Mu_dx)

%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-20,'TolX',1e-20);

[x fval exitflag output] = fminunc(f,Mu_dx,options);

%% Test div GMC for single Gaussian component

out = 2;
in  = 1;

k = 1;
Sigma_dxdx = Sigma(out,out,k);
Sigma_xx   = Sigma(in,in,k);
Sigma_dxx  = Sigma(out,in,k);
Sigma_xdx  = Sigma(in,out,k);

Mu_x       = Mu(in,k);
Mu_dx      = Mu(out,k);
x          = x_in;
dx         = x_out;

[y,dy]     = div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

g          = @(Mu_dx)div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

[y,dy] = g(Mu_dx)
%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-20,'TolX',1e-20);

[x fval exitflag output] = fminunc(g,Mu_dx,options);


%%

k       = 1;
x_in    = 3;
x_out   = 1;
out     = 2;
in      = 1;

[h_c,Mu_c,Sigma_c] = GMC(Priors(k), Mu(:,k), Sigma(:,:,k), x_in, in, out);



log(gmm_pdf(x_out,h_c,Mu_c,Sigma_c))

[y,dy] = div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

y





