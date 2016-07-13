% SB1_EXAMPLEREGRESS   Example of Sparse Bayes Regression
%
% SB1_EXAMPLEREGRESS(N,NOISE,KERNEL,WIDTH,MAXITS)
%
% INPUT ARGUMENTS:
%
%       N       Number of training points
%       NOISE   Noise standard deviation to be added
%       KERNEL  Kernel function to use (see SB1_KERNELFUNCTION)
%       WIDTH   Kernel length scale parameter
%       MAXITS  Maximum number of iterations to run for
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function SB1_ExampleRegress(N,noise,kernel_,width,maxIts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set verbosity of output (0 to 4)
setEnvironment('Diagnostic','verbosity',3);
% Set file ID to write to (1 = stdout)
setEnvironment('Diagnostic','fid',1);

%
% Set default values for data and model
% 
useBias	= true;
randn('state',1)
if nargin==0
  N		= 100;
  noise		= 0.1;
  kernel_	= 'gauss';
  width		= 3;
  maxIts	= 1200;
end
monIts		= round(maxIts/10);
%
% Generate example data from sinc function
% 
x	= 10*[-1:2/(N-1):1]';
y	= sin(abs(x))./abs(x);
t	= y + noise*randn(N,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

COL_data	= 'k';
COL_sinc	= 0.5*ones(1,3);
COL_rv		= 'r';
COL_pred	= 'r';

%
% Plot the data and function
% 
figure(1)
whitebg(1,'w')
clf
h_y = plot(x,y,'--','LineWidth',3,'Color',COL_sinc);
hold on
plot(x,t,'.','MarkerSize',16,'Color',COL_data)
box = [-10.1 10.1 1.1*[min(t) max(t)]];
axis(box)
set(gca,'FontSize',12)
drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Set up initial hyperparameters - precise settings should not be critical
% 
initAlpha	= (1/N)^2;
epsilon		= std(t) * 10/100; % Initial guess of 10% noise-to-signal
initBeta	= 1/epsilon^2;
%
% "Train" a sparse Bayes kernel-based model (relevance vector machine)
% 
[weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(x,t,initAlpha,initBeta,kernel_,width,useBias,maxIts,monIts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Visualise the results
% 
% Evaluate the model over the training data
%
PHI	= SB1_KernelFunction(x,x,kernel_,width);
y_rvm	= PHI(:,used)*weights + bias;
%
% Plot the model and relevance vectors
% 
h_yrvm	= plot(x,y_rvm,'-','LineWidth',3,'Color',COL_pred);
h_rv	= plot(x(used),t(used),'o','LineWidth',2,'MarkerSize',10,...
	       'Color',COL_rv);
%
legend([h_y h_yrvm h_rv],'sinc function','RVM predictor','RVs')
hold off
title('Sparse Bayesian regression with noisy ''sinc'' data','FontSize',14)
%
% Output some info
% 
SB1_Diagnostic(1,'Sparse Bayesian regression test error (RMS): %g\n', ...
	sqrt(mean((y-y_rvm).^2)))
SB1_Diagnostic(1,'Estimated noise level: %.4f (true: %.4f)\n', ...
	sqrt(1/beta), noise)
