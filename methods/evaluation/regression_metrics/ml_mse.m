function MSE = ml_mse(y,hy)
%ML_MSE  Mean Square Error
%  
%   input -----------------------------------------------------------------
%
%       o y  : (N x 1), N predictor/output variables (ground truth).
%
%       o hy : (N x 1), N estimated predictor/output variablese, hy = f(X)
%   
%   output ----------------------------------------------------------------
%          
%       o MSE : (1 x 1), mean square error
%


%% Compuate prediction of the regression function

MSE = mean((hy(:) - y(:)).^2);



end

