function [ X,Y ] = plot_gmm_components(Priors,Mu,Sigma)
%PLOG_GMM_COMPONENTS Summary of this function goes here
%   Detailed explanation goes here


D = size(Mu,1);
K = size(Mu,2);


if D == 1
    
    nbSamples = 401;
    
    X = zeros(nbSamples,K);
    Y = zeros(nbSamples,K);
 
    for k=1:K
        
        Max = Mu(k) + 3.0*sqrt(Sigma(k));
        Min = Mu(k) - 3.0*sqrt(Sigma(k));
        X(:,k)=linspace(Min,Max, nbSamples);
        Y(:,k) = Priors(k) .* gaussPDF(X(:,k)',Mu(k),Sigma(k));
    end

else
    
    
end



end

