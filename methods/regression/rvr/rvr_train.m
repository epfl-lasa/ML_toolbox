function [model] = rvr_train(X, y, options)
% RVM_TRAIN Trains an RVM Model using SB1 Tipping Toolbox
%
%   input ----------------------------------------------------------------
%
%       o X        : (N x D), N  input data points of D dimensionality.
%
%       o y        : (N x 1), N  output data points
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

% Transform Data to Columns
X = X(:);
y = y(:);

% Parsing Parameter for RVR
N	= length(X);
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
% 
initAlpha	= (1/N)^2;
epsilon		= std(y) * 10/100; % Initial guess of 10% noise-to-signal
initBeta	= 1/epsilon^2;

%% Train RVR Model

% "Train" a sparse Bayes kernel-based model (relevance vector machine) 
[weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(X,y,initAlpha,initBeta,kernel_,width,useBias,maxIts,monIts);

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
model.RVs_idx  = used;
model.bias     = bias;
model.marginal = marginal;
model.alpha    = alpha;
model.beta     = beta;
model.gamma    = gamma;
model.RVs      = X(used,:);

end