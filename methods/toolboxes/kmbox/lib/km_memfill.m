function x_mem = km_memfill(x,L)
% KM_MEMFILL buffers a signal vector into a matrix of data frames
% Input:  - x: data vector
%         - L: number of frames
% Output: - x_mem: matrix of buffered data frames
% USAGE: x_mem = km_memfill(x,L)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2015.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

N = length(x);

x_mem = zeros(N,L);
for i=1:L,
    x_mem(i:N,i) = x(1:N-i+1);
end
