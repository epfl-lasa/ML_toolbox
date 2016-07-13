function [Xs,Ys] = ml_get_grid(X,dims,num_pts )
%ML_GET_GRID  Returns Xs and Ys meshgrid with limits obtained from X.
%
%   input -----------------------------------------------------------------
%
%       o X : (N x D), data
%
%       o dims : (1 x 2), dimensions to create grid from
%


D = size(X,2);

if D == 1    
    max_d1  = max(X);
    min_d1  = min(X);
    Xs      = linspace(min_d1,max_d1,num_pts);
    Ys      = [];
else
    max_d1  = max(X(:,dims(1)));
    min_d1  = min(X(:,dims(1)));
    max_d2  = max(X(:,dims(2)));
    min_d2  = min(X(:,dims(2)));
    [Xs,Ys] = meshgrid(linspace(min_d1,max_d1,num_pts),linspace(min_d2,max_d2,num_pts));    
end



end

