% KM_DEMO_KRLS_WIENER1 Wiener system identification using Kernel Recursive 
% Least Square (KRLS) regression.
%
% This program implements a regression example similar to the channel
% estimation example published in 
% S. Van Vaerenbergh, J. Via, and I. Santamaria. "A sliding-window 
% kernel RLS algorithm and its application to nonlinear channel 
% identification", 2006 IEEE International Conference on Acoustics, Speech,
% and Signal Processing (ICASSP), Toulouse, France, 2006.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear

%% PARAMETERS

Ntrain = 1500;		% number of total train data points
Ntest = 200;		% number of test data points
Nswitch = 500;		% abrupt switch from model 1 to model 2 after N1 iterations
B1 = [1,.8668,-0.4764,0.2070]';	% model 1 linear filter
B2 = [1,-.8326,.6656,-.7153]';	% model 2 linear filter
f = @(x) tanh(x);			% Wiener system nonlinearity
SNR = 40;		% SNR in dB

pars.kernel.type = 'gauss';	% kernel type
pars.kernel.par = 2;			% kernel parameter (width in case of Gaussian kernel)
pars.M = 150;		% dictionary size

% % parameters for ALD-KRLS
% pars.algo = 'ald-krls';
% pars.thresh = 0.01;

% % parameters for SW-KRLS
% pars.algo = 'sw-krls';
% pars.c = 1E-4;

% parameters for KRLS-T
pars.algo = 'krls-t';
pars.lambda = .999;
pars.c = 1E-4;

d = 4;			% time-embedding

%% PROGRAM
tic

% generate data
fprintf('Generating Wiener system data...\n');
N = Ntrain+Ntest;
s = randn(N,1);	% Gaussian input, all data
s_mem = zeros(N,d);
for i = 1:d,
	s_mem(i:N,i) = s(1:N-i+1);	% time-embedding
end
s_train = s_mem(1:Ntrain,:);	% input train data, stored in columns
s_test = s_mem(Ntrain+1:Ntrain+Ntest,:);	% input test data, stored in columns

x1 = s_mem(1:Nswitch,:)*B1;
x2 = s_mem(Nswitch+1:Ntrain,:)*B2;
x = [x1;x2];
y = f(x);
vary = var(y);
noisevar = 10^(-SNR/10)*vary;
noise_train = sqrt(noisevar)*randn(Ntrain,1);
y_train = y + noise_train;				% noisy output train data

x_test1 = s_mem(Ntrain+1:Ntrain+Ntest,:)*B1;
x_test2 = s_mem(Ntrain+1:Ntrain+Ntest,:)*B2;
noise_test1 = sqrt(noisevar)*randn(Ntest,1);
noise_test2 = sqrt(noisevar)*randn(Ntest,1);
y_test1 = f(x_test1) + noise_test1;	% noisy output test data, model 1
y_test2 = f(x_test2) + noise_test2;	% noisy output test data, model 2

% apply KRLS
fprintf('Applying KRLS for Wiener system identification...\n');
vars = [];
MSE = zeros(Ntrain,1);
for i=1:Ntrain-1,
	if ~mod(i,Ntrain/10), fprintf('.'); end
	vars.t = i;
	
	% perform KRLS regression and get regression output of test signal
	switch pars.algo
		case 'ald-krls'
			vars = km_aldkrls(vars,pars,s_train(i,:),y_train(i));	% train
			y_est = km_aldkrls(vars,pars,s_test);				% evaluate
		case 'sw-krls'
			vars = km_swkrls(vars,pars,s_train(i,:),y_train(i));	% train
			y_est = km_swkrls(vars,pars,s_test);				% evaluate
		case 'krls-t'
			vars = km_krlst(vars,pars,s_train(i,:),y_train(i));	% train
			y_est = km_krlst(vars,pars,s_test);				% evaluate
		otherwise
			error('wrong algorithm')
	end
	
	% calcalate test error
	if i<=Nswitch, y_test = y_test1; else y_test = y_test2; 	end
	MSE(i) = mean((y_test-y_est).^2);
end
fprintf('\n');

toc
%% OUTPUT

fprintf('Mean MSE over last 500 steps = %.2d\n',mean(MSE(Ntrain-499:Ntrain)))

figure;semilogy(MSE)
title('MSE')

figure; hold on
plot(y_test,'b')
plot(y_est,'g')
legend({'Test output','Estimated output'})
title(sprintf('%s, m=%d',pars.algo,pars.M))
