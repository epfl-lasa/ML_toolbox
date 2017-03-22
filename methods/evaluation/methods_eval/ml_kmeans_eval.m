function [rss,bic,aic ] = ml_kmeans_eval(X,labels,C,dist,lambda)
%ML_KMEANS_EVAL 
%
%   input ----------------------------------------------------------------
%
%       o   X    :   (N x D), dataset of N samples of dimension D.
%
%       o labels :   (N x 1), class labels 
%
%       o   C    :   (K x D), K centroids of dimension D.
%
%       o dist   :   string,  distance metric used.
%
%       o lambda :   (1 x 1), regulariser for AIC
%
%   output ----------------------------------------------------------------
%
%       o rss   :   (1 x 1), residual sum of squares
%
%       o aic   :   (1 x 1), Akaike information criteria
%
%       o bic   :   (1 x 1), Bayesian information criterion 
%
%   info ------------------------------------------------------------------
%
%   http://nlp.stanford.edu/IR-book/html/htmledition/cluster-cardinality-in-k-means-1.html
%

N       = size(X,1);
[K,D]   = size(C);

if ~exist('lambda','var'),lambda = 2; end

% compute RSS
rss       = 0;    
for k=1:K   
    idx     = k==labels;
    rss     = rss + sum(sqrt(ml_distfunc(X(idx,:), C(k,:), dist)).^2);
end

aic = ml_aic(-0.5*rss,D * K,lambda);
bic = ml_bic(-0.5*rss,D * K,N);

end

