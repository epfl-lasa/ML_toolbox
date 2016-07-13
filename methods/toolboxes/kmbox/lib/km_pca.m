function [E,v,Xp] = km_pca(X,m)
% KM_PCA calculates the principal directions and principal components of a 
% data set X.
% Input:	- X: data matrix in row format (each data point is a row)
%			- m: the number of principal components to return. If m is 
%			smaller than 1, it is interpreted as the fraction of the signal
%			energy that is to be contained within the returned principal
%			components.
% Output:	- E: matrix containing the principal directions.
%			- v: array containing the eigenvalues.
%			- Xp: matrix containing the principal components
% USAGE: [E,v,Xp] = km_pca(X,m)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

N = size(X,1);
[E,V] = eig(X'*X/N);

v = diag(V);
[v,ind] = sort(v,'descend');
E = E(:,ind);

Xp = X*E(:,1:m);
