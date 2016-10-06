function [labels,centroids,distance] = ml_kmeans_get_param(options)
%ML_KMEANS_GET_PARAM Extracts the k-means parameters from a structure
%
%   input -----------------------------------------------------------------
%
%       o options  : strcut
%
%           options.label
%           options.centroids
%           options.distance
%

if ~isfield(options,'labels')
   error('no labels parameter set'); 
else
    labels = options.labels;
end

if ~isfield(options,'centroids')
   error('no centroids parameter set'); 
else
    centroids = options.centroids;
end

if ~isfield(options,'distance')
   error('no distance parameter set'); 
else
    distance = options.distance;
end


end

