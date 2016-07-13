function [out1,out2] = km_krlst(vars,pars,x,y)
% KM_KRLST One iteration of the Kernel Recursive Least-Squares Tracker
% Algorithm. Includes regularization and growing+pruning to maintain a
% fixed budget. Assumes a fixed value for the lengthscale, the
% regularization factor and the signal and noise powers.
% INPUT:	- vars: structure containing the calculated variables
%			- pars: structure containing the algorithm's parameters:
%				* forgetmode: 'B2P' (back-to-the-prior) or 'UI'
%               (uncertainty injection)
%				* lambda: forgetting factor
%				* kernel: kernel type and parameters
%				* c: noise-to-signal ratio (regularization)
%				* M: budget (maximum size of dictionary)
%			- x: input data
%			- y: output data (optional).
% OUTPUT:	- out1: If y is provided, the algorithm switches to
%			learning mode and returns the updated variables. If y is not
%			provided, the algorithm switches to evaluation mode and returns
%			the	estimated outputs y.
%			- out2: predictive variance of the estimated outputs, in 
%           evaluation mode.
% USAGE: [out1,out2] = km_krlst(vars,pars,x,y)
%
% Authors: Miguel Lazaro-Gredilla (miguellg *at* gtas.dicom.unican.es),
% Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es)
%
% The algorithm in this file is based on the following publication:
% M. Lazaro-Gredilla, S. Van Vaerenbergh and I. Santamaria, "A Bayesian
% approach to tracking with kernel recursive least-squares", 2011 IEEE
% Workshop on Machine Learning for Signal Processing (MLSP 2011),
% Beijing, China, September 2011.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

ktype = pars.kernel.type;
kpar = pars.kernel.par;
M = pars.M;
c = pars.c;

jitter = 1e-10;  % jitter noise to avoid roundoff error

if nargin<4, % eval option
	mode = 'eval';
else
	if ~isfield(vars,'basis')
		mode = 'init';
	else
		mode = 'train';
	end
end

switch mode
	case 'init'		% initialize
		kss = km_kernel(x,x,ktype,kpar) + jitter;
		Q = 1/kss;
		mu = y*kss/(kss+c);
		Sigma = kss-kss^2/(kss+c);
		basis = 1;  % dictionary indices
		Xb = x;     % dictionary bases
		m = 1;      % dictionary size
		nums02ML = y^2/(kss+c);
		dens02ML = 1;
		s02 = nums02ML / dens02ML;

        % write variables
		vars.Q = Q;
		vars.mu = mu;
		vars.Sigma = Sigma;
		vars.basis = basis;
		vars.Xb = Xb;
		vars.m = m;
		vars.nums02ML = nums02ML;
		vars.dens02ML = dens02ML;
		vars.s02 = s02;

		out1 = vars;
	case 'train'		% train
        % read variables
		Xb = vars.Xb;
		m = vars.m;
		Q = vars.Q;
		mu = vars.mu;
		Sigma = vars.Sigma;
		basis = vars.basis;
		nums02ML = vars.nums02ML;
		dens02ML = vars.dens02ML;
		t = vars.t;

		lambda = pars.lambda;

		%----- Forget a bit
		if ~isfield(pars,'forgetmode')
			pars.forgetmode = 'B2P';	% back-to-the-prior
		end
		switch pars.forgetmode
			case 'B2P'	% back-to-the-prior
                Kt = km_kernel(Xb,Xb,ktype,kpar);
				Sigma = lambda*Sigma + (1-lambda)*Kt;
				mu = sqrt(lambda)*mu;
			case 'UI'	% uncertainty injection
				Sigma = Sigma/lambda;
            otherwise
                error('undefined forgetting strategy');
		end

		% Predict sample t
        kbs = km_kernel(Xb,x,ktype,kpar);
        kss = km_kernel(x,x,ktype,kpar) + jitter;
		q = Q*kbs; % O(n^2)
		ymean = q'*mu;        
        gamma2 = kss - kbs'*q; gamma2(gamma2<0)=0;
        h = Sigma*q; % O(n^2)
        sf2 = gamma2 + q'*h; sf2(sf2<0)=0;
		sy2 = c + sf2;
		% yvar = s02*sy2; % predictive variance

        %----- Include sample t and add a new basis
        Qold = Q;
        p = [q; -1];
        Q = [Q zeros(m,1);zeros(1,m) 0] + 1/gamma2*(p*p'); % O(n^2)

        p = [h; sf2];
        mu = [mu;ymean] + ((y - ymean)/sy2)*p;
        Sigma = [Sigma h; h' sf2] -1/sy2*(p*p'); % O(n^2)
        basis = [basis; t]; m = m + 1;
        Xb = [Xb;x];
        
		%----- Estimate s02 via ML
		nums02ML = nums02ML + lambda*(y - ymean)^2/sy2;
		dens02ML = dens02ML + lambda;
		s02 = nums02ML / dens02ML;

		%----- Delete a basis if necessary
        if m>M  || gamma2<jitter
            if gamma2<jitter                    % To avoid roundoff error
                if gamma2<jitter/10
                    warning('Numerical roundoff error too high, you should increase jitter noise') %#ok<WNTAG>
                end
                criterium = [ones(1,m-1) 0];
            else    % MSE pruning criterion
                errors = (Q*mu)./diag(Q);
                criterium = abs(errors);
            end
            [dd, r] = min(criterium);            %#ok<ASGLU> % Remove element r, which incurs in the minimum error
            smaller = 1:m; smaller(r) = [];
            
            if r == m   % If we must remove the element we just added, perform reduced update instead
                Q = Qold;
            else
                Qs = Q(smaller, r); qs = Q(r,r); Q = Q(smaller, smaller);
                Q = Q - (Qs*Qs')/qs; % O(n^2)
            end
            mu = mu(smaller);
            Sigma = Sigma(smaller, smaller); % O(n^2)
            
            basis = basis(smaller); m = m - 1;
            Xb = Xb(smaller,:);
        end

        % write variables
		vars.Q = Q;
		vars.mu = mu;
		vars.Sigma = Sigma;
		vars.basis = basis;
		vars.Xb = Xb;
		vars.m = m;
		vars.nums02ML = nums02ML;
		vars.dens02ML = dens02ML;
		vars.s02 = s02;

		out1 = vars;
	case 'eval'		% evaluate
        % read variables
		Xb = vars.Xb;
		Q = vars.Q;
		mu = vars.mu;
		Sigma = vars.Sigma;
		s02 = vars.s02;

		% Predict sample t
		kbs = km_kernel(Xb,x,ktype,kpar);	% kernel matrix;
		meantst = kbs'*Q*mu; % O(n^2)
		
		% meantst = kbs'*Q*mu;
		sf2 = 1 + jitter + sum(kbs.*((Q*Sigma*Q-Q)*kbs),1)';sf2(sf2<0)=0;
		vartst = s02*(c + sf2);

		out1 = meantst;
		out2 = vartst;
end
