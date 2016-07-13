function [labels,model,D] = adaboost_classifier(X,labels,num_weak,model,weak_type)
%ADABOOST_CLASSIFIER  Original AdaBoost for binary classification problem.
%
%   input ----------------------------------------------------------------
%
%       o   X       : (N x D), number of datapoints.
%
%       o labels    : (N x 1), number of class labels 
%
%       o num_weak  : (1 x 1), number of weak classifiers
%
%       o model     : struct, result of trained AdaBoost classifier with
%                             all parameters, etc..
%
%       o weak_type : string, type of weak classifier.     
%
%

D = [];
if ~exist('weak_type','var'), weak_type = 'decision_stump'; end

% if the model exists, evaluate the classifier else train it
if isempty(model)
    %                        (mode,X,labels,model,itt)
    [labels,model,D] = adaboost('train',X,labels,[],num_weak,weak_type);
    
else
    
   labels          = adaboost('apply',X,[],model,[],weak_type);
    
end

 

end

