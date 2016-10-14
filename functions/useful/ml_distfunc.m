function D = ml_distfunc(X, C, dist)
%ML_DISTFUNC COPIED from the kmeans distfunc
%DISTFUN Calculate point to cluster centroid distances.
%
%
%   output ----------------------------------------------------------------
%
%       o D : (N x |C|), distance between a point with every cluster
%
%               - D(i,:), distance between point i and all cluster centers
%                         C.
%            
%


[n,p]       = size(X);
D           = zeros(n,size(C,1));
nclusts     = size(C,1);

switch dist        
    case 'sqeuclidean'
        for i = 1:nclusts
            D(:,i) = (X(:,1) - C(i,1)).^2;
            for j = 2:p
                D(:,i) = D(:,i) + (X(:,j) - C(i,j)).^2;
            end
        end
    case 'cityblock'
        for i = 1:nclusts
            D(:,i) = abs(X(:,1) - C(i,1));
            for j = 2:p
                D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
            end
        end
    case {'cosine','correlation'}
        normC = sqrt(sum(C.^2, 2));
        for i = 1:nclusts
            D(:,i) = max(1 - X * (C(i,:)./normC(i))', 0);
        end
    case 'hamming'
        for i = 1:nclusts
            D(:,i) = abs(X(:,1) - C(i,1));
            for j = 2:p
                D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
            end
            D(:,i) = D(:,i) / p;
        end
end

end

