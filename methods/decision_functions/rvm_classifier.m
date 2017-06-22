function [predict_labels, model] = rvm_classifier(X,labels,rvm_options,model)
%SVM_CLASSIFIER.
%
%   input ----------------------------------------------------------------
%
%       o   X          : (N x D), number of datapoints.
%
%       o labels       : (N x 1), number of class labels 
%
%       o rvm_options  : (1 x 1), parameter settings for svm model
%
%       o model        : struct, result of trained AdaBoost classifier with
%                             all parameters, etc..
%
%           
%
%

% Check binary labels are correct
labels(find(labels==-1)) = 0;
model_exists = 1;

% if the model doesn't exist, train it
if isempty(model)
    % "Train" a sparse Bayes kernel-based model (relevance vector machine)    
    try
        model = rvm_train(X, labels, rvm_options); 
    catch
        warning('Model was not learned!')
        model_exists = 0;
        model = [];
        predict_labels = [];
    end
end

if (model_exists==1)
    % Compute accuracy of learnt classifier on training data
    [predict_labels, y_rvm] = rvm_predict(X, labels, model);
    
    N       = length(X);
    errs	= sum(y_rvm(labels==0)>0) + sum(y_rvm(labels==1)<=0);
    acc     = 1 - errs/N;
    N_RVs   = length(model.RVs);
    SB1_Diagnostic(1,'RVM CLASSIFICATION \n Accuracy =  %2.4f\n Revelant Vectors = %d \n', acc, N_RVs);
    
    model.N_RVs            = N_RVs;
    model.rvm_options      = rvm_options;
    model.predict_accuracy = acc;
end
end