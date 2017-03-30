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

% Test samples have only 1 class
if size(M)==1
    warning('Test samples have only 1 class!')
    M_ = zeros(2,2);
    if class_id ==1
        M_(1,1) = M;
    elseif class_id < 1
        M_(2,2) = M;
    end
    M = M_;
end

end

