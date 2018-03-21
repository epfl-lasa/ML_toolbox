function [ dPriors ] = log_gmm_div_prior(W,Priors)
%LOG_GMM_DIV_PRIOR 
%
%   input -----------------------------------------------------------------
%
%       o X         : (D x N),      Samples
%
%       o W         : (N x K),      Responsibility factor
%
%       o Priors    : (1 x K),      Weights
%
%   output ----------------------------------------------------------------
%
%       o dPriors   : (1 x K),      Derivative of weights
%
%
%

K       = length(Priors);
dPriors = zeros(1,K);


for k=1:K
                    %(N x 1) 
    dPriors(k) = mean(W(:,k) ./ Priors(k));
    
end

 dPriors =  dPriors./sum(dPriors);



end

