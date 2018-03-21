function prob = gaussPDF(Data, Mu, Sigma)
%
% This function computes the Probability Density Function (PDF) of a
% multivariate Gaussian represented by means and covariance matrix.
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Data:  D x N array representing N datapoints of D dimensions.
%   o Mu:    D x 1 array representing the centers of the K GMM components.
%   o Sigma: D x D x 1 array representing the covariance matrices of the 
%            K GMM components.
% Outputs ----------------------------------------------------------------
%   o prob:  1 x N array representing the probabilities for the 
%            N datapoints.     

[nbVar,nbData] = size(Data);

%      (D x N) - repmat((D x 1),1,N)
%      (D x N) - (D x N)
Data = (Data - repmat(Mu,1,nbData))';

% Data = (N x D)

% (N x 1)
prob = sum((Data*inv(Sigma)).*Data, 2);
prob = exp(-0.5*prob) / sqrt((2*pi)^nbVar * (abs(det(Sigma))+realmin));
