function [predict_labels, model, dec_vals] = svm_classifier(X,labels,svm_options,model)
%SVM_CLASSIFIER.
%
%   input ----------------------------------------------------------------
%
%       o   X          : (N x D), number of datapoints.
%
%       o labels       : (N x 1), number of class labels 
%
%       o svm_options  : (1 x 1), parameter settings for svm model
%
%       o model        : struct, result of trained AdaBoost classifier with
%                             all parameters, etc..
%
%           
%
%

% Check binary labels are correct
labels(find(labels==0)) = -1;

% if the model doesn't exist, train it
if isempty(model)
        % Train SVM Classifier
        model = svm_train(X, labels, svm_options);    
end

% Compute accuracy of learnt classifier on training data
[predict_labels, ~,dec_vals] = svm_predict(X, labels, model);


end