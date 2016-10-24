function [ bic ] = ml_gmm_bic(Data,Priors,Mu,Sigma,cov_type)
%ML_GMM_BIC Bayesian Information criterion
%
%  input ------------------------------------------------------------------
%
%   o Data:     D x N array representing N datapoints of D dimensions.
%
%   o Priors:   1 x K array representing the prior probabilities of the
%               K GMM components.
%   o Mu:       D x K array representing the centers of the K GMM components.
%
%   o Sigma:    D x D x K array representing the covariance matrices of the
%               K GMM components.
%
%   o cov_type: string, covariance type = 'full','diag' or 'iso'
%
%  output -----------------------------------------------------------------
%
%   o bic   : (1 x 1)
%
%




[D,N]       = size(Data);
K           = length(Priors);
num_param   = K-1 + K * D;

if strcmp(cov_type,'full') == true
    num_param = num_param + K * ( D * ( D - 1)/2 );
elseif strcmp(cov_type,'diag') == true
    num_param = num_param + K * D;
elseif strcmp(cov_type,'iso') == true
    num_param = num_param + K * 1;
else
   error(['no such covariance type: ' cov_type '  only full | diag | isot ']); 
end
    

% compute the loglikelihood of the data given the model
% loglik: (N x 1) 

loglik = ml_LogLikelihood_gmm(Data,Priors,Mu,Sigma);
bic    = - 2 * loglik + num_param * log(N);

end

