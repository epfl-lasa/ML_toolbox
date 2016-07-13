function [A,P,R,F] = ml_confusion_matrix_evaluation(M)
%ML_EVALUATION  Computes the accuracy of your classifier, requires the
%               confusion matrix.
%
%   input -----------------------------------------------------------------
%
%       o M : (num_class x num_class), confusion matrix
%
%   output ----------------------------------------------------------------    
%   
%       o P : (num_class x 1) : precision for each class
%       
%       o R : (num_class x 1) : recall for each class
%
%       o F : (num_class x 1) : F1 score for each class
%
%       o A : (1 x 1)         : overall accuracy


num_classes = size(M,1);
P           = zeros(num_classes,1);
R           = zeros(num_classes,1);

% M(i,i) number of elements of class i, classified as class i
% M(i,j) number of elements of class i, classified as class j
% M(j,i) number of elements of class j, classified as class i

for i=1:num_classes
   P(i) = M(i,i) / (sum(M(:,i)) + realmin); 
   R(i) = M(i,i) / (sum(M(i,:)) + realmin);
end

F = (P .* R) ./ (P + R + realmin);

% accuracy: the sum of correct classifications divided by the total number
%           of classifications
A = sum(diag(M))/(sum(M(:)) + realmin);



end

