function [ W ] = log_gmm_div_Q_w(X,Q,Priors,Mu,Sigma)
%LOG_GMM_DIV_Q_PRIOR
%
%
%   input -----------------------------------------------------------------
%       
%       o X         : (D x N),      Samples
%
%       o Q         : (N x 1),      Q-values
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
%       o W         : (N x K),  responsibility factor
%
%


K = size(Priors,2);
D = size(Mu,1);
N = size(X,2);

% likelihood for all data points
% (N x 1)
Lik = gmm_pdf(X,Priors,Mu,Sigma);

% (N x K)
lik_k = zeros(N,K);

for k=1:K
    lik_k(:,k) = gaussPDF(X,Mu(:,k),squeeze(Sigma(:,:,k)))';
end

%   (N x K)   (N x K)                (N x K)            (N x K)
W = (lik_k .* repmat(Priors,N,1) .* repmat(Q,1,K)) ./ repmat(Lik,1,K);


end

