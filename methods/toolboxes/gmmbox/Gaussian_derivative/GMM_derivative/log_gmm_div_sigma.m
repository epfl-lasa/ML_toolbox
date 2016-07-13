function [ dSigma ] = log_gmm_div_sigma(X,W,Mu,Sigma)
%LOG_GMM_DIV_SIGMA Computes derivative of Covariance Matrix
%
%
%   input -----------------------------------------------------------------
%
%       o X         : (D x N),      Samples
%
%       o W         : (N x K),      Responsibility factor
%
%       o Mu        : (D x K),      Means
%
%       o Sigma     : (D x D x K),  Covariance
%

N      = size(X,2);
[D,K]  = size(Mu);
dSigma = zeros(D,D,K);
%E = sum(W);


for k=1:K
    
    iSigma_k = inv(Sigma(:,:,k));

    %     (D x N) - (D x N)
    diffK = X - repmat(Mu(:,k),1,N);

            % (D x D)
   % dSigma(:,:,k) = ((repmat(W(:,k)',D,1) .* diffK) * diffK') / E(k);

 %   dSigma(:,:,k) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(k);
     for i=1:N
%         
%         % (D x D) +  (D x D)  (D x N) * (N x D)
         dSigma(:,:,k) = dSigma(:,:,k) +  W(i,k) .* 0.5.* (-iSigma_k + iSigma_k * (X(:,i) * X(:,i)') *  iSigma_k);
%         dSigma(:,:,k) = dSigma(:,:,k) +  W(i,k) .* ((X(:,i) - Mu(:,k)) * (X(:,i) - Mu(:,k))');
     end

     dSigma(:,:,k) = dSigma(:,:,k)./N;

    
end

%% Add a tiny variance to avoid numerical instability
for i=1:K
    dSigma(:,:,i) = dSigma(:,:,i) + 1E-5.*diag(ones(D,1));
end







end

