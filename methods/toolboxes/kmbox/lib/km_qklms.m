function varout = km_qklms(vars,pars,x,y)
% KM_QKLMS implements the basic iteration of the Q-KLMS (quantized kernel
% LMS) algorithm.
%
% Input:	- vars: structure containing the used variables
%			- pars: structure containing kernel and algorithm parameters
%			- x: matrix containing input vectors as rows
%			- y: vector containing output values
% Output:	- out: contains the new vars if the algorithm is in learning
%			mode (when x and y are provided) and the estimated output when
%			the algorithm is being evaluated (when only x is given).
% Dependencies: km_kernel.
% USAGE: out = km_qklms(vars,pars,x,y)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2012
%
% The algorithm in this file is based on the following publication:
% Chen B., Zhao S., Zhu P., Principe J.C. "Quantized Kernel Least Mean 
% Square Algorithm," IEEE Transactions on Neural Networks and Learning 
% Systems, vol.23, no.1, Jan. 2012, pages 22-32.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

ktype = pars.kernel.type;
kpar = pars.kernel.par;

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
        mu = pars.mu;		% learning rate
        epsu = pars.epsu;
        
        % initialize algorithm
        mem = x;    % codebook
        basis = 1;
        y_est = 0;
        err = y-y_est;
        alpha = mu*err;
        epsf = sqrt(2-2*exp(-epsu^2/2/kpar^2));
               
        vars.alpha = alpha;
        vars.mem = mem;
        vars.basis = basis;
        vars.epsf = epsf;
        
        varout = vars;
    case 'eval'		% evaluate
        mem = vars.mem;
        alpha = vars.alpha;

        K = km_kernel(x,mem,ktype,kpar);
        y = K*alpha;
        
        varout = y;
    case 'train'		% train
        mem = vars.mem;
        alpha = vars.alpha;
        t = vars.t;
        basis = vars.basis;
        epsf = vars.epsf;
        
        mu = pars.mu;
        
        kt = km_kernel(x,mem,ktype,kpar);
        y_est = kt*alpha;
        err = y-y_est;
        % m = length(alpha);
        dists = sqrt(2-2*kt);
        [mm,j] = min(dists);

        if mm <= epsf, % ~if min(dists)<epsu when using a Gaussian kernel
            alpha(j) = alpha(j) + mu*err; % quantize datum to closest center
        else % add datum to memory (codebook)
            mem = [mem; x];
            alpha = [alpha; mu*err];
            basis = [basis;t];
        end
        
        vars.alpha = alpha;
        vars.mem = mem;
        vars.basis = basis;
        
        varout = vars;
end
