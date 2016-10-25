function misclassified = ml_get_misclassified(X,labels, f, options)
%ML_GET_MISCLASSIFIED 
%
%   input -----------------------------------------------------------------
%
%       o  X        : (N x D), dataset of N datapoints of dimension D.
%
%       o labels    : (N x 1), ground truth class labels. 
%
%       o f         : function handle, classifier f.
%               
%               - y = f(X); y are predicted class labels.
%
%   output ----------------------------------------------------------------       
%
%       o misclassified : struct,
%
%           - misclassified.index :     indicies of data points X which have
%                                       been misclassified.
%
%           - misclassified.predicted: the predicted class label (which was wrong).
%
%           - misclassified.truth:     class label which should have been
%                                      predicted.


class_id        = unique(labels);
num_classes     = length(class_id);
M               = zeros(num_classes,num_classes);
dim_swaped      = false; %false: (MXD) , true: (DXM)
if isfield(options,'dim_swaped'),       dim_swaped   = options.dim_swaped;   end

% predicted class label
if dim_swaped
    hc          = f(X');
else
    hc          = f(X);
end

% entries which are 0, mean they where correctly classified, otherwise not.
tmp         = hc(:) - labels(:);
idx         = find(tmp ~= 0);

misclassified.idx           = idx;
misclassified.predicted     = hc(idx);
misclassified.truth         = labels(idx);

end

