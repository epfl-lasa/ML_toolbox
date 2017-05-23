function [labels] =  ml_gmm_cluster(X, Priors, Mu, Sigma)
%GMM_CLUSTER Computes the cluster labels for the data points given the GMM
%
%   input -----------------------------------------------------------------
%   
%       o X      : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o Priors : (1 x K), the set of priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu     : (N x K), an NxK matrix corresponding to the centroids 
%                           mu = {mu^1,...mu^K}
%       o Sigma  : (N x N x K), an NxNxK matrix corresponding to the 
%                           Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%
%   output ----------------------------------------------------------------
%
%       o labels   : (1 x M), a M dimensional vector with the label of the
%                             cluster for each datapoint
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Auxiliary Variables
[N, M] = size(X);
[~, K] = size(Mu);

% Initializing variables

Pk_x = zeros(K,M);
labels = zeros(1,M);


% Find the a posteriori probability for each data point for each cluster
for ii = 1:K
    Px_k(ii,:) = Priors(ii).*ml_gaussPDF(X,Mu(:,ii),Sigma(:,:,ii));
end

for ii=1:M
   Pk_x(:,ii) = (Priors'.*Px_k(:,ii))./(sum(Priors'.*Px_k(:,ii)) + eps);
end

for ii = 1:M    
   [~,labels(ii)] = max(Pk_x(:,ii));   
end

