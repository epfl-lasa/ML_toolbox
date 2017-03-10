function [kernel,kpar] = sanitise_kernel_input(options)
%SANITISE_KERENL_INPUT Check if the kernel name exists [this is for the 
% kmbox toolbox kernel.
%
%
%   input -----------------------------------------------------------------
%
%       o options :     structure,
%

%% Check if the appropriate fields are set
if ~isfield(options,'kernel')
   error('you have to specify options.kernel = [name of the kernel]'); 
end
if ~isfield(options,'kpar')
   error('you have to specify options.kpar , the parameters of the kernel'); 
end

%% Check if the kernel name is supported

switch options.kernel
	case 'gauss'	% Gaussian kernel
	case 'gauss-diag'	% only diagonal of Gaussian kernel
	case 'poly'	% polynomial kernel
	case 'linear' % linear kernel
	otherwise	% default case
        error(['no such kernel type [' options.kernel ']! the values can be [gauss, gauss-diag, poly, linear]!']);
end

%% Check if the kernel parameters chosen make are fine.

kernelTemp = options.kernel;
kparTemp   = options.kpar;

switch kernelTemp
	case 'gauss'	% Gaussian kernel
        if(length(kparTemp) ~=1)
            error('You have chosen a Gaussian kernel, the kpar should contain a single scalar value; the variance');
        end
        kparTemp(2) = 0;
	case 'gauss-diag'	% only diagonal of Gaussian kernel
        if(length(kparTemp) ~=1)
            error('You have chosen a Gaussian kernel, the kpar should contain a single scalar value; the variance');
        end
        kparTemp(2) = 0;
	case 'poly'	% polynomial kernel
        if(length(kparTemp) ~=2)
            error('You have chosen a Polynomial kernel, the kpar should be a vector of size 2!	p = kpar(1); c = kpar(2);');
        end
	otherwise	% default case
        error(['no such kernel type [' options.kernel ']! the values can be [gauss, gauss-diag, poly, linear]!']);
end

%% If this line is reached all should be good 

kernel = kernelTemp;
kpar   = kparTemp;

end

