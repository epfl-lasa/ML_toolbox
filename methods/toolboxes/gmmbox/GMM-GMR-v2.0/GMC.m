function [beta,Mu_c,Sigma_y_tmp] = GMC(Priors, Mu, Sigma, x, in, out)
%GMC Gaussian Mixture Conditional. Returns the conditional P(out|in=x) of
% the Gaussian Mixture Model P(out,in) at the point in=x.
%
%
%
% Inputs -----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the
%              K GMM components.
%   o x:       P x N array representing N datapoints of P dimensions.
%   o in:      1 x P array representing the dimensions to consider as
%              inputs.
%   o out:     1 x Q array representing the dimensions to consider as
%              outputs (D=P+Q)
%
% Output------------------------------------------------------------------------
%
%   o beta      :   N x K
%
%   o Mu_c      :   Q x N x K
%
%   o Sigma_c   :   Q x Q x K
%
%
%

nbData = size(x,2);
nbVar = size(Mu,1);
nbStates = size(Sigma,3);

%% Compute the influence of each GMM component, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:nbStates
%     if i == 1
%         Mu(in,i)
%         Sigma(in,in,i)
%         inv(Sigma(in,in,i))
%         det(Sigma(in,in,i))
%         gaussPDF(x, Mu(in,i), Sigma(in,in,i))
%     end
    Pxi(:,i) = Priors(i).*gaussPDF(x, Mu(in,i), Sigma(in,in,i));
end
beta = Pxi./repmat(sum(Pxi,2)+realmin,1,nbStates);

%% Compute expected means y, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nbStates
    %   (N x D x K)
    %                   (D x N)                        (D x D)                               (D x N)
    Mu_c(:,:,j) = (repmat(Mu(out,j),1,nbData) + Sigma(out,in,j)*inv(Sigma(in,in,j)) * (x-repmat(Mu(in,j),1,nbData)))';
   %  Mu_c(:,:,j) = (repmat(Mu(out,j),1,nbData))';

end

%% Compute Marginal covariance matrices Sigma_y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nbStates
    Sigma_y_tmp(:,:,j) = Sigma(out,out,j) - (Sigma(out,in,j)*inv(Sigma(in,in,j))*Sigma(in,out,j));
    Sigma_y_tmp(:,:,j) = 0.5 * (Sigma_y_tmp(:,:,j) + Sigma_y_tmp(:,:,j)');
end

end

