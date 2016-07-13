function varout = km_norma(vars,pars,x,y)
% KM_NORMA implements the basic iteration of the NORMA algorithm (kernel
% LMS algorithm with sliding window).
% Input:	- vars: structure containing the used variables
%			- pars: structure containing kernel and algorithm parameters
%			- x: matrix containing input vectors as rows
%			- y: vector containing output values
% Output:	- out: contains the new vars if the algorithm is in learning 
%			mode (when x and y are provided) and the estimated output when 
%			the algorithm is being evaluated (when only x is given).
% Dependencies: km_kernel.
% USAGE: out = km_norma(vars,pars,x,y)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% The algorithm in this file is based on the following publication:
% J. Kivinen, A. Smola and C. Williamson. "Online Learning with Kernels", 
% IEEE Transactions on Signal Processing, volume 52, no. 8,
% pages 2165-2176, 2004.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

ktype = pars.kernel.type;
kpar = pars.kernel.par;

if nargin<4,
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
		mu = pars.mu;		% learning rate
		lambda = pars.c;	% regularization parameters
		M = pars.M;	% theta in original article;
		
		% initialize algorithm
		mem = x;
		basis = 1;
		beta = (1-mu*lambda).^(0:M-1)';
		y_est = 0;
		err = y-y_est;
		alpha = mu*err;
		
		vars.alpha = alpha;
		vars.mem = mem;
		vars.basis = basis;
		vars.beta = beta;
		varout = vars;
	case 'eval'		% evaluate
		mem = vars.mem;
		alpha = vars.alpha;
		beta = vars.beta;
		
		K = km_kernel(x,mem,ktype,kpar);
	 	y = K*(alpha.*beta(length(alpha):-1:1));
		
		varout = y;
	case 'train'		% train
		mem = vars.mem;
		alpha = vars.alpha;
		beta = vars.beta;
		t = vars.t;
		basis = vars.basis;

		M = pars.M;
		mu = pars.mu;

		kt = km_kernel(x,mem,ktype,kpar);
		y_est = kt*(alpha.*beta(length(alpha):-1:1));
		err = y-y_est;
		alpha = [alpha; mu*err];
		mem = [mem; x];
		basis = [basis; t]; 
		if length(alpha)>M
			alpha(1) = [];
			mem(1,:) = [];
			basis(1) = [];
		end
		
		vars.alpha = alpha;
		vars.mem = mem;
		vars.basis = basis;
		
		varout = vars;
end
