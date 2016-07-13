% function [beta,yq,P,w,r2,dof] = lwr(X,Y,D,xq,ridgecoef,const) 
%
% Locally Weighted Regression: The function performs locally
% weighted regression as explained in the reference below.
% Some simple statistical values are also computed on demand.
%
% Inputs: (pass [] to obtain default value)
%
% X     - input data matrix
% Y     - output data matrix
% D     - distance metric (optional, default is global regression)
% xq    - query vector (optional, default is zero vector)
% ridgecoef - distance metric (optional, default is zero vector)
% const - 0 or 1, i.e., add constant column no or yes (default yes)
%
% Outputs:
%
% beta  - regression coefficients
% yq    - prediction for xq
% P     - inverted weighted covariance matrix
% w     - vector of weights of each data point
% r2    - coefficient of determination (computationally expensive)
% dof   - degrees of freedom in regression (computationally expensive,
%         so better avoid this output argument if not needed)
%
% Reference: Schaal, S., & Atkeson, C. G. (1994). Assessing the quality of 
% learned local models. In J. Cowan, G. Tesauro, & J. Alspector (Eds.), 
% Advances in Neural Information Processing Systems 6 (pp. 160-167). 
% San Mateo, CA: Morgan Kaufmann.

% 	Stefan Schaal, March 2002

function [beta,yq,P,w,r2,dof] = lwr(X,Y,D,xq,ridgecoef,const) 

% How big are the data matrices?
[n,dx] = size(X);
[n,dy] = size(Y);
nfit    = dx;

% initialize query point
if (~exist('xq') | isempty(xq)),
  xq = [];
end;

% subtract query point for simpler computations
Xq = X;
if ~isempty(xq),
  Xq = X - ones(n,1)*xq';
end;

% should constant be avoided?
if (~exist('const') | isempty(const)),
  X = [X ones(n,1)];
	xq = [xq;1];
	const = [];
	nfit = dx+1;
end;

% ridgecoef regression if numerical stability or biasing is needed
if (~exist('ridgecoef') | isempty(ridgecoef)),
  ridgecoef = zeros(nfit,1);
end;


% global or locally weighted regression?
if (~exist('D') | isempty(D)),
	
	% just use weights that are all equal to one
  D  = [];
	wX = X;
	w  = ones(n,1);
	
else,  % weighting if desired 

  % calculate Mahalanobis distance
	mahal = sum((Xq(:,1:dx)*D).*Xq(:,1:dx),2);
	
	% the weighting kernel is Gaussian
  w     = exp(-0.5*mahal);
	
  %  weight the data
	wX    = X.*(w*ones(1,nfit));
	
end;

% perform the regression
P = inv(wX'*X + diag(ridgecoef));
beta = P*wX'*Y;
yq = xq'*beta;

% check whether r2 is required
if nargout > 4,
  wY   = Y.*(w*ones(1,dy));
	mY   = sum(wY)/sum(w);
	mzY  = Y-ones(n,1)*mY;
	vY   = sum((mzY.*(w*ones(1,dy))).*mzY)/sum(w);
	res  = Y-X*beta;
	MSE  = sum((res.*(w*ones(1,dy))).*res)/sum(w);
	r2   = ((vY-MSE)./vY)';
end;

% check whether dof is required
if nargout > 5,
	dof  = sum(sum((wX'*wX).*P));
end;
