function [model] = rvm_train(data, labels, options)
% RVM_TRAIN Trains an RVM Model using SB1 Tipping Toolbox
%
%   input ----------------------------------------------------------------
%
%       o data        : (N x D), N data points of D dimensionality.
%
%       o labels      : (N x 1), Either 1, -1 for binary
%
%       o options     : struct
%
%
%   output ----------------------------------------------------------------
%
%       o model       : struct.
%
%
%% %    RVM OPTIONS
%       ALPHA   Scalar initial value for hyperparameters
%       BETA    Initial value for inverse noise variance (in regression)
%               Set this negative to fix the value, rather than estimate
%       KERNEL  Kernel type: see SB1_KERNELFUNCTION for options
%       LEN     Kernel length scale
%       USEBIAS Set to non-zero to utilise a "bias" offset
%       MAXITS  Maximum iterations to run for.

%% Parse RVM Options
% Parsing Parameter for RVM
N	= length(data);
useBias = options.useBias;
kernel_	= options.kernel_;
width   = options.width; 
maxIts	= options.maxIts;
monIts	= round(maxIts/20);

% Set verbosity of output (0 to 4)
setEnvironment('Diagnostic','verbosity',3);
% Set file ID to write to (1 = stdout)
setEnvironment('Diagnostic','fid',1);

%% Set up initial hyperparameters - precise settings should not be critical 
initAlpha	= (1/N)^2;
% Set beta to zero for classification
initBeta	= 0;
% Check that labels are 0 for negative class
labels(find(labels==-1)) = 0;

%% Train RVM Model

% "Train" a sparse Bayes kernel-based model (relevance vector machine) 
[weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(data,labels,initAlpha,initBeta,kernel_,width,useBias,maxIts,monIts);

%% Model Parameters
%       WEIGHTS Parameter values of estimated model (sparse)
%       USED    Index vector of "relevant" kernels (data points)
%       BIAS    Value of bias or offset parameter
%       ML      Log marginal likelihood of model
%       ALPHA   Estimated hyperparameter values (sparse)
%       BETA    Estimated inverse noise variance for regression
%       GAMMA   "Well-determinedness" factors for relevant kernels

model.weights  = weights;
model.kernel_  = kernel_;
model.width    = width;
model.RVs      = data(used,:);
model.bias     = bias;
model.marginal = marginal;
model.alpha    = alpha;
model.beta     = beta;
model.gamma    = gamma;

end