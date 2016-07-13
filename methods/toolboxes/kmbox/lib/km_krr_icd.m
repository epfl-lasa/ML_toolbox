function [alpha,Y2,subset] = km_krr_icd(X,Y,ktype,kpar,m,X2)
% KM_KRR performs kernel ridge regression (KRR) on a data set by using the
% incomplete Cholesky decomposition and returns the regressor weights.
% Input:  - X, Y: input and output data matrices for learning the
%         regression. Each data point is stored as a row.
%         - ktype: string representing kernel type.
%         - kpar: vector containing the kernel parameters.
%         - m: maximal rank of decomposition
%         - X2 (optional): additional input data set for which regression
%         outputs are returned.
% Output:  - alpha: regression weights
%          - Y2: outputs of the regression corresponding to inputs X2. If
%          X2 is not provided, Y2 is the regressor output of input data X.
%         - subset: indices of data selected for low-rank approximation
% Dependencies: km_kernel.
% USAGE: [alpha,Y2,subset] = km_krr_icd(X,Y,ktype,kpar,m,X2)
%
% Author: Agamemnon Krasoulis, 2014
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

if (nargin<6)
    X2 = X;
end

[~, subset] = km_kernel_icd(X, ktype, kpar, m, 1E-6);
K = km_kernel(X,X(subset,:),ktype,kpar);
alpha = K\Y;

K2 = km_kernel(X2,X(subset,:),ktype,kpar);
Y2 = K2*alpha;
