function [y,Dmu_dx ] = div_mu_log_gmr(Priors, Mu_x,Mu_dx, Sigma, x, in, out)
%DIV_LOG_SIGMA_GMR  Compute the log derivative of Gaussian Mixture
% Regression with respect respect
%
%
%   o Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%   o x:       P x 1 array representing N datapoints of P dimensions.
%   o in:      1 x P array representing the dimensions to consider as
%              inputs.
%   o out:     1 x Q array representing the dimensions to consider as
%              outputs (D=P+Q).
% Outputs ----------------------------------------------------------------
%   o y:       Q x N array representing the retrieved N datapoints of 
%              Q dimensions, i.e. expected means.
%   
%   o Dmu_dx:  Q x K  
%


N = size(x,2);
K = size(Sigma,3);
Mu = [Mu_x;Mu_dx];

%% Fast matrix computation (see the commented code for a version involving 
%% one-by-one computation, which is easier to understand).
%%
%% Compute the influence of each GMM component, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:K
  Pxi(:,i) = Priors(i).*gaussPDF(x, Mu_x(:,i), Sigma(in,in,i));
end
beta = Pxi./repmat(sum(Pxi,2)+realmin,1,K);
%% Compute expected means y, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:K
  y_tmp(:,:,j) = repmat(Mu_dx(:,j),1,N) + Sigma(out,in,j)*inv(Sigma(in,in,j)) * (x-repmat(Mu(in,j),1,N));
end
beta_tmp = reshape(beta,[1 size(beta)]);
y_tmp2 = repmat(beta_tmp,[length(out) 1 1]) .* y_tmp;
ll = sum(y_tmp2,3)

y = log(ll);

if nargout > 1
    Dmu_dx = (1./ll) .* beta(:);
end


end

