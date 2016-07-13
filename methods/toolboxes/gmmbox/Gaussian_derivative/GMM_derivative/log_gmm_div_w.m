function [ W ] = log_gmm_div_w(X,Priors,Mu,Sigma )
% LOG_GMM_DIV_W Computes the responsibility factor of each GMM component ot
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
%       o W         : (N x K),  responsibility factor
%

K = size(Priors,2);
D = size(Mu,1);
N = size(X,2);

% likelihood for all data points
% (N x 1)
Lik = gmm_pdf(X,Priors,Mu,Sigma);

% (N x K)
lik_k = zeros(N,K);

if D==1
    for k=1:K
        lik_k(:,k) = gaussPDF(X,Mu(k),Sigma(k))';
    end
else
    for k=1:K
        lik_k(:,k) = gaussPDF(X,Mu(:,k),squeeze(Sigma(:,:,k)))';
    end
end

%(N x K)
W = (lik_k .* repmat(Priors,N,1)) ./ repmat(Lik,1,K);

% nbStates = K;
% for i=1:nbStates
%     %Compute probability p(x|i)
%     Pxi(:,i) = gaussPDF(X, Mu(:,i), squeeze(Sigma(:,:,i)));
% end
% %Compute posterior probability p(i|x)
% Pix_tmp = repmat(Priors,[N 1]).*Pxi;
% Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 nbStates]); % -> W
% %Compute cumulated posterior probability
% E = sum(Pix);


end

