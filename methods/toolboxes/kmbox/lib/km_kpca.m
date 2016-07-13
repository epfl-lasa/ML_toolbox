function [E,v] = km_kpca(X,m,ktype,kpar)
% KM_KPCA performs kernel principal component analysis (KPCA) on a data set
% X.
% Input:	- X: data matrix in column format (each data point is a row)
%			- m: the number of principal components to return. If m is 
%			smaller than 1, it is interpreted as the fraction of the signal
%			energy that is to be contained within the returned principal
%			components.
%			- ktype: string representing kernel type.
%			- kpar: vector containing the kernel parameters.
% Output:	- E: matrix containing the principal components.
%			- v: array containing the eigenvalues.
%			- Xep: projections of Xe on principal directions
% USAGE: [E,v] = km_kpca(X,m,ktype,kpar)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

n = size(X,1);

K = km_kernel(X,X,ktype,kpar);
[E,V] = eig(K);
v = diag(V);	% eigenvalues
[v,ind] = sort(v,'descend');
v = v(1:m);
E = E(:,ind(1:m));	% principal components
for i=1:m
	E(:,i) = E(:,i)/sqrt(n*v(i));	% normalization
end
