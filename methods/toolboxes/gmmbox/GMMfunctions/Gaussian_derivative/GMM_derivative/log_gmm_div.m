function [dPriors,dMu,dSigma,res ] = log_gmm_div(X,Priors,Mu,Sigma )
%LOG_GMM_DIV Derivative of the Log of a Guassian Mixture Model
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
%   output ----------------------------------------------------------------
%       
%
%
%


[D,N]   = size(X);

K       = size(Priors,2);

% (N x 1)
L       = gmm_pdf(X,Priors,Mu,Sigma);


dPriors = zeros(1,K);
dMu     = zeros(D,K);
dSigma  = zeros(D,D,K);

% for each parameter k, compute the gradient for each point and sum

k_prior = 1./K;

res = zeros(K,N);
% compute gradient for Priors = responsability factor
for k=1:K
    res(k,:) =  Priors(k) .* gaussPDF(X,Mu(:,k),Sigma(:,:,k)) ./ L;
end


for k=1:K
    %invSigma_k    = inv(Sigma(:,:,k));
    
   % dPriors(k)    =  (1/N) .* sum(gaussPDF(X,Mu(:,k),Sigma(:,:,k)) ./ L);
    Nk            =  sum(res(k,:));
    dPriors(k)    =  Nk/N;
    dMu(:,k)      =  (1/Nk) .* sum( repmat(res(k,:)',1,D) .* X' ,1)';
    diff          =  X - repmat(Mu(:,K),1,N); % (D x N)
    %                                   (N x N) * (N x D)
    
    for n=1:N
         dSigma(:,:,k) = dSigma(:,:,k) +  res(k,n) * (X(:,n) - Mu(:,K)) * (X(:,n) - Mu(:,K))';
    end
     dSigma(:,:,k)  =  sqrt((1/Nk) .* dSigma(:,:,k));
   %  (1/Nk) .*  diff * diag(res(k,:)) * diff';
    
   % dSigma(:,:,k) =  dPriors(k) * 0.5 *(-invSigma_k + invSigma_k * Cov * invSigma_k );
    %dSigma(:,:,k) = 0.5 * ( dSigma(:,:,k) +  dSigma(:,:,k)');
end



%dPriors = dPriors ./ sum(dPriors);



end

