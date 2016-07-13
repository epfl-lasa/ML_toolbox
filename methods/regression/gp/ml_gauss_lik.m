function lik = ml_gauss_lik(y,X,w,e_var)
%ML_GAUSS_LIK Gaussian Likelihood
%
%   input -----------------------------------------------------------------
%
%       o y     : (N x 1), output.  
%
%       o X     : (N x D), input, N samples of dimension D.
%
%       o w     : (D+1 x 1), linear regressor weights.
%
%       o e_var : (1 x 1), noise variance.
%
%   output ----------------------------------------------------------------
%       
%       o lik   : (N x 1), 
%


[N,D] = size(X);

% (N x 1) - (N x D+1) (D+1 x 1)
% (N x 1) - (N x 1)

diff = y - [X,ones(N,1)] * w';
z     = sum(diff .* diff);

lik  = 1.0/( (2 * pi * e_var)^(D/2)) * exp(-1/(2*e_var) *  z);



end

