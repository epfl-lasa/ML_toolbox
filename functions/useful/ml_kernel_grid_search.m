function [ eigenvalues ] = ml_kernel_grid_search(X,options,kpars)
%ML_KERNEL_GRID_SEARCH 
%
%   input -----------------------------------------------------------------
%
%       o X           : (N x D),            original data N samples
%                                           dimension D.
%
%       o options     : struct,             same as for ml_projection.
%
%          
%       o kpars       : (1 x T) or (2 x T), depending on if you are use the
%                                           gaussina or polynomial kernel.
%
%   output ----------------------------------------------------------------
%
%       o eigenvalues : (M x T),             T eigenvalues of dimension M.
%
%
%
%


[m,T] = size(kpars);
disp(['num parameters: ' num2str(T)]);
disp(' ');

eigenvalues = [];

for t=1:T
    
    options.kpar = [];
    if m==1
        options.kpar(1)     = kpars(1,t);
    else
        options.kpar(1)     = kpars(1,t);
        options.kpar(2)     = kpars(2,t);
    end

    disp([num2str(t) '/' num2str(T)]);
    
    [~,mapping]             = ml_projection(X,options);
    eigenvalues = [eigenvalues;mapping.L(:)'];

end
disp(' ');


end

