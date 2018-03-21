function [Mu3, Sigma3] = product_gauss(Mu1,Sigma1,Mu2,Sigma2)
%PRODUCT_GAUSS Takes the product of two Gaussian functions according to the
% Matrix CookBook Section 8.1.8
%
%
%   input -----------------------------------------------------------------
%
%       Mu,Sigma, first and second moment of a Gaussian function, can be
%       univariate or multivariate
%
%   output ----------------------------------------------------------------
%
%      Gauss3 = Gauss2 * Gauss1
%

invSig1 = inv(Sigma1);
invSig2 = inv(Sigma2);

Sigma3 = inv(invSig1 + invSig2);
Mu3 = Sigma3 * invSig1 * Mu1 + Sigma3 * invSig2 * Mu2;


end

