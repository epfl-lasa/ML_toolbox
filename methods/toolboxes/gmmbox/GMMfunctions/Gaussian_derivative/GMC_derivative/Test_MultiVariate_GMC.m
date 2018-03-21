%% Test derivative of log Gaussian Conditional log(P(dx|x;\theta))
clear all;
%% Generate 4D Gaussian
a = -5;
b =  5;
D =  4;

nbSamples   = 10;
Priors      = ones(1,nbSamples)./nbSamples; 
Mu          = a + (b-a).*rand(D,nbSamples);
Sigma       = [];

for k=1:nbSamples
    Sigma(:,:,k) = rand(D,D); 
    Sigma(:,:,k) = 0.5 * (Sigma(:,:,k)  + Sigma(:,:,k)') + eye(D,D) .* 1;
end

%% div_gmc

out = [3 4];
in  = [1 2];

k = 1;
Sigma_dxdx = Sigma(out,out,k);
Sigma_xx   = Sigma(in,in,k);
Sigma_dxx  = Sigma(out,in,k);
Sigma_xdx  = Sigma(in,out,k);

Mu_x       = Mu(in,k);
Mu_dx      = Mu(out,k);
x          = Mu_x  + rand(2,1);
dx         = Mu_dx + rand(2,1);

%%

[y,dy]     = div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

g          = @(Mu_dx)div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

[y,dy] = g(Mu_dx)

%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-5,'TolX',1e-5);

fminunc(g,Mu_dx,options);

%% Check Derivative
clear f;

Mu_in  = Mu(in,:);
Mu_out = Mu(out,:);
Mu_dx  = Mu(out,:);

f = @(Mu_out)div_mu_log_gmc(Priors,Mu_out, Mu_in, Sigma, dx, x, in, out);

[p,Dmu] = f(Mu_dx)

%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-10,'TolX',1e-10);

[x fval exitflag output] = fminunc(f,Mu_dx,options);







