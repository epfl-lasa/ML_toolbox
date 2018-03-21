function [gmm3] = merge_two_gmms(gmm1,X1,gmm2,X2,threashold,options)
%MERGE_GMMS Takes two Gaussian Mixture Models and tries to reduce the
% number of components. Two gmms with M and N components are taken and a
% third gmm is returned with no more than M + N comonents and no less than
% min(N,M) components
%
%   input ------------------------------------------------------
%
%       o gmm: struct,
%           - gmm.Priors: (1 x K)
%           - gmm.Mu: (D x K)
%           - gmm.Sigma: (D x D x K)
%
%       o X: (P x D), data
%
%       o threashold: (1 x 1) \in [0,1], distance threashold to consider 
%                                        a merge
%
%   output -----------------------------------------------------
%
%       o gmm3: struct 
%

gmm_model.ComponentProportion = [gmm1.Priors,gmm2.Priors];
gmm_model.mu                  = [gmm1.Mu,gmm2.Mu];
gmm_model.Sigma               = cat(3,gmm1.Sigma,gmm2.Sigma);
gmm_model.ComponentProportion = gmm_model.ComponentProportion./sum(gmm_model.ComponentProportion);

X    = [X1;X2];
K    = size(gmm_model.ComponentProportion,2);
diff = 1;
iter = 1;

while(diff ~= 0)
    
    disp(['iter(' num2str(iter) ')   K(' num2str(K) ') ']);
    
    GMModel = merge_gmm_components2(gmm_model,X,threashold,options);
    k       = size(GMModel.ComponentProportion,2);
    diff    = abs(K - k);
    K       = k;
    
    iter    = iter + 1;
    
end

gmm3.Priors = GMModel.ComponentProportion;
gmm3.Mu     = GMModel.mu;
gmm3.Sigma  = GMModel.Sigma;


end




