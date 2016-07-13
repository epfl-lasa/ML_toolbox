% KM_DEMO_KRR_ICD Kernel ridge regression (also known as kernel
% least-squares KLS) on data sampled from a sinc function, using incomplete
% Cholesky decomposition.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear

%% PARAMETERS

N = 2500; % number of data points sampled from sinc
N2 = 100; % number of data points for testing the regression
nvar = 0.05; % noise variance factor

lambda = 1E-4; % regularization constant
kernel = 'gauss'; % kernel type
sigma = 1; % Gaussian kernel width

m = 100; % maximal rank of decomposition

%% PROGRAM
tic

X = randn(N,1); % sampled data
noise = nvar*randn(N,1); % noise
Y = sin(3*X)./X+noise; % noisy sinc data
X2 = linspace(-3,3,N2)'; % input data for testing the regression

[alpha,Y2,subset] = km_krr_icd(X,Y,kernel,sigma,m,X2);

Y2sinc = sin(3*X2)./X2; % true sinc output data corresponding to x2

toc
%% OUTPUT

figure; hold on
plot(X,Y,'x','Color',[0.7,0.7,0.7]);
plot(X2,Y2sinc,'b--','LineWidth',2)
plot(X2,Y2,'r');
plot(X(subset,:),Y(subset),'og')
legend('noisy data','regression','true sinc function','support points')
title('Kernel ridge regression demo')
