function [gmm] = merge_gmm_components2(gmm_model,X,threashold,options)
%MERGE_GMM_COMPONENTS 
%
%   input ------------------------------------------------------------
%
%       o gmm_mode, struct
%
%       o X: (N x D), Training data
%
%       o threashold: (1 x 1) \in [0,1], distance threashold to consider 
%                                        a merge
%       o options: for the EM algorithm
%
%


D = size(gmm_model.mu,1);

% pair-wise distance between each Gaussian function component
HD = get_distance_matrix(gmm_model);

[i,j] = find(HD < threashold);
idx = [i,j];
idxk   = [];
while( size(idx,1) ~= 0)
    i        = idx(1,1);
    j        = idx(1,2);
    idxk     = [idxk;idx(1,:)];
    idx(1,:) = [];
    
    Ii = find(idx(:,1) == i);
    idx(Ii,:) = [];
    Ij = find(idx(:,1) == j);  
    idx(Ij,:) = [];
    
    Ii = find(idx(:,2) == i);
    idx(Ii,:) = [];
    Ij = find(idx(:,2) == j);
    idx(Ij,:) = [];
   
end

Priors = zeros(1,size(idxk,1));
Mus    = zeros(D,size(idxk,1));
Sigmas = zeros(D,D,size(idxk,1));

for k=1:size(idxk,1)
   
    i = idxk(k,1);
    j = idxk(k,2);
    
    [w3,Mu3,Sigma3 ] = mergeTwoGaussians(gmm_model.ComponentProportion(i),gmm_model.mu(:,i),gmm_model.Sigma(:,:,i),gmm_model.ComponentProportion(j),gmm_model.mu(:,j),gmm_model.Sigma(:,:,j));
    
    d = eig(Sigma3);
    Ib = find(d <= 0);
    if ~isempty(Ib)
       Ib
       k
    end
    
    Priors(k)       = w3;
    Mus(:,k)        = Mu3;
    Sigmas(:,:,k)   = Sigma3;
     
end

% remoce components

kr = reshape(idxk,[],1);

gmm_model.ComponentProportion(kr)    = [];
gmm_model.mu(:,kr)                   = [];
gmm_model.Sigma(:,:,kr)              = [];

gmm_model.ComponentProportion = [gmm_model.ComponentProportion,Priors];
gmm_model.mu                  = [gmm_model.mu,Mus];
gmm_model.mu                  = gmm_model.mu';               % (K x D)
gmm_model.Sigma               = cat(3,gmm_model.Sigma,Sigmas);
gmm_model.ComponentProportion = gmm_model.ComponentProportion./sum(gmm_model.ComponentProportion);

K = size(gmm_model.ComponentProportion,2);

GMModel                  = fitgmdist(X,K,'Options',options,'CovarianceType','full','RegularizationValue',1e-03,'Replicates',1,'Start',gmm_model);
gmm.ComponentProportion = GMModel.ComponentProportion;
gmm.mu                  = GMModel.mu';
gmm.Sigma               = GMModel.Sigma;


end


function HD = get_distance_matrix(gmm)
%   
%   returns the Hellinger distance between each component of the Gaussian
%   Mixture Model
%

K = size(gmm.Sigma,3);
BC = zeros(K,K);

for i=1:K
  for j=1:K 
      if i ~= j
        BC(i,j) = bhattaryyaC(gmm.mu(:,i),gmm.Sigma(:,:,i),gmm.mu(:,j),gmm.Sigma(:,:,j));
      end
  end
end

BC(find(BC < 0)) = 0;
BC(find(BC > 1)) = 1;

HD = sqrt(1 - BC);
end

