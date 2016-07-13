function [labels] = predictor_linear_classifier(X,B_hat,mapping)
%PREDICTOR_LINEAR_CLASSIFIER
%
%
%

[~,~,labels]  = linear_classifier('predict',X,[],[],'classification',B_hat,mapping);


end

