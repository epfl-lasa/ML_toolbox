function [alpha,Y2] = km_krr(X,Y,ktype,kpar,c,X2)
% KM_KRR performs kernel ridge regression (KRR) on a data set and returns 
% the regressor weights.
% Input:	- X, Y: input and output data matrices for learning the
%			regression. Each data point is stored as a row.
%			- ktype: string representing kernel type.
%			- kpar: vector containing the kernel parameters.
%			- c: regularization constant.
%			- X2 (optional): additional input data set for which regression
%			outputs are returned.
% Output:	- alpha: regression weights
%			- Y2: outputs of the regression corresponding to inputs X2. If
%			X2 is not provided, Y2 is the regressor output of input data X.
% Dependencies: km_kernel.
% USAGE: [alpha,Y2] = km_krr(X,Y,ktype,kpar,c,X2)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

if (nargin<6)
	X2 = X;
end

N = size(X,1);
I = eye(N);

K = km_kernel(X,X,ktype,kpar);
alpha = (K+c*I)\Y;

K2 = km_kernel(X2,X,ktype,kpar);
Y2 = K2*alpha;
