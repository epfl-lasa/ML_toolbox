function [alpha,h,J] = km_kiham(x,z,xdict,L,kerneltype,kernelpar,ca,ch,...
    it_max,J_stop)
% Kernel-based identification of Hammerstein systems (KIHAM) with FIR
% linear part. This implementation relies on a user-defined dictionary to
% reduce the complexity.
%
% INPUTS
%   - x: system input vector, Nx1
%   - z: system output vector, Nx1
%   - xdict: vector with dictionary, mx1
%   - L: FIR channel length
%   - kerneltype: kernel type
%   - kernelpar: kernel parameters
%   - ca: regularization coefficient for alpha coefficients
%   - ch: regularization coefficient for h coefficients
%   - it_max: maximum iterations to perform
%   - J_stop: difference in cost to trigger stop criterion
% OUTPUT:
%	alpha: kernel expansion coefficients
%   h: linear channel coefficients
%   J: vector with cost in each iteration
% USAGE: [alpha,h,J] = km_kiham(x,z,xdict,L,kerneltype,kernelpar,ca,ch,...
%    it_max,J_stop)
%
% Dependencies: kernel_matrix.m
%
% Author: Steven Van Vaerenbergh, 2014
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox
%
% The algorithm in this file is based on the following publication:
% S. Van Vaerenbergh and L. A. Azpicueta-Ruiz, "Kernel-Based Identification
% of Hammerstein Systems for Nonlinear Acoustic Echo-Cancellation", 2014
% IEEE International Conference on Acoustics, Speech, and Signal Processing
% (ICASSP), Florence, Italy, May 2014.

K = km_kernel(x,xdict,kerneltype,kernelpar);
Kd = km_kernel(xdict,xdict,kerneltype,kernelpar);
m = size(xdict,1);
N = length(x);

%% INIT: LS regression to get h
x_mem = km_memfill(x,L);
Rx = x_mem'*x_mem;
P = x_mem'*z;
h = (Rx+ch*eye(L))\P;
h = h/norm(h);

%% ITERATE

J = [];
it = 0;
converged = false;
while ((it < it_max) && ~converged)
    fprintf('.')
    it = it+1;
    
    % update alpha
    Kh = zeros(size(K));
    for i=1:m,
        Kimem = km_memfill(K(:,i),L);
        Kh(:,i) = Kimem*h;
    end
    
    Rhx = Kh'*Kh;
    Ph = Kh'*z;
    alpha = (Rhx+ca*Kd)\Ph;
    
    % update h
    Ka = K*alpha;
    Kamem = km_memfill(Ka, L);
    
    Rax = Kamem'*Kamem;
    Pa = Kamem'*z;
    h = (Rax+ch*eye(L))\Pa;
    h = h/norm(h);
    
    % calculate LS cost
    z_est = Kamem*h;
    J(it) = sum((z-z_est).^2)/N; %#ok<AGROW>
    
    if (it>1)
        converged = (J(it-1)-J(it)) < J_stop;
    end
end
fprintf('\n');
