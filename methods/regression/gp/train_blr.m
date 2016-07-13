function [w,A] = train_blr(X,y,var,Sigma_p)
%TRAIN_BLR Train Bayesian Linear Regression
%
%   Bayesian Linear Regression, we seek to learn a regression function 
%   where the relation between the predictor variable, y and the domain X
%   is linear in the parameters whilst assuming a prior probability
%   distribtion over the parameters
%
%     y = f(x) + \epsilon, \epsilon ~ N(0,var) (regression model)    (1)
%   
%     y = x' * w with w ~ N(0,\Sigma_p)         (2)
%
%   input ----------------------------------------------------------------
%
%       o X: (N x D), N samples of dimension D
%
%       o y: (D x 1), target value
%
%       o Sigma_p: (D x D), Prior Covariance matrix on the weights
%
%   output ----------------------------------------------------------------
%
%       o w: (D x 1), weight vectors of equation (1)-(2)
%
%
%
N = size(X,1);

%                               (D x 1)
%                        (D x D)        (D x N)  * (N x 1)                  
%             ((D x N) * (N x D) + (D x D))
X  = [X,ones(N,1)]; % add bias

A = (1/var) .* X'*X + inv(Sigma_p);
w = (1/var) .* (A \ (X' * y));




end

