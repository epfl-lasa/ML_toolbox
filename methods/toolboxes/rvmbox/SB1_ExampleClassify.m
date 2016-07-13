% SB1_EXAMPLECLASSIFY   Example of Sparse Bayes Classification
%
% SB1_EXAMPLECLASSIFY(N,KERNEL,WIDTH,MAXITS)
%
% INPUT ARGUMENTS:
%
%       N       Number of training points (up to 250)
%       KERNEL  Kernel function to use (see SB1_KERNELFUNCTION)
%       WIDTH   Kernel length scale parameter
%       MAXITS  Maximum number of iterations to run for
% 
% NOTES: The data is taken from the book "Pattern Recognition for
%        Neural Networks" (Ripley). Running SB1_EXAMPLECLASSIFY with
%        no arguments will result in sensible defaults.
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function SB1_ExampleClassify(N,kernel_,width,maxIts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set verbosity of output (0 to 4)
setEnvironment('Diagnostic','verbosity',3);
% Set file ID to write to (1 = stdout)
setEnvironment('Diagnostic','fid',1);

%
% Set default values for data and model
% 
useBias	= true;
%
rand('state',1)
if nargin==0
  % Some acceptable defaults
  % 
  N		= 100;
  kernel_	= 'gauss';
  width		= 0.5;
  maxIts	= 1000;
end
monIts		= round(maxIts/10);
N		= min([250 N]); % training set has fixed size of 250
Nt		= 1000;
%
% Load Ripley's synthetic training data (see reference in doc)
% 
load synth.tr
synth	= synth(randperm(size(synth,1)),:);
X	= synth(1:N,1:2);
t	= synth(1:N,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

COL_data1	= 'k';
COL_data2	= 0.75*[0 1 0];
COL_boundary50	= 'r';
COL_boundary75	= 0.5*ones(1,3);
COL_rv		= 'r';

%
% Plot the training data
% 
figure(1)
whitebg(1,'w')
clf
h_c1	= plot(X(t==0,1),X(t==0,2),'.','MarkerSize',18,'Color',COL_data1);
hold on
h_c2	= plot(X(t==1,1),X(t==1,2),'.','MarkerSize',18,'Color',COL_data2);
box	= 1.1*[min(X(:,1)) max(X(:,1)) min(X(:,2)) max(X(:,2))];
axis(box)
set(gca,'FontSize',12)
drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Set up initial hyperparameters - precise settings should not be critical
% 
initAlpha	= (1/N)^2;
% Set beta to zero for classification
initBeta	= 0;	
%
% "Train" a sparse Bayes kernel-based model (relevance vector machine)
% 
[weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(X,t,initAlpha,initBeta,kernel_,width,useBias,maxIts,monIts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Load Ripley's test set
% 
load synth.te
synth	= synth(randperm(size(synth,1)),:);
Xtest	= synth(1:Nt,1:2);
ttest	= synth(1:Nt,3);
%
% Compute RVM over test data and calculate error
% 
PHI	= SB1_KernelFunction(Xtest,X(used,:),kernel_,width);
y_rvm	= PHI*weights + bias;
errs	= sum(y_rvm(ttest==0)>0) + sum(y_rvm(ttest==1)<=0);
SB1_Diagnostic(1,'RVM CLASSIFICATION test error: %.2f%%\n', errs/Nt*100)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Visualise the results over a grid
% 
gsteps		= 50;
range1		= box(1):(box(2)-box(1))/(gsteps-1):box(2);
range2		= box(3):(box(4)-box(3))/(gsteps-1):box(4);
[grid1 grid2]	= meshgrid(range1,range2);
Xgrid		= [grid1(:) grid2(:)];
size(Xgrid)
%
% Evaluate RVM
% 
PHI		= SB1_KernelFunction(Xgrid,X(used,:),kernel_,width);
y_grid		= PHI*weights + bias;

% apply sigmoid for probabilities
p_grid		= 1./(1+exp(-y_grid)); 

%
% Show decision boundary (p=0.5) and illustrate p=0.25 and 0.75
% 
[c,h05]		= ...
    contour(range1,range2,reshape(p_grid,size(grid1)),[0.5],'-');
[c,h075]	= ...
    contour(range1,range2,reshape(p_grid,size(grid1)),[0.25 0.75],'--');
set(h05, 'Color',COL_boundary50,'LineWidth',3);
set(h075,'Color',COL_boundary75,'LineWidth',2);
%
% Show relevance vectors
% 
h_rv	= plot(X(used,1),X(used,2),'o','LineWidth',2,'MarkerSize',10,...
	       'Color',COL_rv);
%
legend([h_c1 h_c2 h05 h075(1) h_rv],...
       'Class 1','Class 2','Decision boundary','p=0.25/0.75','RVs',...
       'Location','NorthWest')
%
hold off
title('RVM Classification of Ripley''s synthetic data','FontSize',14)
