function K_nomean = km_kernel_center(X1,X2,Xm,ktype,par)
% KM_KERNEL_CENTER calculates a centered kernel matrix.
% Input:	- X1, X2: data matrices corresponding to data to be centered 
%             (each data vector is a rows)
%           - Xm: data matrix whose mean is to be removed from the kernel
%             matrix.
%			- ktype: string representing kernel type
%			- kpar: vector containing the kernel parameters
% Output:	- K: the kernel matrix after removing the mean of Xm
% USAGE: K = km_kernel(X1,X2,ktype,kpar)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2007.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

N1 = size(X1,1);
N2 = size(X2,1);
N = size(Xm,1);

W1 = ones(N1,N);
W2 = ones(N2,N);

K12 = km_kernel(X1,X2,ktype,par);
K1 = km_kernel(X1,Xm,ktype,par);
K2 = km_kernel(X2,Xm,ktype,par);
K = km_kernel(Xm,Xm,ktype,par);

K_nomean = K12 - 1/N*W1*K2' - 1/N*K1*W2' + 1/N^2*W1*K*W2';
