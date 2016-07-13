function [ knn , p ] = GetkNNSet( x, statelist, k )


x     = repmat(x,size(statelist,1),1);

min_s = repmat(min(statelist),size(statelist,1),1);
max_s = repmat(max(statelist),size(statelist,1),1);

% observation and space normalization
x     =  2.0*( (x-min_s)./(max_s-min_s) )          - 1.0 ; 
space =  2.0*( (statelist-min_s)./(max_s-min_s) )  - 1.0 ; 

% get the indices of the k-nearest neighbords (knn) of x 
% in space with its corresppoding distances (d)
[d  knn] = sort(edist(space,x)); 
d        = d(1:k);
knn      = knn(1:k);

% normalize the values of p to obtain a probability distribution.
% I really dont care what you think about. This is my code and I can write
% whatever I like !!!.
p        = 1.0./(1.0 + d.^2);
p        = p./sum(p);
