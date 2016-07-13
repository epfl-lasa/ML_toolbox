function [ eigenvalues ] = ml_kernel_lap_grid_search(X,options,kernelWidth)
%ML_KERNEL_LAP_GRID_SEARCH 
%
%   input -----------------------------------------------------------------
%
%       o X           : (N x D),            original data N samples
%                                           dimension D.
%
%       o options     : struct,             same as for ml_projection.
%
%          
%       o kerneklWidth       : (1 x T),        kernel width parameters.
%
%   output ----------------------------------------------------------------
%
%       o eigenvalues : (M x T),             T eigenvalues of dimension M.
%
%
%
%


[~,T] = size(kernelWidth);
disp(['num parameters: ' num2str(T)]);
disp(' ');

eigenvalues = [];

for t=1:T
    
    options.sigma = kernelWidth(t);

    disp([num2str(t) '/' num2str(T)]);
    
    [~,mapping]             = ml_projection(X,options);
    
    eigenvalues = [eigenvalues;mapping.val(:)'];

end
disp(' ');


end