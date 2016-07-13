function out = km_aldkrls(vars,pars,x,y)
% KM_ALDKRLS implements the basic iteration of the kernel recursive least-
% squares (KRLS) algorithm with approximate linear dependency (ALD) novelty
% criterion.
% Input:	- vars: structure containing the used variables
%			- pars: structure containing kernel and algorithm parameters
%			- x: matrix containing input vectors as rows
%			- y: vector containing output values
% Output:	- out: contains the new vars if the algorithm is in learning 
%			mode (when x and y are provided) and the estimated output when 
%			the algorithm is being evaluated (when only x is given).
% Dependencies: km_kernel.
% USAGE: out = km_aldkrls(vars,pars,x,y)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% The algorithm in this file is based on the following publication:
% Y. Engel, S. Mannor, and R. Meir. "The kernel recursive least-squares
% algorithm", IEEE Transactions on Signal Processing, volume 52, no. 8,
% pages 2275–2285, 2004.
%
% This implementation includes a slight modification: inclusion of a
% maximum dictionary size "M".
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

ktype = pars.kernel.type;
kpar = pars.kernel.par;
thresh = pars.thresh;	% ALD threshold
if (isfield(pars,'M'))
	M = pars.M;	% maximal dictionary length
else
	M = Inf;	% ever-growing
end

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
		% initialize algorithm
		mem = x;
		basis = 1;
		P = 1;
		ktt = km_kernel(x,x,ktype,kpar);
		K_inv = 1/ktt;
		alpha = y*K_inv;
		
		vars.K_inv = K_inv;
		vars.alpha = alpha;
		vars.mem = mem;
		vars.basis = basis;
		vars.P = P;
		out = vars;
	case 'eval'		% evaluate
		mem = vars.mem;
		alpha = vars.alpha;

		K = km_kernel(x,mem,ktype,kpar);
		y = K*alpha;
		
		out = y;
	case 'train'		% train
		mem = vars.mem;
		alpha = vars.alpha;
		K_inv = vars.K_inv;
		P = vars.P;
		t = vars.t;		% temporal index
		basis = vars.basis;
		
		ktt = km_kernel(x,x,ktype,kpar);
		
		kt = km_kernel(mem,x,ktype,kpar);
		a_opt = K_inv*kt;
		delta = ktt - kt'*a_opt;
		if (delta>thresh && size(mem,1)<M)	% expand dictionary ("full update")
			K_inv = 1/delta*[delta*K_inv + a_opt*a_opt', -a_opt; -a_opt', 1];
			Z = zeros(size(P,1),1);
			P = [P Z; Z' 1];
			ode = 1/delta*(y-kt'*alpha);
			alpha = [alpha - a_opt*ode; ode];
			mem = [mem; x];
			basis = [basis; t]; 
		else	% only update alpha ("reduced update")
			q = P*a_opt/(1+a_opt'*P*a_opt);
			P = P - q*(a_opt'*P);
			alpha = alpha + K_inv*q*(y-kt'*alpha);
		end
		
		vars.K_inv = K_inv;
		vars.alpha = alpha;
		vars.mem = mem;
		vars.P = P;
		vars.basis = basis;
		
		out = vars;
end
