function [y1,y2,beta,alpha1,alpha2,R,D,K1,K2] = ...
    km_kcca(X1,X2,kernel,kernelpar,reg,numeig,decomp,lrank)
% KM_KCCA performs kernel canonical correlation analysis.
% Input:	- X1, X2: data matrices containing one datum per row
%			- kernel: kernel type (e.g. 'gauss')
%			- kernelpar: kernel parameter value
%			- reg: regularization
%			- numeig: number of canonical correlation vectors to retrieve 
%			  (default = 1)
%			- decomp: low-rank decomposition technique (e.g. 'ICD')
%			- lrank: target rank of decomposed matrices
% Output:	- y1, y2: nonlinear projections of X1 and X2 (canonical 
%			  correlation vectors)
%			- beta: canonical correlations
% USAGE: [y1,y2] = km_kcca(X1,X2,kernel,kernelpar,reg,decomp,lrank)
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

N = size(X1,1);	% number of data

if nargin<7,
	decomp = 'full';
end

% handle the number of eigenvectors to return
if nargin<6,
    numeig = 1;
end
if ischar(numeig),
    if strcmp(numeig,'all'),
        numeig = size(X1,1); % upper bound, to be reduced later
    end
end

switch decomp
	case 'ICD' % incomplete Cholesky decomposition

		% get incompletely decomposed kernel matrices. K1 \approx G1*G1'
		G1 = km_kernel_icd(X1,kernel,kernelpar,lrank);
		G2 = km_kernel_icd(X2,kernel,kernelpar,lrank);

		% remove mean. avoid standard calculation N0 = eye(N)-1/N*ones(N);
		G1 = G1-repmat(mean(G1),N,1);
		G2 = G2-repmat(mean(G2),N,1);

        % restrict number of eigenvalues with rank information
        minrank = min(size(G1,2),size(G2,2));
        numeig = min(numeig,minrank);
        
		% ones and zeros
		N1 = size(G1,2); N2 = size(G2,2);
		Z11 = zeros(N1); Z22 = zeros(N2); Z12 = zeros(N1,N2);
		I11 = eye(N1); I22 = eye(N2);

		% 3 GEV options, all of them are fairly equivalent

		% % option 1: standard Hardoon
		% R = [Z11 G1'*G1*G1'*G2; G2'*G2*G2'*G1 Z22];
		% D = [G1'*G1*G1'*G1+reg*I11 Z12; Z12' G2'*G2*G2'*G2+reg*I22];

		% option 2: simplified Hardoon
		R = [Z11 G1'*G2; G2'*G1 Z22];
		D = [G1'*G1+reg*I11 Z12; Z12' G2'*G2+reg*I22];

		% % option 3: Kettenring-like generalizable formulation
		% R = 1/2*[G1'*G1 G1'*G2; G2'*G1 G2'*G2];
		% D = [G1'*G1+reg*I11 Z12; Z12' G2'*G2+reg*I22];

		% solve generalized eigenvalue problem
		[alphas,betas] = eig(R,D);
		[betass,ind] = sort(real(diag(betas)));
		alpha = alphas(:,ind(end:-1:end-numeig+1));
		alpha_norms = sqrt((sum(alpha.^2,1)));
		alpha = alpha./repmat(alpha_norms,N1+N2,1);
		beta = betass(end:-1:end-numeig+1);

		% expansion coefficients
		alpha1 = alpha(1:N1,:);
		alpha2 = alpha(N1+1:end,:);

		% estimates of correlation vectors
		y1 = G1*alpha1;
		y2 = G2*alpha2;

	case 'full' % no kernel matrix decomposition (full KCCA)

		I = eye(N); Z = zeros(N);
		N0 = eye(N); %-1/N*ones(N);

		% get kernel matrices
		K1 = N0*km_kernel(X1,X1,kernel,kernelpar)*N0
		K2 = N0*km_kernel(X2,X2,kernel,kernelpar)*N0

        % restrict number of eigenvalues with rank information
        minrank = min(rank(K1),rank(K2));
        numeig = min(numeig,minrank);
        
		% 3 GEV options, all of them are fairly equivalent

		% % option 1: standard Hardoon
% 		R = [Z K1*K2; K2*K1 Z];
% 		D = 1/2*[K1*(K1+reg*I) Z; Z K2*(K2+reg*I)];
% 		R = R/2+R'/2;   % avoid numerical problems
% 		D = D/2+D'/2;   % avoid numerical problems

		% option 2: simplified Hardoon
		% R = [Z K2; K1 Z];
		% D = [K1+reg*I Z; Z K2+reg*I];
		% % R = R/2+R'/2;   % avoid numerical problems
		% % D = D/2+D'/2;   % avoid numerical problems

		% % option 3: Kettenring-like generalizable formulation
		R = 1/2*[K1 K2; K1 K2];
		D = [K1+reg*I Z; Z K2+reg*I];

		% solve generalized eigenvalue problem
		[alphas,betas] = eig(R,D);
		[betass,ind] = sort(real(diag(betas)));
		alpha = alphas(:,ind(end:-1:end-numeig+1));
		alpha_norms = sqrt((sum(alpha.^2,1)));
		alpha = alpha./repmat(alpha_norms,2*N,1);
		beta = betass(end:-1:end-numeig+1);

		% expansion coefficients
		alpha1 = alpha(1:N,:);
		alpha2 = alpha(N+1:end,:);

		% canonical correlation vectors
		y1 = K1*alpha1;
		y2 = K2*alpha2;
end
