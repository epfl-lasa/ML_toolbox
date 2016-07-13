% KM_DEMO_AKCCA Demonstration of Alternating Kernel Canonical Correlation
% Analysis algorithm for blind equalization of single-input multiple-output
% Wiener systems.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2011.
%
% The algorithm in this file is based on the following publication:
% S. Van Vaerenbergh, J. Via and I. Santamaria, "Blind Identification of 
% SIMO Wiener Systems based on Kernel Canonical Correlation Analysis", 
% accepted for publication in IEEE Transactions on Signal Processing, 2013.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear
rs = 1; % seed for random generator
rng('default')
rng(rs)

fprintf('\nAlternating kernel CCA for blind equalization of ')
fprintf('SIMO Wiener systems.\n');

%% SETUP PARAMETERS
pars_setup.model_num = 30244; % source model, see generate_data.m
pars_setup.model_L = 5; % channel length
pars_setup.data_type = 'gaussian'; % bits, gaussian
pars_setup.data_N = 256; % number of data points
pars_setup.data_SNR = 20; % signal-to-noise ratio
pars_setup.zf_k = 15; % number of observations to estimate zero-forcing equalizers
pars_setup.p = 4; % number of branches in SIMO Wiener system
pars_setup.verbose = false;

%% ALT-KCCA PARAMETERS
pars = pars_setup; % copy some setup parameters
pars.it_max = 100; % maximum number of iterations
pars.it_stop = 1E-10; % stop iteration if change in cost is smaller than this
pars.kernel.type = 'gauss'; % kernel type
pars.kernel.par = @(x) km_silverman(x); % kernel parameter, either a scalar or a function to determine it
pars.m = 1E-8; % number of KPCA autovectors / precision of ICD, or fraction of discarded signal energy
pars.reg = 1E-5; % regularization
pars.decomp = 'ICD'; % ICD or KPCA
pars.identical_nonlin = 0;	% boolean indicating common nonlinearity for each channel

%% PROGRAM
tic

N = pars_setup.data_N; p = pars_setup.p; SNR = pars_setup.data_SNR;
% GENERATE DATA
switch pars_setup.data_type,
    case 'gaussian'
        s = randn(N,1); s = s-mean(s); % source signal
    case 'bits'
        s = 2*round(rand(N,1))-1; % source signal
end
y = cell(p,1); x = cell(p,1); sigpow = 0;
f = @(x) tanh(0.8*x)+0.1*x; % nonlinearity
B1 = [0.6172   -0.8601    2.1383    0.4269   -1.3153
    0.6247    0.1532    0.9686   -0.5820   -0.4584
    0.3373   -0.1888   -1.4263    0.8060   -0.1740
    -0.0349   -0.6264   -0.2486    1.1975    1.2195
    -3.2957    0.9985   -0.3768    0.6139   -1.2011]/1.5; % linear filter
B = cell(p,1);
for i=1:p, % simulate Wiener system
    B{i} = B1(:,i);
    y{i} = filter(B{i},1,s);
    x{i} = f(y{i});
    sigpow = sigpow + x{i}'*x{i}/p/N;
end
noisepow = 10^(-SNR/10)*sigpow;
for i=1:p, x{i} = x{i} + sqrt(noisepow)*randn(N,1); end % add noise
data.s = s; data.B = B; data.y = y; data.x = x;

%% AKCCA algorithm
[vars,eval] = km_akcca(pars,data);

toc
%% OUTPUT

% calculate MSE or BER
switch pars_setup.data_type
    case 'gaussian'
        % scale signals and compare
        s1 = s(vars.ind_s); s2 = eval.s_est;
        s1_norm = s1/norm(s1); sc = s1_norm'*s2/(s2'*s2);
        err_vec = s1_norm - sc*s2;
        
        MSE = err_vec'*err_vec;
        sc = sc*norm(s1);
        
        fprintf('MSE = %.2f dB\n',10*log10(MSE));
    case 'bits'
        sc = 1;
        fprintf('BER = %.4f\n',eval.finalresult);
end

N = pars_setup.data_N;

% draw estimates of nonlinearities
figure
for i=1:p
    subplot(1,p,i); hold all
    xi = vars.x{i};
    y_est = vars.y_est{i};
    sci = y{i}'*y_est/(y_est'*y_est);
    
    plot(xi,data.y{i},'.b')
    plot(xi,sci*y_est,'.r');
    legend(sprintf('x%d vs true, unknown y%d',i),sprintf('x%d vs estimated y%d',i))
    xlabel('x')
end

% draw estimates of linear filters
figure
for i=1:p
    subplot(1,p,i); hold all
    stem(B{i},'ob','LineWidth',2,'MarkerSize',8);
    stem(vars.h{i}*norm(B{i})/norm(vars.h{i}),'xr','LineWidth',2,...
        'LineStyle','none','MarkerSize',10);

    xlabel('l');ylabel(sprintf('h_%d',i));
    legend({'real channel','estimated channel'})
end

% draw equalization result
figure; hold all
plot(s(vars.ind_s))
plot(sc*eval.s_est);
legend('source signal','recovered signal')
