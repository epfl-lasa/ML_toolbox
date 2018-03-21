function [ Priors,NewMu,NewSigma] = gmm_marginalise(Priors,Mu,Sigma,out)
%GMM_MARGINALISE
%
%   o Priors:  1 x K array representing the prior probabilities of the K GMM
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the
%              K GMM components.
%   o x:       P x N array representing N datapoints of P dimensions.
%   o out:      1 x P array representing the dimensions to consider as
%              output.

[NewMu,NewSigma]    = getGaussianSlice(Mu,Sigma,out);


end

