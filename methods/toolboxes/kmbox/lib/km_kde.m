function [x,y] = km_kde(data,sigma,nsteps,range_x)
% KM_KDE performs kernel density estimation (KDE) on one-dimensional data
% http://en.wikipedia.org/wiki/Kernel_density_estimation
% 
% Input:	- data: input data, one-dimensional
%           - sigma: bandwidth (sometimes called "h")
%           - nsteps: optional number of abscis points. If nsteps is an
%             array, the abscis points will be taken directly from it.
%           - range_x: optional factor for abscis expansion beyond extrema
% Output:	- x: equispaced abscis points
%			- y: estimates of p(x)
% USAGE: [xx,pp] = km_kde(data,sigma,nsteps,range_x)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

N = length(data);	% number of data points

if (nargin<4), range_x = 1; end % default abscis expansion
if (nargin<3), nsteps = 100; end % default number of abscis points

% obtain full data range + extra bit
mm(1) = min(data);
mm(2) = max(data);
if length(nsteps) > 1
    x = nsteps;
else
    xm = range_x*mm;
    if (mm(1)>0), xm(1)=mm(1)/range_x; end
    if (mm(2)<0), xm(2)=mm(2)/range_x; end
    x = linspace(xm(1),xm(2),nsteps);
end
y = zeros(size(x));

% kernel density estimation
c = 1/sqrt(2*pi*sigma^2);
for i=1:N,
	y = y + 1/N*c*exp(-(data(i)-x).^2/(2*sigma^2));
end
