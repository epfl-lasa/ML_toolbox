function [y_rvm] = rvr_predict(X,  model)
% RVR_PREDICT % Predicts labels and computes accuracy for new
% data with a learnt RVM model
%   input ----------------------------------------------------------------
%
%       o X        : (N x D), N  input data points of D dimensionality.
%
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
RVs_idx    = model.RVs_idx;
RVs        = model.RVs;

% Compute RVM over test data and calculate error
PHI	= SB1_KernelFunction(X(:), RVs, kernel_, width);
y_rvm	= PHI*weights + bias;

end