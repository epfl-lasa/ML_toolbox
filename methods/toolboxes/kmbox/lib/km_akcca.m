function [vars,eval] = km_akcca(pars,data)
% KM_AKCCA performs Alternating Kernel Canonical Correlation Analysis to
% blindly identify and equalize a single-input multiple-output Wiener.
%
% Input:	- pars: structure containing parameters of the alternating KCCA
%             algorithm
%			- data: structure containing the available data x, and the
%             unavailable data (source signal s, internal signals y, and 
%             linear channels B)
% Output:	- vars: estimated variables
%           - eval: structure containing the resuls of the algorithm
%             evaluation
% USAGE: [vars,eval] = km_akcca(pars,data)
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

% AKCCA CORE
[vars, eval] = AKCCA_CORE_INIT(pars,data.x); % initialize
vars.it = 0;
eval.converged = false;
while ((vars.it < pars.it_max) && ~eval.converged)
    fprintf('.');
    vars.it = vars.it+1;
    vars = AKCCA_CORE_LINID(pars,vars); % CCA 1: estimate h and obtain z
    vars = AKCCA_CORE_NLINID(pars,vars); % CCA 2: estimate alpha and obtain y
    vars = AKCCA_CORE_EQ(pars,vars); % EQUALIZATION
    eval = AKCCA_CORE_EVAL(pars,vars,data,eval); % Error calculation and check convergence
end
fprintf('\n');



function [vars,eval] = AKCCA_CORE_INIT(pars,x)

% READ PARAMETERS AND VARIABLES
p = pars.p;
m = pars.m;
N = pars.data_N;
num_it = pars.it_max;
ktype = pars.kernel.type;
% ktype = pars.kernel{1};
kpar = pars.kernel.par;
diff_nlin = ~pars.identical_nonlin;	% boolean indicating different nonlinearities

% CONSTRUCT KERNEL MATRIX DECOMPOSITIONS
K = cell(p,1);
c = cell(p,1);
if diff_nlin,
    switch pars.decomp
        case 'KPCA'
            for i=1:p,
                if isa(kpar,'function_handle')	% determine kernel parameter
                    parfun = kpar;
                    c{i} = parfun(x{i});
                else c{i} = kpar(i);
                end
                Kfull = km_kernel_center(x{i},x{i},x{i},ktype,c{i});
                Kfull = 0.5*(Kfull+Kfull');	% avoid matlab rounding errors
                [V,D] = eig(Kfull);
                [D_sort,ind] = sort(real(diag(D)),'descend');
                if m<1,	% m represents the fraction of energy to be witheld
                    energy = sum(D_sort);
                    cumul_energy = cumsum(D_sort)/energy;
                    m = sum(cumul_energy < 1-m)+1;	% new m is number of required eigenvectors
                end
                K{i} = V(:,ind(1:m));
            end
        case 'ICD'
            
            for i=1:p,
                if isa(kpar,'function_handle')	% determine kernel parameter
                    parfun = kpar;
                    c{i} = parfun(x{i});
                else
                    c{i} = kpar(i);
                end
                if m<1,	% m represents the precision in ICD
                    precision = m;
                    mm = N;
                else
                    precision = 1E-10;
                    mm = m;
                end
                G = km_kernel_icd(x{i},ktype,c{i},mm,precision);
                G = G-repmat(mean(G),N,1);
                K{i} = G;
            end
        otherwise
            error 'wrong decomposition method';
    end

    y_est = x;
    
else
    Xf = [];
    for i=1:p,
        Xf = [Xf;x{i}]; %#ok<AGROW>
    end
    
    if isa(kpar,'function_handle')	% determine kernel parameter
        parfun = kpar;
        c = parfun(Xf);
    else c = kpar(i);
    end
    
    switch pars.decomp
        case 'KPCA'
            Kfull = km_kernel_center(Xf,Xf,Xf,ktype,c);
            Kfull = 0.5*(Kfull+Kfull');
            [V,D] = eig(Kfull);
            [D_sort,ind] = sort(real(diag(D)),'descend');
            
            if m<1,	% m represents the fraction of energy to be witheld
                energy = sum(D_sort);
                cumul_energy = cumsum(D_sort)/energy;
                m = sum(cumul_energy < 1-m)+1;	% new m is number of required eigenvectors
            else
                m=m*p;
            end
            for i=1:p,
                stind = (i-1)*N + 1;
                ndind = stind+N - 1;
                K{i} = V(stind:ndind,ind(1:m));
            end
            
        case 'ICD'
            
            if m<1,	% m represents the precision in ICD
                precision = m;
                mm = N;
            else
                precision = 1E-10;
                mm=m*p;
            end
            G = km_kernel_icd(Xf,ktype,c,mm,precision);
            G = G-repmat(mean(G),p*N,1);
            
            for i=1:p,
                stind = (i-1)*N + 1;
                ndind = stind+N - 1;
                K{i} = G(stind:ndind,:);
            end
        otherwise
            error 'wrong decomposition method';
    end
    
    y_est = x;
end

% WRITE EVAL AND VARIABLES
eval.MSE_y = zeros(1,num_it);
eval.MSE_z = zeros(2,num_it);
eval.MSE_h = zeros(1,num_it);
eval.result = zeros(1,num_it);

vars.y_est = y_est;		% initialize without taking into account the nonlinearity
vars.K = K;		% reduced kernel matrices
vars.x = x;		% original output data
vars.c = c;     % kernel parameter



function vars = AKCCA_CORE_LINID(pars,vars)
% estimate linear filters

% COPY PARAMETERS
p = pars.p;
L = pars.model_L;
N = pars.data_N;
K = vars.K;

y_est = vars.y_est;

% PROGRAM
n = N-L+1;

% get time-embedded data matrices
Ka = cell(p,1);
for i=1:p,
	Ka{i} = zeros(n,L);
% 	for n_ind = 1:n,    % too slow, better fill differently
% 		Ka{i}(n_ind,:) = y_est{i}(n_ind+L-1:-1:n_ind)';
% 	end
    for l_ind = 1:L,
        Ka{i}(:,l_ind) = y_est{i}(L-l_ind+1:L-l_ind+n)';
    end
end

h = SIMO_id_CCA(Ka);

zh_est = cell(p);
W = cell(p);
% rescale solution to fulfill restriction sumsqr = 1
sumnrg_h = 0;
for i=1:p,
	for j=1:p,
		if(i~=j)
			sumnrg_h = sumnrg_h + sum((Ka{i}*h{j}).^2);
		end
	end
end
for i=1:p,
	h{i} = h{i}/sqrt(sumnrg_h);
end

for i=1:p,
	for j=1:p,
		if (i~=j)
            mi = size(K{i},2);
            W{i,j} = zeros(n,mi);
			zh_est{i,j} = Ka{i}*h{j};	% system output
%             for n_ind=1:n,  % too slow, better fill differently
%                 kimat = K{i}(n_ind+L-1:-1:n_ind,:);
%                 W{i,j}(n_ind,:) = h{j}'*kimat;	% auxiliary variable
%             end
            for l_ind = 1:L,    % superfast
                W{i,j} = W{i,j} + h{j}(l_ind)*K{i}(L-l_ind+1:L-l_ind+n,:);
            end
		end
	end
end

% COPY VARIABLES
vars.h = h;		% filter estimation
vars.zh_est = zh_est;	% new output estimate
vars.W = W;		% auxiliary variable (filtered kernel matrices)



function vars = AKCCA_CORE_NLINID(pars,vars)
% estimate inverse nonlinearities

% READ PARAMETERS AND VARIABLES
p = pars.p;
diff_nlin = ~pars.identical_nonlin;	% boolean indicating different nonlinearities

K = vars.K;
W = vars.W;
reg = pars.reg;

% PROGRAM: 1 iteration
za_est = cell(p);
y_est = cell(p,1);
if diff_nlin
	% standard case: no identical nonlinearity
	a = SIMO_id_CCA_dual(W,reg);

	% rescale solution to fulfill restriction sumsqr = 1
	sumnrg_a = 0;
	for i=1:p,
		for j=1:p,
			if(i~=j)
				sumnrg_a = sumnrg_a + sum((W{i,j}*a{i}).^2);
			end
		end
	end

	for i=1:p,
		a{i} = a{i}/sqrt(sumnrg_a);
		y_est{i} = K{i}*a{i};	% get y estimates
		y_est{i} = y_est{i}/sqrt(norm(y_est{i}))*sqrt(norm(vars.x{i}));	% normalize
		for j=1:p,
			if (i~=j)
			za_est{i,j} = W{i,j}*a{i};	% system output
			end
		end
	end
else
	% identical nonlinearity
	a = SIMO_id_CCA_dual_identical(W,reg);
	for i=1:p,
		y_est{i} = K{i}*a;	% get y estimates
		for j=1:p,
			if (i~=j)
			za_est{i,j} = W{i,j}*a;	% system output
			end
		end
	end
end

% WRITE VARIABLES
vars.alpha = a;
vars.y_est = y_est;
vars.za_est = za_est;



function vars = AKCCA_CORE_EQ(pars,vars)
% equalize linear channels (zero-forcing)

% COPY PARAMETERS
p = pars.p;
L = pars.model_L;
N = pars.data_N;
k = pars.zf_k;

y_est = vars.y_est;
h = vars.h;

% PROGRAM
% use k observations to generate filter matrix and estimate equalizers
Hc = cell(p,1); Hr = cell(p,1);
TH = zeros(p*k,k+L-1);
for i=1:p,
	Hc{i} = [h{i}(1);zeros(k-1,1)];
	Hr{i} = [h{i}' zeros(1,k-1)];
	TH(i:p:end,:) = toeplitz(Hc{i},Hr{i});
end

% zero-forced equalizing
ZF = pinv(TH);

% S_est = zeros(N-k+1,k);
% Yi = zeros(p*k,1);
% for i=1:N-k+1,  % too slow, better fill differently
% 	for j=1:p,
% 		yi = y_est{j}(i+k-1:-1:i);
% 		Yi(j:p:end) = yi;
% 	end
% 	s_esti = ZF*Yi;
% 	S_est(i,:) = s_esti(1:k).';
% end
YY = zeros(N-k+1,p*k);
for j = 1:p,
    for k_ind=1:k,
        col = (k_ind-1)*p + j;
        YY(:,col) = y_est{j}(k-k_ind+1:N-k_ind+1);
    end
end
S_est = YY*ZF(1:k,:)';

cnorms = zeros(k,1);
for i=1:k,
	cnorms(i) = norm(ZF(:,i));
end
[mm,zfi] = min(cnorms); %#ok<ASGLU>
s_est = S_est(:,zfi);

inds = k-zfi+1:N-zfi+1;

% COPY VARIABLES
vars.s_est = s_est;
vars.ind_s = inds;
vars.ZF = ZF;



function eval = AKCCA_CORE_EVAL(pars,vars,data,eval)
% evaluate solutions: calculate errors

% COPY PARAMETERS
p = pars.p;
vb = pars.verbose;

y_est = vars.y_est;
s_est = vars.s_est;
h = vars.h;
it = vars.it;
inds = vars.ind_s;

s = data.s; % true source signal
B = data.B; % true channels
y = data.y; % true internal channels

% PROGRAM
MSE_y = 0; MSE_h = 0; MSE_za = 0; MSE_zh = 0;
for i=1:p,
	% check if system internals are known
	if (iscell(y))
		% MSE Y
		MSE_y = MSE_y + norm_compare(y{i},y_est{i})/p;
		% MSE H
		numz = length(h{i})-length(B{i});
		if (numz>0)
			% channel overestimation case
			B{i} = [B{i};zeros(numz,1)];
		end
		MSE_h = MSE_h + norm_compare(B{i},h{i})/p;
	end
	
	% MSE Z
	if isfield(vars,'za_est')
		za_est = vars.za_est;
	end
	zh_est = vars.zh_est;

	for j=i+1:p,
		if (i~=j)
			MSE_zh = MSE_zh + sum((zh_est{i,j}-zh_est{j,i}).^2);
			if isfield(vars,'za_est')
				MSE_za = MSE_za + sum((za_est{i,j}-za_est{j,i}).^2);
			end
		end
	end
end

signal_test = s(inds);
signal_est = s_est;

switch lower(pars.data_type)
	case {'gaussian'}
		% result = MSE between s and s_est
		result = norm_compare(signal_test,signal_est);
	case 'bits'
		% result = BER
		[MSEsb,sci] = scale_compare(signal_test,signal_est); %#ok<ASGLU>
		result = sum(sign(signal_test)~=sign(signal_est/sci))/length(signal_test);
        s_est = sign(signal_est/sci);
	otherwise
		disp('Unknown signal type.')
end

% OUTPUT
if vb, fprintf(1,'MSE z_a: %f\n',MSE_za); end;
if vb, fprintf(1,'MSE z_h: %f\n',MSE_zh); end;
if vb, fprintf(1,'MSE y: %f\n',MSE_y); end;
if vb, fprintf(1,'Result: %f\n',result); end;

% COPY VARIABLES
eval.MSE_h(it) = MSE_h;
eval.MSE_y(it) = MSE_y;
eval.MSE_z(1,it) = MSE_zh;
eval.MSE_z(2,it) = MSE_za;
eval.result(it) = result;
eval.s_est = s_est;

% CHECK STOP
if (it>2)
	% stop when both sub-iterations obtain consecutive equal costs
	change1 = abs(eval.MSE_z(2*it)-eval.MSE_z(2*it-2));
	change2 = abs(eval.MSE_z(2*it-1)-eval.MSE_z(2*it-3));
	if ((change1 < pars.it_stop) && (change2 < pars.it_stop))
		eval.converged = true;
		num = pars.it_max - it;
		eval.MSE_h(it+1:pars.it_max) = repmat(MSE_h,num,1);
		eval.MSE_y(it+1:pars.it_max) = repmat(MSE_y,num,1);
		eval.MSE_z(2*it+1:2*pars.it_max) = repmat(MSE_zh,2*num,1);
		eval.result(it+1:pars.it_max) = repmat(result,num,1);
	end
end

eval.finalresult = result;



function [h,alphas,betas] = SIMO_id_CCA(X)
% SIMO_ID_CCA estimates various channels of a SIMO system using CCA.
% Finds the optimal h_i such that X_i h_j = X_j H_i s.t. sum (i = j)
% ||X_i h_j||^2 = 1.
% Input:	- X: cell containing p sets of length N and dimension L (N x L)
% Output:	- h: identified channels (cell)
%			- alphas: sorted eigenvectors
%			- betas: sorted eigenvalues
%
% Steven Van Vaerenbergh 2008

p = length(X);
L = size(X{1},2);

Rf = zeros(p*L); Df = zeros(p*L);
for i=1:p,
	D = zeros(L);
	for j=1:p,
		if i~=j
			sti = (i-1)*L+1;
			ndi = i*L;
			stj = (j-1)*L+1;
			ndj = j*L;
			Rf(sti:ndi,stj:ndj) = X{j}'*X{i};
			D = D + X{j}'*X{j};
		end
	end
	Df(sti:ndi,sti:ndi) = D;
end

[alphas,betas] = eig(Rf,Df);
[betas,ind] = sort(real(diag(betas)),'ascend');
alpha = alphas(:,ind(end));
% alpha = alpha/norm(alpha);

h = cell(p,1);
for i=1:p,
	sti = (i-1)*L+1;
	ndi = i*L;
	h{i} = alpha(sti:ndi);
end



function [h,alphas,betas] = SIMO_id_CCA_dual_identical(X,reg)
% SIMO_ID_CCA estimates various channels of a SIMO system using CCA.
% Finds the optimal h_i such that X_ij h = X_ji h 
% Input:
%	X: cell containing pxp data sets of length N and dimension m (N by m)
%   reg: regularization
%	
% outputs:
%	h: identified channels
%	alphas: sorted eigenvectors
%	betas: sorted eigenvalues
%
% Reference: Via, Santamaria [...]
%
% Steven Van Vaerenbergh 2008

if nargin<2
    reg = 1E-8;
end

p = size(X,1);
m = size(X{1,2},2);

Rf = zeros(m); Df = zeros(m);
for i=1:p,
	for j=1:p,
		if i~=j
			Rf = Rf + X{i,j}'*X{j,i};
			Df = Df + X{i,j}'*X{i,j};
		end
	end
end
Df = Df + reg*eye(size(Df));
	
% solve eigenvalue problem
[alphas,betas] = eig(Rf,Df);
[betas_a,ind] = sort(real(diag(betas))); %#ok<ASGLU>
h = alphas(:,ind(end));



function [h,alphas,betas] = SIMO_id_CCA_dual(X,reg)
% SIMO_ID_CCA estimates various channels of a SIMO system using CCA.
% Finds the optimal h_i such that X_ij h_i = X_ji h_j s.t. sum (i~=j) 
% ||X_ij h_i||^2 = 1.
% Input:	- X: cell containing pxp sets of length N and dimension mi (N x mi).
%           - reg: regularization
% Outputs:	- h: identified channels (cell)
%			- alphas: sorted eigenvectors
%			- betas: sorted eigenvalues
%
% Steven Van Vaerenbergh 2008

if nargin<2
    reg = 1E-8;
end

p = size(X,1);
m = zeros(p,1);
for i=1:p,
	j = mod(i,p)+1;
	m(i) = size(X{i,j},2);
end
mcum = [0;cumsum(m)];

Rf = zeros(mcum(end)); Df = zeros(mcum(end));
for i=1:p,
	D = zeros(m(i));
	for j=1:p,
		if i~=j
			sti = mcum(i)+1;
			ndi = sti+m(i)-1;
			stj = mcum(j)+1;
			ndj = stj+m(j)-1;
			Rf(sti:ndi,stj:ndj) = X{i,j}'*X{j,i};
			D = D + X{i,j}'*X{i,j};
		end
	end
	Df(sti:ndi,sti:ndi) = D + reg*eye(size(D));
end

[alphas,betas] = eig(Rf,Df);
[betas,ind] = sort(real(diag(betas)),'ascend');
alpha = alphas(:,ind(end));
% alpha = alpha/norm(alpha);

h = cell(p,1);
for i=1:p
	sti = mcum(i)+1;
	ndi = mcum(i+1);
	h{i} = alpha(sti:ndi);
end



function MSE = norm_compare(data_1,data_2)
% NORM_COMPARE calculates the squared error between 2 normalized signals

data_1_norm = data_1/norm(data_1);
data_2_norm = data_2/norm(data_2);

% take into account sign ambiguity
err_vecA = data_1_norm - data_2_norm;
err_vecB = data_1_norm + data_2_norm;

MSEA = err_vecA'*err_vecA;
MSEB = err_vecB'*err_vecB;

MSE = min(MSEA,MSEB);



function [MSE,sc] = scale_compare(data_1,data_2)

data_1_norm = data_1/norm(data_1);
sc = data_1_norm'*data_2/(data_2'*data_2);

err_vec = data_1_norm - sc*data_2;

MSE = err_vec'*err_vec;
sc = sc*norm(data_1);
