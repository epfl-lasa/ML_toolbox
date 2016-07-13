% KM_DEMO_KCCA Demo file for kernel canonical correlation analysis
% algorithm.
%
% This script takes two multi-dimensional variables and uses kernel CCA to
% map them onto a single latent 1-D variable. The kernel matrices are 
% decomposed using incomplete Cholesky decomposition in order to allow 
% large data sets. This demo includes 3 flavors of the KCCA generalized
% eigenvalue problem, all yielding very similar results.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2012.
%
% The algorithm in this file is based on the following publications: 
% D. R. Hardoon, S. Szedmak and J. Shawe-Taylor, "Canonical Correlation 
% Analysis: An Overview with Application to Learning Methods", Neural 
% Computation, Volume 16 (12), Pages 2639--2664, 2004.
% F. R. Bach, M. I. Jordan, "Kernel Independent Component Analysis", Journal 
% of Machine Learning Research, 3, 1-48, 2002.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all; clear
rs = 1; % seed for random generator
rng('default')
rng(rs)

%% PARAMETERS
N = 1000;	% number of samples. method's complexity is O(NM^2)
Mmax = 50;  % max. M (number of components in incomplete Cholesky decomp.)
reg = 1E-5; % regularization
kerneltype = 'gauss';   % kernel type
kernelpar = 1;  % kernel parameter

%% PROGRAM
tic

% generate data
s = randn(N,1);	% latent signal
r1 = randn(N,1); r2 = randn(N,1);	% random (helper) variables

% option 1: two multi-dimensional variables that are mappable onto s
x1 = [tanh(r1-s)+0.1*r1 r1+3*s-1/10*(sin(3*s))];
x2 = [s - 2*(1-exp(-r2))./(1+exp(-r2)) r2.*s tanh(r2+s)];

% option 2: two invertible 1D nonlinear transformations
% x1 = tanh(0.8*s)+0.1*s;	% moderate saturation
% x2 = -1/10*(sin(s*3)+1.1*s*3);   % stairway

% clean up: remove mean
x1 = x1-repmat(mean(x1),N,1);
x2 = x2-repmat(mean(x2),N,1);

% normalize variance (to improve anisotropy) or any other preprocessing
x1 = x1*sqrt(diag(1./diag(x1'*x1)));
x2 = x2*sqrt(diag(1./diag(x2'*x2)));

% KCCA
[y1,y2,beta] = km_kcca(x1,x2,kerneltype,kernelpar,reg,1,'ICD',Mmax);

% scale the estimated signals to compare without the scalar ambiguity
scaling = sqrt(var(s))/sqrt(var(y1))*sign(s(1))*sign(y1(1));

% mean square errors
error1 = s-scaling*y1;
error2 = s-scaling*y2;
MSE1 = sum(error1.^2)/N;
MSE2 = sum(error2.^2)/N;

toc
%% OUTPUT

figure; hold all
plot(s)
plot(scaling*y1);
plot(scaling*y2);
legend('latent variable','projection 1','projection 2')

fprintf('2x %d data points\n',N)
fprintf('Canonical correlation: %f\n',beta)
fprintf('MSE1: %f\n',MSE1);
fprintf('MSE2: %f\n',MSE2);
fprintf('\n')

% figure;plot(sort(diag(real(betas))))  % check eigenvalues
% figure;plot(sort(diag(betas))); % imaginary part due to numerical error
