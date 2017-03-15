function [y] = ml_gmm_pdf(xs,Priors,Mu,Sigma)
%ML_GMM_PDF, Gaussian Mixture Model function
%
%   G(x;\{pi,mu,sigma\}) = \sum_{i=1}^{K} pi_{k} * g(x;mu_k,sigma_k)
%
%   input ---------------------------------------------------------------
%
%       o xs: (D x N), set of N data points of dimension D
%
%       o Priors: (1 x K), sum(Priors) = 1
%
%       o Mu: (D x K), set of Sigmas
%
%       o Sigmas: (D x D x K)
%
%   output ----------------------------------------------------------------
%
%       o ys: (N x 1), values
%

[N,M] = size(xs);
K = size(Priors,2);
ys = zeros(M,K);

if size(Mu,1) == 1
    % Univariate
    
    for k=1:K
        ys(:,k) = normpdf(xs,Mu(k),sqrt(Sigma(k)));
    end    
else
    % Multivariate
    for k=1:K
        ys(:,k) = ml_gaussPDF(xs,Mu(:,k),Sigma(:,:,k));
    end
    
end

y = sum(ys .* repmat(Priors,M,1),2);

end

