function [ b_labels ] = ml_2binary(labels)
%ML_2BINARY Transforms class labels to binary {-1,+1} class consisting of
%positive and negative class labels. This is needed for instance for binary
% class adaboost
%
%   input -----------------------------------------------------------------
%
%       o labels    : (N x 1), set of N labels with K classes
%
%   ouput -----------------------------------------------------------------
%
%       o b_lables  : (N x 1), set of N binary lables {-1,+1}     
%
%

% find unique labels

N        = size(labels(:),1);
classes  = unique(labels);
b_lables = zeros(N,1);

if length(classes) == 2
   
    b_labels(labels == classes(1)) = -1;
    b_labels(labels == classes(2)) =  1;
    
else
    error('not yet implemented');
    
    
end





end

