function [ X,i ] = gmm_sample(nbSamples,Priors,Mu,Sigma )
%GMM_SAMPLE Samples points from a Gaussian Mixture Model
%
%   input -----------------------------------------------------------------
%
%       o nbSamples : (1 x 1), number of samples to return
%
%       o Priors    : (1 x K), gmm weights
%       
%       o Mu        : (D x K), gmm means
%
%       o Sigma     : (D x D x K), gmm covariance
%   
%   output ----------------------------------------------------------------
%
%       o X         : (D x N), N samples of dimension D
%
%       o i         : (N x 1), index of Gaussian center from which the data
%                              points were sampled form.

D = size(Mu,1);
X = zeros(D,nbSamples);
    
i = discretesample(Priors', nbSamples);
    
if D == 1
    
    for v=1:nbSamples
        
        X(v) = normrnd(Mu(i(v)), sqrt(Sigma(i(v))) );    
        
    end  
else
    
    for v = 1:nbSamples
        j = i(v);
        X(:,v) = mvnrnd(Mu(:,j),Sigma(:,:,j));
    end
    
end


end

