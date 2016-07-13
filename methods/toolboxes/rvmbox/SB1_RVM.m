% SB1_RVM       Kernel specialisation of sparse Bayes model (RVM)
%
% [WEIGHTS, USED, BIAS, ML, ALPHA, BETA, GAMMA] = ...
%    SB1_RVM(X,T,ALPHA,BETA,KERNEL,LEN,USEBIAS,MAXITS,MONITS)
%
% OUTPUT ARGUMENTS:
%
%       WEIGHTS Parameter values of estimated model (sparse)
%       USED    Index vector of "relevant" kernels (data points)
%       BIAS    Value of bias or offset parameter
%       ML      Log marginal likelihood of model
%       ALPHA   Estimated hyperparameter values (sparse)
%       BETA    Estimated inverse noise variance for regression
%       GAMMA   "Well-determinedness" factors for relevant kernels
% 
% INPUT ARGUMENTS:
%
%       X       Input data matrix (one point per row)
%       T       Target values
%       ALPHA   Scalar initial value for hyperparameters
%       BETA    Initial value for inverse noise variance (in regression)
%               Set this negative to fix the value, rather than estimate
%       KERNEL  Kernel type: see SB1_KERNELFUNCTION for options
%       LEN     Kernel length scale
%       USEBIAS Set to non-zero to utilise a "bias" offset
%       MAXITS  Maximum iterations to run for.
%       MONITS  If non-zero, display details every MONITS iterations.
% 
% NOTES:
%
% This is essentially a wrapper for the more general SB1_ESTIMATE which
% specialises the model to data-parameterised kernel functions:
% in other words, a "relevance vector machine".
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function [weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(X,t,initAlpha,initBeta,kernel_,lengthScale,useBias,maxIts,monIts)

%
% Create basis (design) matrix using data-parameterised kernel functions
% 
SB1_Diagnostic(1,'Constructing RVM ...\n');
SB1_Diagnostic(2,'Evaluating kernel ...\n');
PHI	= SB1_KernelFunction(X,X,kernel_,lengthScale);
[N d]	= size(X);
% 
% Add bias vector if requested
% 
if useBias
  PHI	= [PHI ones(N,1)];
end
%
SB1_Diagnostic(2,'Created basis matrix PHI: %d x %d\n', size(PHI));
SB1_Diagnostic(3,'kernel:\t''%s''\n', kernel_);
SB1_Diagnostic(3,'scale:\t%f\n', lengthScale);
%
% "Train" a sparse Bayes kernel-based model (relevance vector machine)
% 
SB1_Diagnostic(1,'Calling hyperparameter estimation routine ...\n');
%
[weights, used, marginal, alpha, beta, gamma] = ...
    SB1_Estimate(PHI,t,initAlpha,initBeta,maxIts,monIts);
%
% Strip off bias for later convenience
% 
bias	= 0;
if useBias
  indexBias	= find(used==N+1);
  if ~isempty(indexBias)
    bias		= weights(indexBias);
    used(indexBias)	= [];
    weights(indexBias)	= [];
  end
end
