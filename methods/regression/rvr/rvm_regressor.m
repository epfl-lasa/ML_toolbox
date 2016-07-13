function [y_rvm, model] = rvm_regressor(X,y,rvr_options,model)
%RVM_REGRESSOR.
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

% Transform data to columns
X = X(:);
y = y(:);


% if the model doesn't exist, train it
if isempty(model)
        % Train SVM Regressor
    [model] = rvr_train(X, y, rvr_options);
end

% Predict RVR function from Train data
[y_rvm] = rvr_predict(X,  model);

SB1_Diagnostic(1,'Sparse Bayesian regression test error (RMS): %g\n', ...
	sqrt(mean((y-y_rvm).^2)))
SB1_Diagnostic(1,'Estimated noise level: %.4f \n', ...
	sqrt(1/model.beta))

end