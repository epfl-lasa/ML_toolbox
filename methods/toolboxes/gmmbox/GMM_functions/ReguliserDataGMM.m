function [ Xn ] = ReguliserDataGMM(X,n)
%REGULISER Adds some noise to a data set/ signal. This comes in handy for
% instance when using GMM's. If a particular dimension does not have a lot
% of variance and an input data variable is slightly off this can leads 
% to very bad behaviour.
%
%   input -----------------------------------------------------------------
%
%       o X: (M x 1), M data points of dimension 1
%
%       o n: (1 x 1), noise variance to add to the signal.
%
%   output ----------------------------------------------------------------
%
%       o Xn: (M x 1), where Xn(i) ~ gauss(0;Xn(i),n)
%
%
%

X  = X(:); 
Xn = sqrt(n) * randn(length(X),1) + X; 


end

