function [one_in_K,mapping] = ml_labels2Kencoding( labels )
%ML_LABELS2KENCODING Takes class label data and transforms it to one in K
% encoding.
%
%   input -----------------------------------------------------------------
%
%       o lables : (N x 1), class labels.
%
%   output ----------------------------------------------------------------
%
%       o one_in_K : (N x K), one-in-K encoding of classes
%
%       o mapping  : (num_classes x 1)
%
%

labels      = labels(:);
N           = size(labels,1);
class_label = unique(labels);
num_classes = length(class_label);
mapping     = zeros(num_classes,1);
one_in_K    = zeros(N,num_classes);

for i=1:num_classes
    mapping(i)                           = class_label(i);
    one_in_K(class_label(i) == labels,i) = 1;
end


end

