function [ gmm_c ] = compress_gmm(gmm,Xtrain,threashold,options)
%COMPRESS_GMM Compresses a GMM in which there are possibly duplicate
%parameters. 
%
%   input ------------------------------------------------------
%
%       o gmm: strcut, gmm.Priors
%                      gmm.Mu
%                      gmm.Sigma
%
%       o Xtrain: (N x D), training data used to retrain the parameters of
%       the GMM after a few have been removed
%
%   output -----------------------------------------------------
%
%       o gmm_c: struct, GMM with less than or equal number of parameters
%       as gmm.
%

GMModel.ComponentProportion = gmm.Priors;
GMModel.mu                  = gmm.Mu;
GMModel.Sigma               = gmm.Sigma;

gmm_c = merge_gmm_components2(GMModel,Xtrain,threashold,options);


end

