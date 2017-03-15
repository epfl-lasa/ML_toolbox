function [ loglik ] = ml_LogLikelihood_gmm(X,Priors,Mu,Sigma)
%LOGLIKELIHOOD_GMM
%
%   input------------------------------------------------------------------
%
%       o X : (D x N), set of N data points of dimension  D
%       o Priors:   1 x K array representing the prior probabilities of the
%               K GMM components.
%       o Mu:       D x K array representing the centers of the K GMM components.
%       o Sigma:    D x D x K array representing the covariance matrices of the
%                   K GMM components.
%
%   output ----------------------------------------------------------------
%
%       o loglik : (N x 1) , loglikelihood
%


N = size(X,2);
K = size(Priors,2);

Pxi = zeros(N,K);
for i=1:K
    Pxi(:,i) = ml_gaussPDF(X, Mu(:,i), Sigma(:,:,i));
end

%Compute the log likelihood
F            = Pxi*Priors';
F(F<realmin) = realmin;
F            = Pxi*Priors';
loglik       = sum(log(F));


end

