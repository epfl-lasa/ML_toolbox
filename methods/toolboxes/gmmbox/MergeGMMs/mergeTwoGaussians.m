function [ w3,Mu3,Sigma3 ] = mergeTwoGaussians(w1,Mu1,Sigma1,w2,Mu2,Sigma2)
%MERGETWOGAUSSIANS Merges two Gaussian functions into a single one based
% on equation from "Splitting and Merging Gaussian Mixture Model
% Components: An Evolutionary Approach ICML 2011"
%
%   input ----------------------------------------------------------------
%
%       o w : 1x1, weight of Gaussian function
%       o Mu : Dx1, mean (first moment)
%       o Sigma: DxDx1, Covariance (second moment)
%
%   output ----------------------------------------------------------------
%
%      o w3, Mu3, Sigma3
%       
%       w3      = w1 + w2
%       Mu3     = ( w1 * Mu1 + w2 * Mu2 )/ w3
%       Sigma3  = (1/w3) * (w1*Sigma1 + w1*Mu1*Mu1' + w2*Sigma2 + w2*Mu2*Mu2') - Mu3*Mu3'
%

w3 = w1 + w2;
Mu3 = ( w1 * Mu1 + w2 * Mu2 ) / w3;
Sigma3  = (1/w3) * (w1*Sigma1 + w1*Mu1*Mu1' + w2*Sigma2 + w2*Mu2*Mu2') - Mu3*Mu3';
[v,d]   = eig(Sigma3);

EPS = 10^-6;      %SET THE VALUE TO PLACE INSTEAD OF ZERO OR NEGATIVE  
                  %EIGENVALUES  
ZERO = 10^-10;    %SET THE VALUE TO LOOK FOR 
d(d<=ZERO)=EPS; %FIND ALL EIGENVALUES<=ZERO AND CHANGE THEM FOR EPS 
Sigma3  = v*d*v';

end

