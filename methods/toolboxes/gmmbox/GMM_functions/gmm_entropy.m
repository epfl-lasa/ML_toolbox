function H = gmm_entropy(Priors,Mu,Sigma)
%GMM_ENTROPY: Computes the differentinal entropy of a Gaussian Mixture
%Model. 

D = size(Mu,1);
K = size(Mu,2);
H = 0;

if D == 1
    for k=1:K  
        H = H  + Priors(k) * (-log(Priors(k)) + 0.5 * log(((2*pi*exp(1))^(D)) * det(Sigma(k)) ));    
    end 
else
    for k=1:K
        H = H  + Priors(k) * (-log(Priors(k)) + 0.5 * log(((2*pi*exp(1))^(D)) * det(Sigma(:,:,k)) ));
    end
end


end

