function [y_pred, model] = svm_regressor(X,y,svr_options,model)
%SVM_REGRESSOR.
%
%   input ----------------------------------------------------------------
%
%       o X            : (N x D), number of input datapoints.
%
%       o y            : (N x 1), number of output datapoints.
%
%       o svr_options  : (1 x 1), parameter settings for svr model
%
%   output----------------------------------------------------------------
%
%       o model        : struct, result of linear input-output function
%
%           
%
%
%%

if isempty(y)
    y = randn(length(X),1);
end

% if the model doesn't exist, train it
if isempty(model)
        % Train SVM Regressor
        model = svr_train(y, X, svr_options);    
end

% Predict Values based on query points
[y_pred]  = svmpredict(y, X, model);


end