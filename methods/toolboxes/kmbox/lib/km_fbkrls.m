function out = km_fbkrls(vars,pars,x,y)
% KM_FBKRLS implements the basic iteration of the fixed-budget kernel 
% recursive least-squares (FB-KRLS) algorithm.
% Input:	- vars: structure containing the used variables
%			- pars: structure containing kernel and algorithm parameters
%			- x: matrix containing input vectors as rows
%			- y: vector containing output values
% Output:	- out: contains the new vars if the algorithm is in learning 
%			mode (when x and y are provided) and the estimated output when 
%			the algorithm is being evaluated (when only x is given).
% Dependencies: km_kernel.
% USAGE: out = km_fbkrls(vars,pars,x,y)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% The algorithm in this file is based on the following publication:
% S. Van Vaerenbergh, I. Santamaria, W. Liu and J. C. Principe, "Fixed-
% Budget Kernel Recursive Least-Squares", 2010 IEEE International 
% Conference on Acoustics, Speech, and Signal Processing (ICASSP 2010), 
% Dallas, Texas, U.S.A., March 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

ktype = pars.kernel.type;
kpar = pars.kernel.par;
M = pars.M;
c = pars.c;	% regularization constant

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
		mem = x;
		basis = 1;
		ymem = y;
		knn = km_kernel(mem,x,ktype,kpar) + c;
		K_inv = 1/knn;
		alpha = K_inv*ymem;
		
		vars.mem = mem;
		vars.basis = basis;
		vars.ymem = y;
		vars.K_inv = K_inv;
		vars.alpha = alpha;
		
		out = vars;
	case 'eval'		% evaluate
		mem = vars.mem;
		alpha = vars.alpha;
		
		K = km_kernel(x,mem,ktype,kpar);
		y = K*alpha;
		
		out = y;
	case 'train'		% train
		mem = vars.mem;
		ymem = vars.ymem;
		K_inv = vars.K_inv;
		basis = vars.basis;
		t = vars.t;
		
		mu = pars.mu;	% label update learning rate -- experimental!

		kt = km_kernel(mem,x,ktype,kpar);
		ktt = km_kernel(x,x,ktype,kpar) + c;
		
		% update all stored labels
		label_err = y - ymem;
		ymem = ymem + mu*kt.*label_err;

		% expand dictionary
		mem = [mem; x];	% x should contain only one sample (column)
		ymem = [ymem; y];	% store subset labels
		basis = [basis t];
		
		K_inv = inverse_addrowcol(kt,ktt,K_inv);	% extend kernel matrix
		alpha = K_inv*ymem;
		
		if (size(mem,1)>M)
			% prune dictionary
			err_ap = abs(alpha)./diag(K_inv);
			[mm,discard_ind] = min(err_ap); %#ok<ASGLU>

			mem(discard_ind,:) = [];
			ymem(discard_ind) = [];
			basis(discard_ind) = [];
			
			K_inv = prune_mat(K_inv,discard_ind);
		end
		alpha = K_inv*ymem;
		
		vars.K_inv = K_inv;
		vars.alpha = alpha;
		vars.mem = mem;
		vars.ymem = ymem;
		vars.basis = basis;
			
		out = vars;
end

function K_inv = inverse_addrowcol(b,d,A_inv)
% returns the inverse matrix of K = [A b;b' d]
% http://squobble.com/academic/publications/kRLS/node15.html

g_inv = d - b'*A_inv*b;
g = 1/g_inv;
f = -A_inv*b*g;
% I = eye(size(A,1));
% E = A_inv*(I-b*f');
E = A_inv - A_inv*b*f';

K_inv = [E f;f' g];

function K_inv = prune_mat(K_inv,p)
% return the inverse of a matrix whose p'th row and column are removed,
% given the original reverse

ip = 1:size(K_inv,1);
ip(p) = [];		% remove p'th element
ip = [p ip];	% put p'th element in front
K_inv = inverse_remove1strowcol(K_inv(ip,ip));	% inverse of new kernel matrices

function D_inv = inverse_remove1strowcol(K_inv)
% calculates the inverse of D given K_inv = [a b';b D]^-1
% http://squobble.com/academic/publications/kRLS/node16.html

N = size(K_inv,1);

G = K_inv(2:N,2:N);
f = K_inv(2:N,1);
e = K_inv(1,1);

D_inv = G - f*f'/e;
