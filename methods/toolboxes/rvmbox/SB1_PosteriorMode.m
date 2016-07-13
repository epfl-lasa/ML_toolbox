% SB1_POSTERIORMODE     Find mode of posterior distribution (Bernoulli case)
%
%       [W, UI, LMODE] = SB1_POSTERIORMODE(PHI,T,W,ALPHA,ITS)
%
% OUTPUT ARGUMENTS:
%
%       W       Parameter values at mode
%       UI      Inverse Cholesky factor of Hessian
%       LMODE   Log likelihood of data at mode
% 
% INPUT ARGUMENTS:
%
%       PHI     Design matrix
%       T       Target values
%       W       Initial parameter values
%       ALPHA   Vector of corresponding hyperparameters
%       ITS     Maximum iterations to run for
% 
% NOTES:
%
%       The posterior mode finder can on occasion fail due to an
%       ill-conditioned Hessian matrix. This is usually an indication
%       that the kernel matrix is considerably sub-optimal and
%       ill-conditioned itself. Typically this will be due to an
%       excessive "length scale".
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function [w, Ui, lMode] = SB1_PosteriorMode(PHI,t,w,alpha,its)

% This is the per-parameter gradient-norm threshold for termination
GRAD_STOP	= 1e-6;
% Limit to resolution of search step
LAMBDA_MIN	= 2^(-8);

[N d]	= size(PHI);
M 	= length(w);
A	= diag(alpha);
errs	= zeros(its,1);
PHIw	= PHI*w;
y	= sigmoid(PHIw);
t	= logical(t);

% Compute initial value of log posterior (as an error)
% 
data_term	= -(sum(log(y(t))) + sum(log(1-y(~t))))/N;
regulariser	= (alpha'*(w.^2))/(2*N);
err_new		=  data_term + regulariser;

for i=1:its
  %
  yvar	= y.*(1-y);
  PHIV	= PHI .* (yvar * ones(1,d));
  e	= (t-y);
  %
  % Compute gradient vector and Hessian matrix
  % 
  g		= PHI'*e - alpha.*w;
  Hessian	= (PHIV'*PHI + A);
  %
  % If Hessian is ill-conditioned first time round, give up
  % 
  if i==1
    condHess	= rcond(Hessian);
    if condHess<eps
      SB1_Diagnostic(0,'**\n');
      SB1_Diagnostic(0,['** (PosteriorMode) warning: ' ...
			'ill-conditioned Hessian (%g)\n'], condHess);
      SB1_Diagnostic(0,'** Giving up!\n');
      SB1_Diagnostic(0,['** This error was probably caused by an '...
			'ill-conditioned kernel matrix.\n']);
      SB1_Diagnostic(0,['** Try adjusting (reducing) the length scale '...
			'(width) parameter of the kernel\n']);
      SB1_Diagnostic(0,'**\n');
      error('Sorry! Cannot recover from ill-conditioned Hessian.');
    end
  end
  %
  errs(i)	= err_new;
  SB1_Diagnostic(4,'PosteriorMode Cycle: %2d\t error: %.6f\n', i, errs(i));
  %
  % See if converged
  % 
  if i>=2 & norm(g)/M<GRAD_STOP
    errs	= errs(1:i);
    SB1_Diagnostic(4,['(PosteriorMode) converged (<%g) after ' ...
		      '%d iterations, gradient = %g\n'], ...
		   GRAD_STOP,i,norm(g)/M);
    break
  end
  %
  % Take "Newton step" and check for reduction in error
  % 
  U		= chol(Hessian);
  delta_w	= U \ (U' \ g);
  lambda	= 1;
  while lambda>LAMBDA_MIN
    w_new	= w + lambda*delta_w;
    PHIw	= PHI*w_new;
    y		= sigmoid(PHIw);
    %
    % Compute new error 
    % 
    if any(y(t)==0) | any(y(~t)==1)
      err_new	= inf;
    else
      data_term		= -(sum(log(y(t))) + sum(log(1-y(~t))))/N;
      regulariser	= (alpha'*(w_new.^2))/(2*N);
      err_new		=  data_term + regulariser;
    end
    if err_new>errs(i)
      %
      % If error has increased, reduce the step
      % 
      lambda	= lambda/2;
      SB1_Diagnostic(4,['(PosteriorMode) error increase! Backing off ... (' ...
			' %.3f)\n'], lambda);
    else
      %
      % Error has gone down: accept the step
      % 
      w		= w_new;
      lambda	= 0;
    end
  end
  %
  % If we're here with non-zero lambda, then we couldn't take a small
  % enough downhill step: converged close to minimum
  % 
  if lambda
    SB1_Diagnostic(4,['(PosteriorMode) stopping due to back-off limit,' ...
		      'gradient = %g\n'],sum(abs(g)));
    break;
  end
end
%
% Compute requisite values at mode
% 
Ui	= inv(U);
lMode	= -N*data_term;

%%
%% Support function: sigmoid
%%
function y = sigmoid(x)
y = 1./(1+exp(-x));