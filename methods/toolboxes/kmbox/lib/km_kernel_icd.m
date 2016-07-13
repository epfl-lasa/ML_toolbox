function [G,subset] = km_kernel_icd(X,ktype,kpar,m,precision)
% KM_KERNEL_ICD approximates a kernel matrix using incomplete Cholesky
% decomposition (ICD).
% Input:	- X: data matrix in row format (each data point is a row)
%			- ktype: string representing kernel type.
%			- kpar: vector containing the kernel parameters.
%			- m: maximal rank of solution
%			- precision: accuracy parameter of the ICD method
% Output:	- G: "narrow tall" matrix of the decomposition K ~= GG'
%			- subset: indices of data selected for low-rank approximation
% Dependencies: km_kernel.
% USAGE: G = km_kernel_icd(X,ktype,kpar,m,precision)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
% Based on code by Sohan Seth (sohan *at* cnel.ufl.edu), 2009.
%
% The algorithm in this file is based on the following publication:
% Francis R. Bach, Michael I. Jordan. "Kernel Independent Component
% Analysis", Journal of Machine Learning Research, 3, 1-48, 2002.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

n = size(X,1);
if nargin<5
	precision = 10^-6;
end
if nargin<4
	m = n;
end

perm = 1:n;		% permutation vector
d = zeros(1,n);	% diagonal of the residual kernel matrix
G = zeros(n,m);
subset = zeros(1,m);
for i = 1:m,	% column index
	x = X(perm(i:n),:);
	if i == 1
		% diagonal of kernel matrix
		d(i:n) = km_kernel(x,x,[ktype '-diag'],kpar)';
	else
		% update the diagonal of the residual kernel matrix
		d(i:n) = km_kernel(x,x,[ktype '-diag'],kpar)' - sum(G(i:n,1:i-1).^2,2)';
	end
	dtrace = sum(d(i:n));
	
	if  dtrace <= 0
		warning('Negative diagonal entry %f', dtrace); %#ok<WNTAG>
	end
	
	if  dtrace <= precision
		G(:,i:end) = [];
		subset(i:end) = [];
		break
	end
	[m2,j] = max(d(i:n));	% find the new best element
	j = j+i-1;	% take into account the offset i
	m1 = sqrt(m2);
	subset(i) = j;
	
	perm([i j]) = perm([j i]);	% permute elements i and j
	G([i j],1:i-1) = G([j i],1:i-1);	% permute rows i and j
	G(i,i) = m1;	% new diagonal element
	
	G(i+1:n,i) = (km_kernel(X(perm(i),:),X(perm(i+1:n),:),ktype,kpar)'...
		- G(i+1:n,1:i-1)*G(i,1:i-1)')/m1;	% Calculate the i-th column. May 
		% introduce a slight numerical error compared to explicit calculation.
end

[ps,ind] = sort(perm,'ascend'); %#ok<ASGLU>
G = G(ind,:);	% undo permutation
