function [ eigenvalues ] = ml_neighbors_grid_search(X,options,neighbors)
%ML_NEIGHBORS_GRID_SEARCH 
%
%   input -----------------------------------------------------------------
%
%       o X           : (N x D),            original data N samples
%                                           dimension D.
%
%       o options     : struct,             same as for ml_projection.
%
%          
%       o neighbors      : (1 x T),         neighbors parameters   
%
%   output ----------------------------------------------------------------
%
%       o eigenvalues : (M x T),             T eigenvalues of dimension M.
%
%
%
%


[~,T] = size(neighbors);
disp(['num parameters: ' num2str(T)]);
disp(' ');

eigenvalues = [];

for t=1:T
    
    options.neighbors = neighbors(t);

    disp([num2str(t) '/' num2str(T)]);
    
    [~,mapping]             = ml_projection(X,options);
    
    eigenvalues = [eigenvalues;mapping.val(:)'];

end
disp(' ');


end