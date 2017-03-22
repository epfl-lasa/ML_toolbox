clear; close all;
d = 2;
k = 3;
n = 500;
[X,label] = kmeansRnd(d,k,n);
init = ceil(k*rand(1,n));
plotClass(X,label)
%%

[N,M] = size(X);

k = 2; 
sigma = 1;
init = ceil(k*rand(1,M));

% Gaussian Kernel
[y,model,mse] = knKmeans(X,init,@knGauss, 1);

% Polynomial Kernel
degree = 2;
coeff  = 0;
% [y,model,mse] = knKmeans(X,init,@knPoly, degree, coeff);


plotClass(X,y)

%%
idx = 1:2:M;
Xt = X(:,idx);
t = knKmeansPred(model, Xt);
plotClass(Xt,t)