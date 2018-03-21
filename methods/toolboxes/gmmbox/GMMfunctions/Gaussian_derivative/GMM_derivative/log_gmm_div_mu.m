function [dMu,dMu_n] = log_gmm_div_mu(X,W,Mu,Sigma)
%LOG_GMM_DIV_MU Derivative of the Log liklihood Guassian Mixture Model
%
%
%   input -----------------------------------------------------------------
%       
%       o X         : (D x N),      Samples
%
%       o Priors    : (1 x K),      Weights
%
%       o Mu        : (D x K),      Means
%
%       o Sigma     : (D x D x K),  Covariance   
%
%
%   output ----------------------------------------------------------------
%
%       o dMu       : (D x N x K), gradients of means for each data point   
%                                  and each Gaussian Component
%   


K = size(Mu,2);
D = size(Mu,1);
N = size(X,2);

dMu = zeros(D,K);

if nargout > 1
   dMu_n = zeros(D,N,K); 
end

for k=1:K
    if nargout > 1
         dMu_n(:,:,k) = repmat(W(:,k)',D,1) .* (inv(Sigma(:,:,k)) * (X - repmat(Mu(:,k),1,N)));
         dMu(:,k)     = mean(dMu_n(:,:,k),2);
    else
         dMu(:,k) = mean(repmat(W(:,k)',D,1) .* (inv(Sigma(:,:,k)) * (X - repmat(Mu(:,k),1,N))),2);
    end
end

end


