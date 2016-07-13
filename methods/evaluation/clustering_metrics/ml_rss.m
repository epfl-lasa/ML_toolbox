function [ rss ] = ml_rss(X,labels,C,dist)
%ML_RSS Summary Residual sum of squares
%
%   input -----------------------------------------------------------------
%
%       o X      :  (N x D), dataset of N samples and dimension D.
%
%       o labels :  (N x 1), class assignment of each point X. 
%
%       o dist   :  string, distance metrix default is norm-2
%
%   output ----------------------------------------------------------------
%
%       o rss    : (1 x 1), residual sum of squares
%
%


num_class = size(C,1);
rss       = 0;    


for k=1:num_class   
    idx     = k==labels;
    rss     = rss + sum(ml_distfunc(X(idx,:), C(k,:), dist));
    
end
    


end

