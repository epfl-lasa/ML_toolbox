function [A,P,R,F, FPR, TNR] = ml_confusion_matrix_evaluation(M)
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
%
%       o FPR : (1 x 1)       : False Positive Rate (Fall-out)
%
%       o TNR : (1 x 1)       : True Negative Rate (Specificity)

num_classes = size(M,1);
P           = zeros(num_classes,1);
R           = zeros(num_classes,1);

% M(i,i) number of elements of class i, classified as class i
% M(i,j) number of elements of class i, classified as class j
% M(j,i) number of elements of class j, classified as class i

% Precision and Recall
for i=1:num_classes
   P(i) = M(i,i) / (sum(M(:,i)) + realmin); 
   R(i) = M(i,i) / (sum(M(i,:)) + realmin);
end

% F1-Score: Harmonic Mean of Precision and Recall
% F = 2 .* (P .* R) ./ (P + R + realmin);

% Accuracy: the sum of correct classifications divided by the total number
%           of classifications
% A = sum(diag(M))/(sum(M(:)) + realmin);

% Confusion Matrix Values
TP = M(1,1); FN = M(1,2);
FP = M(2,1); TN = M(2,2);

% Accuracy
A = (TP + TN ) / (TP + FN + FP + TN);

% F1 Score
F  = 2*TP / (2*TP + FP + FN);

% Type 1 Error (Fall-out)
FPR = (FP) / (FP + TN);

% True Negativ Rate (Specificity)
TNR = (TN) / (TN + FP);


end

