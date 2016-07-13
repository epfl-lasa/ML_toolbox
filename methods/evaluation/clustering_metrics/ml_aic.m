function aic = ml_aic(ll,num_para,lambda)
%ML_AIC Akaike Information Criteria
%
%   input -----------------------------------------------------------------
%
%       o ll        : (1 x 1), log-likelihood.
%
%       o num_para  : (1 x 1), number of parameters.
%
%       o lambda    : (1 x 1), weighting of regularisation
%
%   output ----------------------------------------------------------------
%
%       o aic       : (1 x 1)

if ~exist('lambda','var'),lambda = 2; end

aic =  -2 * ll + lambda* num_para;

end

