function [predict_labels, y_rvm] = rvm_predict(data, labels,  model)
% RVM_PREDICT % Predicts labels and computes accuracy for new
% data with a learnt RVM model
%   input ----------------------------------------------------------------
%
%       o data             : (N x D), N data points of D dimensionality.
%
%       o model            : struct
%
%
%   output ----------------------------------------------------------------
%
%       o y_rvm            : (N x 1), decision values
%
%
%% Predict labels given model and data

%%%%%% Test
weights    = model.weights;
kernel_    = model.kernel_;
width      = model.width;
bias       = model.bias;
RVs        = model.RVs;

% Compute RVM over test data and calculate error
PHI	= SB1_KernelFunction(data, RVs, kernel_, width);
y_rvm	= PHI*weights + bias;

% Predicted labels
predict_labels             = y_rvm;
predict_labels(y_rvm >= 0) = 1;
predict_labels(y_rvm < 0)  = 0;

end