function [ labels ] = kernelkmeans_classifier(XGrid,X,centroid,eigens,kernel,kpar)
%KMEANS_CLASSIFIER K-means classifier
%
%  input ------------------------------------------------------------------
%
%       o X          : (N x D), data to classifiy
%
%       o centroids  : (L x D), L centroids
%
%       o dist       : string, distance metric 
%   
%   output-----------------------------------------------------------------
%
%       o labels     : (N x 1), class labels
%
%

KnGrid         = gram(XGrid,X,kernel,kpar(1),kpar(2));
KnGrid         = KnGrid * eigens;
HGrid          = KnGrid ./ repmat(sqrt(sum(KnGrid.^2, 2)), 1, size(eigens,2));

D           = ml_distfunc(HGrid, centroid, 'sqeuclidean');
[~, labels] = min(D, [], 2);



end

