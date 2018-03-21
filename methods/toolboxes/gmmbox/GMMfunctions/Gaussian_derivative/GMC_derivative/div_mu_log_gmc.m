function [p,Dmu] = div_mu_log_gmc( Priors,Mu_out, Mu_in, Sigma, x_out, x_in, in, out)
%DIV_MU_LOG_GMC
%
%
%
% Inputs -----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%
%   o Sigma:   D x D x K array representing the covariance matrices of the
%              K GMM components.
%
%   o x_out:   Q x N (velocity dx)
%
%   o x_in:    P x N (position x)
%
%   o in:      1 x P array representing the dimensions to consider as
%              inputs.
%   o out:     1 x Q array representing the dimensions to consider as
%              outputs (D=P+Q)
%
% Output------------------------------------------------------------------------
%
%   o p:       1 x N, likelihood of each output x_out
%
%
%

Mu = [Mu_in;Mu_out];
N  = size(x_out,2);
D  = size(x_out,1);
K  = length(Priors);


%   o h_c :    N x K
%
%   o Mu_c      :   Q x N x K
%
%   o Sigma_c   :   Q x Q x K
[h_c,Mu_c,Sigma_c]  = GMC(Priors, Mu, Sigma, x_in, in, out);

Mu_c = reshape(Mu_c(:,1,:),D,K);
v    = gmm_pdf(x_out,h_c,Mu_c,Sigma_c);
p    = log(v);

if nargout > 1
    % Compute gradient for x_out(:,1) and x_in(:,1)
    
    Dmu = zeros(D,K);
    
    for k=1:K
        
%         % (D x K)
%         
%         Mu_k_dx           = Mu(out,k);
%         Mu_k_x            = Mu(in,k);
% 
%         % \Sigma^{-1}_{\dx|x} inverse of the conditional matrix
      %  invSigma_k_dx_x   = inv(Sigma_c(:,:,k));
      %  A                 = Sigma(out,in,k) * inv(Sigma(in,in,k));

      %  fac     = (x_in(:,1) - Mu_k_x)' * A' * invSigma_k_dx_x;
        a       = (h_c(k) * gaussPDF(x_out(:,1),Mu_c(:,k),Sigma_c(:,:,k))) / v;

        x       = x_in;
        dx      = x_out;
        Mu_x    = Mu(in,k);
        Mu_dx   = Mu(out,k);
    
       	Sigma_dxdx = Sigma(out,out,k);
        Sigma_xx   = Sigma(in,in,k);
        Sigma_dxx  = Sigma(out,in,k);
        Sigma_xdx  = Sigma(in,out,k);

       [~,dy]      = div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx);

        Dmu(:,k)     = a .* dy;
        
    end
end



end

