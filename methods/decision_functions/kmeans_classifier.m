function [ labels ] = kmeans_classifier(X,centroid,dist)
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

D           = ml_distfunc(X, centroid, dist);
[~, labels] = min(D, [], 2);


end

