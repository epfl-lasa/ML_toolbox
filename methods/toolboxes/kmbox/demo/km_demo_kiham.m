% KM_DEMO_AKCCA Kernel-Based Identification of Hammerstein Systems. This
% demo generates some Hammerstein system input and output data and performs
% identification of the system using KIHAM.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2013.
%
% The algorithm in this file is based on the following publication:
% S. Van Vaerenbergh and L. A. Azpicueta-Ruiz, "Kernel-Based Identification
% of Hammerstein Systems for Nonlinear Acoustic Echo-Cancellation", 2014
% IEEE International Conference on Acoustics, Speech, and Signal Processing
% (ICASSP), Florence, Italy, May 2014.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

%% STATE

close all; clear
% rs = sum(100*clock);
rs = 1; % seed for random generator
rng('default')
rng(rs)

%% PARAMETERS

% system
f = @(x) tanh(x);
L = 256; % linear channel length
N = 1024; % number of samples
SNR = 50;

% kiham
kerneltype = 'gauss';
kernelpar = .5;
M = 25; % dictionary size
ca = .001;
ch = 1;
it_max = 50; % maximum number of iterations
it_stop = 1E-6; % stop if change in cost is smaller than this

%% GENERATE DATA

H = [1 randn(1,L-1)]';

x = 5*(2*rand(N,1)-1);
% x = randn(N,1);
z = f(x);
z_mem = km_memfill(z,L);
y_ref = z_mem*H;

sig = y_ref;
sigvar = var(sig);
noisevar = 10^(-SNR/10)*sigvar;
noise = sqrt(noisevar)*randn(size(sig));
y = y_ref + noise;

%% PROGRAM
tic

xdict = linspace(min(x),max(x),M)';

[alpha,h] = km_kiham(x,y,xdict,L,kerneltype,kernelpar,ca,ch,it_max,it_stop);

fprintf('Training: elapsed time is %.2f seconds.\n',toc)
%% OUTPUT

x_test = linspace(min(x),max(x),100)';
z_test_true = f(x_test);
K_test = km_kernel(x_test,xdict,kerneltype,kernelpar);
z_test_est = K_test*alpha;
scale = norm(h)/norm(H)*sign(h(1))*sign(H(1)); % internal ambiguity
z_test_est = z_test_est*scale;

figure; hold all
plot(x_test,z_test_true,'.');
% grid on
% legend('true nonlinearity')
plot(x_test,z_test_est,'.','Color',[0 .5 0]);
legend({'true nonlinearity','estimated nonlinearity'},'Location','SE')
grid on

figure; hold all
stem(H);
stem(h/scale)
legend('true linear channel','estimated linear channel')

fprintf('Test MSE = %.4f dB\n',10*log10(mean((z_test_true-z_test_est).^2)))
