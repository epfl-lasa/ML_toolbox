function [y,dy] = div_sigma_gmr(Priors,Mu, Sigma_dx,Sigma, x, in, out)
%DIV_GMR Derivative of Gaussian Mixture Regression
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
%              outputs (D=P+Q).
% Outputs ----------------------------------------------------------------
%   o y:       Q x N array representing the retrieved N datapoints of
%              Q dimensions, i.e. expected means.


N = size(x,2);
[D,D,K] = size(Sigma);
tmp = zeros(1,1,K);

index = 1;
for i=1:K
    for j=1:D
        for l=j:D
            tmp(j,j,i)  = Sigma_dx(index);%, Sigma_dx(2);Sigma_dx(3) Sigma_dx(4)];
            index = index + 1;
        end
    end
end
Sigma_dx = tmp;

%% Fast matrix computation (see the commented code for a version involving
%% one-by-one computation, which is easier to understand).
%%
%% Compute the influence of each GMM component, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:K
    Pxi(:,i) = Priors(i).*gaussPDF(x, Mu(in,i), Sigma(in,in,i));
end
beta = Pxi./repmat(sum(Pxi,2)+realmin,1,K);
%% Compute expected means y, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:K
    y_tmp(:,:,j) = repmat(Mu(out,j),1,N) + Sigma_dx(:,:,j)*inv(Sigma(in,in,j)) * (x-repmat(Mu(in,j),1,N));
end
beta_tmp = reshape(beta,[1 size(beta)]);
y_tmp2 = repmat(beta_tmp,[length(out) 1 1]) .* y_tmp;
y = sum(y_tmp2,3);

if nargout > 1
    
    dy = zeros(1,K);
    
    for j=1:K
        v = inv(Sigma(in,in,j)) * (x - Mu(in,j));
        v = v(:);
        dy(j) = v;
    end
    
    dy = dy .* beta;
    
end


end

