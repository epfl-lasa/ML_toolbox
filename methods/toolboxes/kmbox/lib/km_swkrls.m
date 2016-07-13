function out = km_swkrls(vars,pars,x,y)
% KM_SWKRLS implements the basic iteration of the sliding-window kernel 
% recursive least-squares (SW-KRLS) algorithm.
% Input:	- vars: structure containing the used variables
%			- pars: structure containing kernel and algorithm parameters
%			- x: matrix containing input vectors as rows
%			- y: vector containing output values
% Output:	- out: contains the new vars if the algorithm is in learning 
%			mode (when x and y are provided) and the estimated output when 
%			the algorithm is being evaluated (when only x is given).
% Dependencies: km_kernel.
% USAGE: out = km_swkrls(vars,pars,x,y)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2011
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox
%
% The algorithm in this file is based on the following publication:
% S. Van Vaerenbergh, J. Via, and I. Santamaria. "A sliding-window kernel 
% RLS algorithm and its application to nonlinear channel identification", 
% 2006 IEEE International Conference on Acoustics, Speech, and Signal 
% Processing (ICASSP), Toulouse, France, 2006.

ktype = pars.kernel.type;
kpar = pars.kernel.par;
len = pars.M;
reg = pars.c;	% regularization constant

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
		knn = km_kernel(mem,x,ktype,kpar) + reg;
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
		
		K = km_kernel(x,mem,ktype,kpar);	% could be sped up
		y = K*alpha;
		
		out = y;
	case 'train'		% train
		mem = vars.mem;
		ymem = vars.ymem;
		K_inv = vars.K_inv;
		basis = vars.basis;
		t = vars.t;
		
		% expand dictionary
		mem = [mem; x];	% x should contain only one sample (column)
		ymem = [ymem; y];	% store subset labels
		basis = [basis t];
		
		k = km_kernel(mem,x,ktype,kpar);
		kn = k(1:size(mem,1)-1);
		knn = k(end) + reg;
		K_inv = inverse_addrowcol(kn,knn,K_inv);	% extend kernel matrix
		
		if (size(mem,1)>len)
			% prune dictionary
			mem(1,:) = [];
			ymem(1) = [];
			K_inv = inverse_removerowcol(K_inv);
			basis(1) = [];
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
% http://www.squobble.com/academic/swkrls/node15.html

g_inv = d - b'*A_inv*b;
g = 1/g_inv;
f = -A_inv*b*g;
% I = eye(size(A,1));
% E = A_inv*(I-b*f');
E = A_inv - A_inv*b*f';

K_inv = [E f;f' g];

function D_inv = inverse_removerowcol(K_inv)
% calculates the inverse of D with K = [a b';b D]
% http://www.squobble.com/academic/swkrls/node16.html

N = size(K_inv,1);

G = K_inv(2:N,2:N);
f = K_inv(2:N,1);
e = K_inv(1,1);

D_inv = G - f*f'/e;
