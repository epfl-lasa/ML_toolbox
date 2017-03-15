function [  Priors, Mu, Sigma ] = ml_gmmEM(X, K)
%MY_GMMEM Computes maximum likelihood estimate of the parameters for the 
% given GMM using the EM algorithm and initial parameters
%   input------------------------------------------------------------------
%
%       o X         : (N x M), a data set with M samples each being of 
%                           dimension N, each column corresponds to a datapoint.
%       o K         : (1 x 1) number K of GMM components.
%   output ----------------------------------------------------------------
%       o Priors : (1 x K), the set of priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu     : (N x K), an NxK matrix corresponding to the centroids 
%                           mu = {mu^1,...mu^K}
%       o Sigma  : (N x N x K), an NxNxK matrix corresponding to the 
%                       Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%%

% Learn Joint Distribution
fprintf('Estimating Paramaters of GMM learned through EM with %d Gaussian functions.\n', K);
tic;
[Priors_0, Mu_0, Sigma_0] = EM_init_kmeans(X, K, []);
[Priors, Mu, Sigma] = EM(X, Priors_0, Mu_0, Sigma_0);
toc;
end

