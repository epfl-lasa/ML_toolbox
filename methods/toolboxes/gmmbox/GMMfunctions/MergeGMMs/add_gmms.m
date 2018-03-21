function [ gmm ] = add_gmms( gmms )
%ADD_GMMS Concatenates a group of Gaussian Mixture Models into a single one
%
%   input -----------------------------------
%
%       o gmms: cell(N,1), gmms{1}.gmm.Priors
%                          gmms{1}.gmm.Mu
%                          gmms{1}.gmm.Sigma
%
%
%   output ----------------------------------
%
%       o gmm: struct, gmm.Prior, gmm.Mu, gmm.Sigma, a very large GMM which
%       is the result of concatenating all the other GMMs from the cell
%       array.
%
%
%

nbGmms     = size(gmms,1);
gmm.Priors = [];
gmm.Mu     = [];
gmm.Sigma  = [];

for i=1:nbGmms
    
   gmm.Priors = [gmm.Priors, gmms{i}.gmm.Priors];
   gmm.Mu     = [gmm.Mu,     gmms{i}.gmm.Mu];
   gmm.Sigma  = cat(3,gmm.Sigma,gmms{i}.gmm.Sigma);
    
end


gmm.Priors = gmm.Priors./sum(gmm.Priors);

for k=1:size(gmm.Mu,2)
   
    gmm.Sigma(:,:,k) = 0.5 * (gmm.Sigma(:,:,k) + gmm.Sigma(:,:,k)');
    
    
end





end

