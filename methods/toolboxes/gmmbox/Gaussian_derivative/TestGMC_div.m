%% Test GMC

a = -5;
b =  5;
nbSamples = 1;
Priors = ones(1,nbSamples)./nbSamples; 
Mu     = a + (b-a).*rand(2,nbSamples);
Sigma = repmat(eye(2,2).*(0.5.^2),[1,1,nbSamples]); 

%Sigma  =[2 -0.2;-0.2 1];


% xs    = linspace(-2.5,2.5,100);
% 
% [Xs,Ys] = meshgrid(xs,ys);
% XTest   = [Xs(:),Ys(:)];
% zs      = gmm_pdf(XTest',Priors,Mu,Sigma);
%%
close all;
figure; hold on; box on;
%surf(Xs,Ys,reshape(zs,size(Xs))); 
%shading interp;

plot_gmm_contour(gca,Priors,Mu,Sigma,[0 0 1],3);

xlabel('$\mathbf{x}$','Interpreter','Latex','FontSize',20);
ylabel('$\mathbf{y}$','Interpreter','Latex','FontSize',20);
set(gca,'FontSize',12);
axis equal;

%% conditional
dx = linspace(-4,4,100);
x_in = -2;
y    = gmc_pdf(dx,x_in,Priors, Mu, Sigma, 1, 2);

%close all;
figure; hold on;
plot(dx,y);

%% 2D Gaussian

Mu_x  = Mu(1);
Mu_dx = Mu(2);  

Sigma_dxdx = Sigma(2,2);
Sigma_dxx  = Sigma(1,2);
Sigma_xdx  = Sigma(2,1);
Sigma_xx   = Sigma(1,1);

x  = 6;
dx = 6;

%% 4D Gaussian
Mu    = rand(4,1);
Sigma = rand(4,4);
Sigma = 0.5 * (Sigma + Sigma') + eye(4,4);

Mu_x  = Mu(1:2);
Mu_dx = Mu(3:4);  

Sigma_dxdx = Sigma(3:4,3:4);
Sigma_dxx  = Sigma(3:4,1:2);
Sigma_xdx  = Sigma(1:2,3:4);
Sigma_xx   = Sigma(1:2,1:2);

x  = rand(1,2);
dx = rand(1,2);

%%

A = rand(2,2);
A = 0.5* (A + A') + eye(2,2) .* 1e-06;
b = rand(2,1);
c = rand(2,1);

disp('---');
b' * A * c
c' * A * b



%%

f = @(Mu_dx)div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);


[y,dy] = f(Mu_dx)

%% Schur complement



%[y] = div_gmc(dx,x,Mu_dx,Mu_x,Sigma_dxdx,Sigma_xx,Sigma_dxx);
%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-20,'TolX',1e-20);

[x fval exitflag output] = fminunc(f,Mu_dx,options);


%% Check originial function

%% Gaussian Mixutre Regression

in  = 1;
out = 2;
x   = 3;

Mu_x  = Mu(1,:);
Mu_dx = Mu(2,:);

f = @(Mu_dx)div_gmr(Priors,Mu_x,Mu_dx,Sigma,x,in,out);

[y,dy] = f(Mu_dx)

%% 

f = @(Mu_dx)div_mu_log_gmr(Priors, Mu_x,Mu_dx, Sigma, x, in, out);



%% finite difference check

rng(0,'twister'); 
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on','DerivativeCheck','on','Display','iter','TolFun',1e-20,'TolX',1e-20);

[x fval exitflag output] = fminunc(f,Mu_dx,options);


















