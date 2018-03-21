function [y,ys] = gmc_pdf(Data,Priors_c, Mu_c, Sigma_c)
%GMC_PDF
%
% Inputs -----------------------------------------------------------------
%
%   o Data:    D x N array representing N datapoints of P dimensions.
%
%   o Priors:  N x K array representing the prior probabilities of the K GMM
%              components.
%   o Mu:      N x D x K array representing the centers of the K GMM components.
%
%   o Sigma:   D x D x K array representing the covariance matrices of the
%              K GMM components.
%
% Output------------------------------------------------------------------------
%
%   o y:       N x 1, likelihood
%
%   o ys:      N x K, likelihood of each Gaussian component
%

[D,N] = size(Data);
K = size(Priors_c,2);
y  = zeros(N,1);
ys = zeros(N,K);

for i=1:N
   % (1 x 1) (1 x K)     
    [y_i,ys_i] = gmm_pdf(Data(:,i),Priors_c(i,:),reshape(Mu_c(i,:,:),D,K),Sigma_c);
    y(i)       = y_i;
    ys(i,:)    = ys_i;
end



end

