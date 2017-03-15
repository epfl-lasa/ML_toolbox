function M = ml_confusion_matrix(X,labels,f)
%ML_CONFUSION_MATRIX 
%
%   input -----------------------------------------------------------------
%   
%       o X      :   (N x D), dataset of N samples and D dimensions
%
%       o labels :   (N x 1), ground truth 
%
%       o f      : function handle, the decision/classifier function
%                   
%                    f(X) = (N x 1), return a set of predicted class labels
%                     y = f(X) 
%
%   
%   output .---------------------------------------------------------------
%
%       o M      : (num_classes x num_classes) , confusion matrix   
%

class_id    = unique(labels);
num_classes = length(class_id);
M           = zeros(num_classes,num_classes);
% predicted class label
hc          = f(X);
tmp         = [labels(:),hc(:)];


for i=1:num_classes
   for j=1:num_classes
       % find how many data points of class i where classified as class j        
       M(i,j) = sum(ismember(tmp,[class_id(i),class_id(j)],'rows'));       
   end
end


end

