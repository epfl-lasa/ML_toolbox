function [varargout] = lwpr(action,varargin)
% lwpr implements the LWPR algorithm as suggested in
% Vijayakumar, S. & Schaal, S. (2003). Incremental Online Learning
% in High Dimensions. submitted.
% Depending on the keyword in the input argument "action", a certain
% number of inputs arguments will be parsed from "vargin". A variable
% number of arguments are returned according to the "action".
% See Matlab file for explanations how to use the different modalitiesn_data
% of the program.
%
% Note: this implementation does not implement ridge regression. Newer
%       algorithms like LWPR and LWPPLS are much more suitable for
%       high dimensional data sets and data with ill conditioned
%       regression matrices.
%
% Copyright Stefan Schaal, September 2002

% ---------------  Different Actions of the program ------------------------

% Initialize an LWPR model:
%
% FORMAT lwpr('Init',ID, n_in, n_out, diag_only, meta, meta_rate, ...
%              penalty, init_alpha, norm, name)
% ID              : desired ID of model
% n_in            : number of input dimensions
% n_out           : number of output dimensions
% diag_only       : 1/0 to update only the diagonal distance metric
% meta            : 1/0 to allow the use of a meta learning parameter
% meta_rate       : the meta learning rate
% penalty         : a smoothness bias, usually a pretty small number (1.e-4)
% init_alpha      : the initial learning rates
% norm            : the normalization of the inputs
% norm_out        : the normalization of the outputs
% name            : a name for the model
%
% alternatively, the function is called as
%
% FORMAT ID = lwpr('Init',ID,lwpr,)
% lwpr            : a complete data structure of a LWPR model
%
% returns nothing


% Change a parameter of an LWPR model:
%
% FORMAT rc = lwpr('Change',ID,pname,value)
% ID              : lwpr data structure
% pname           : name of parameter to be changed
% value           : new parameter value
%
% returns nothing


% Update an LWPR model with new data:
%
% FORMAT [yp,w,np] = lwpr('Update',ID,x,y)
% ID              : lwpr data structure
% x               : input data point
% y               : output data point
%
% Note: the following inputs are optional in order to use LWPR
%       in adaptive learning control with composite update laws
% e               : the tracking error of the control system
% alpha           : a strictly positive scalar to determine the
%                   magnitude of the contribution to the update
%
% returns the prediction after the update, yp, the weight of the
% maximally activated weight, and the average number of projections


% Predict an output for a LWPR model
%
% FORMAT [yp,w,conf] = lwpr('Predict',ID,x)
% ID              : lwpr data structure
% x               : input data point
% cutoff          : minimal activation for prediction
%
% returns the prediction yp and the weight of the maximally activated
% weight. If 'conf' is provided, prediction intervals are computed, too,
% which is, however, a more expensive computation due to t-tests.


% Return the data structure of a LWPR model
%
% FORMAT [lwpr] = lwpr('Structure',ID)
% ID              : lwpr data structure
%
% returns the complete data structure of a LWPR model, e.g., for saving or
% inspecting it


% Clear the data structure of a LWPR model
%
% FORMAT lwpr('Clear',ID)
% ID              : lwpr data structure
%
% returns nothing

% the structure storing all LWPR models
global lwprs;


if nargin < 2,
  error('Incorrect call to lwpr');
end

switch action,

  %..............................................................................
  % Initialize a new LWPR model
  case 'Init'

    % check whether a complete model was
    % given or data for a new model

    if (nargin == 3)

      ID       = varargin{1};
      lwprs(ID) = varargin{2};

    else

      % copy from input arguments
      ID                   = varargin{1};
      lwprs(ID).n_in       = varargin{2};
      lwprs(ID).n_out      = varargin{3};
      lwprs(ID).diag_only  = varargin{4};
      lwprs(ID).meta       = varargin{5};
      lwprs(ID).meta_rate  = varargin{6};
      lwprs(ID).penalty    = varargin{7};
      lwprs(ID).init_alpha = varargin{8};
      lwprs(ID).norm       = varargin{9};
      lwprs(ID).norm_out   = varargin{10};
      lwprs(ID).name       = varargin{11};

      % add additional convenient variables
      lwprs(ID).n_data       = 0;
      lwprs(ID).w_gen        = 0.1;
      lwprs(ID).w_prune      = 0.9;
      lwprs(ID).init_lambda  = 0.999;
      lwprs(ID).final_lambda = 0.9999;
      lwprs(ID).tau_lambda   = 0.99999;
      lwprs(ID).init_P       = 1;
      lwprs(ID).n_pruned     = 0;
      lwprs(ID).add_threshold= 0.5;

      % other variables
      lwprs(ID).init_D         = eye(lwprs(ID).n_in)*25;
      lwprs(ID).init_M         = chol(lwprs(ID).init_D);
      lwprs(ID).init_alpha     = ones(lwprs(ID).n_in)*lwprs(ID).init_alpha;
      lwprs(ID).mean_x         = zeros(lwprs(ID).n_in,1);
      lwprs(ID).var_x          = zeros(lwprs(ID).n_in,1);
      lwprs(ID).rfs            = [];
      lwprs(ID).kernel         = 'Gaussian'; % can also be 'BiSquare'
      lwprs(ID).max_rfs        = 1000;
      lwprs(ID).allow_D_update = 1;
      lwprs(ID).conf_method    = 'std'; % can also be 't-test', but requires statistics toolbox


    end


    %..............................................................................
  case 'Change'

    ID = varargin{1};
    command = sprintf('lwprs(%d).%s = varargin{3};',ID,varargin{2});
    eval(command);

    % make sure some initializations remain correct
    lwprs(ID).init_M       = chol(lwprs(ID).init_D);


    %..............................................................................
  case 'Update'
    ID  = varargin{1};
    x   = varargin{2};
    y   = varargin{3};

    if (nargin > 4)
      composite_control = 1;
      e_t   = varargin{4};
      alpha = varargin{5};
    else
      composite_control = 0;
    end

    % update the global mean and variance of the training data for
    % information purposes
    lwprs(ID).mean_x = (lwprs(ID).mean_x*lwprs(ID).n_data + x)/(lwprs(ID).n_data+1);
    lwprs(ID).var_x  = (lwprs(ID).var_x*lwprs(ID).n_data + (x-lwprs(ID).mean_x).^2)/(lwprs(ID).n_data+1);
    lwprs(ID).n_data = lwprs(ID).n_data+1;

    % normalize the inputs
    xn = x./lwprs(ID).norm;

    % normalize the outputs
    yn = y./lwprs(ID).norm_out;

    % check all RFs for updating
    % wv is a vector of 3 weights, ordered [w; sec_w; max_w]
    % iv is the corresponding vector containing the RF indices
    wv = zeros(3,1);
    iv = zeros(3,1);
    yp = zeros(size(y));
    sum_w = 0;
    sum_n_reg = 0;
    tms = zeros(length(lwprs(ID).rfs));

    for i=1:length(lwprs(ID).rfs),

      % compute the weight and keep the three larget weights sorted
      w  = compute_weight(lwprs(ID).diag_only,lwprs(ID).kernel,lwprs(ID).rfs(i).c,lwprs(ID).rfs(i).D,xn);
      lwprs(ID).rfs(i).w = w;
      wv(1) = w;
      iv(1) = i;
      [wv,ind]=sort(wv);
      iv = iv(ind);

      % keep track of the average number of projections
      sum_n_reg = sum_n_reg + length(lwprs(ID).rfs(i).s);

      % only update if activation is high enough
      if (w > 0.001),

        rf = lwprs(ID).rfs(i);

        % update weighted mean for xn and y, and create mean-zero
        % variables
        [rf,xmz,ymz] = update_means(lwprs(ID).rfs(i),xn,yn,w);

        % update the regression
        [rf,yp_i,e_cv,e] = update_regression(rf,xmz,ymz,w);
        if (rf.trustworthy),
          yp = w*yp_i + yp;
          sum_w = sum_w + w;
        end

        % update simple statistical variables
        rf.sum_w  = rf.sum_w.*rf.lambda + w;
        rf.n_data = rf.n_data.*rf.lambda + 1;
        rf.lambda = lwprs(ID).tau_lambda * rf.lambda + lwprs(ID).final_lambda*(1.-lwprs(ID).tau_lambda);

        % update the distance metric
        [rf,tm] = update_distance_metric(ID,rf,xmz,ymz,w,e_cv,e,xn);
        tms(i) = 1;

        % check whether a projection needs to be added
        rf = check_add_projection(ID,rf);

        % incorporate updates
        lwprs(ID).rfs(i) = rf;

      else

        lwprs(ID).rfs(i).w = 0;

      end % if (w > 0.001)

    end

    mean_n_reg = sum_n_reg/(length(lwprs(ID).rfs)+1.e-10);


    % if LWPR is used for control, incorporate the tracking error
    if (composite_control),
      inds = find(tms > 0);
      if ~isempty(inds),
        for j=1:length(inds),
          i = inds(j);
          lwprs(ID).rfs(i).B  = lwprs(ID).rfs(i).B  + alpha * tms(j)./ lwprs(ID).rfs(i).ss2      * lwprs(ID).rfs(i).w/sum_w .* (xn-lwprs(ID).rfs(i).c) * e_t;
          lwprs(ID).rfs(i).b0 = lwprs(ID).rfs(i).b0 + alpha * tms(j) / lwprs(ID).rfs(i).sum_w(1) * lwprs(ID).rfs(i).w/sum_w  * e_t;
        end
      end
    end


    % do we need to add a new RF?
    if (wv(3) <= lwprs(ID).w_gen & length(lwprs(ID).rfs)<lwprs(ID).max_rfs),
      if (wv(3) > 0.1*lwprs(ID).w_gen & lwprs(ID).rfs(iv(3)).trustworthy),
        lwprs(ID).rfs(length(lwprs(ID).rfs)+1)=init_rf(ID,lwprs(ID).rfs(iv(3)),xn,yn);
      else
        if (length(lwprs(ID).rfs)==0),
          lwprs(ID).rfs = init_rf(ID,[],xn,y);
        else
          lwprs(ID).rfs(length(lwprs(ID).rfs)+1) = init_rf(ID,[],xn,yn);
        end
      end
    end

    % do we need to prune a RF? Prune the one with smaller D
    if (wv(2:3) > lwprs(ID).w_prune),
      if (sum(sum(lwprs(ID).rfs(iv(2)).D)) > sum(sum(lwprs(ID).rfs(iv(3)).D)))
        lwprs(ID).rfs(iv(2)) = [];
        disp(sprintf('%d: Pruned #RF=%d',ID,iv(2)));
      else
        lwprs(ID).rfs(iv(3)) = [];
        disp(sprintf('%d: Pruned #RF=%d',ID,iv(3)));
      end
      lwprs(ID).n_pruned = lwprs(ID).n_pruned + 1;
    end

    % the final prediction
    if (sum_w > 0),
      yp = yp.*lwprs(ID).norm_out/sum_w;
    end

    varargout(1) = {yp};
    varargout(2) = {wv(3)};
    varargout(3) = {mean_n_reg};


    %..............................................................................
  case 'Predict'
    ID     = varargin{1};
    x      = varargin{2};
    cutoff = varargin{3};

    if nargout == 3,
      compute_conf = 1;
    else
      compute_conf = 0;
    end

    % normalize the inputs
    xn = x./lwprs(ID).norm;

    % maintain the maximal activation
    max_w = 0;
    yp = zeros(lwprs(ID).n_out,1);
    sum_w = 0;
    sum_conf = 0;
    sum_yp2  = 0;

    for i=1:length(lwprs(ID).rfs),

      % compute the weight
      w  = compute_weight(lwprs(ID).diag_only,lwprs(ID).kernel,lwprs(ID).rfs(i).c,lwprs(ID).rfs(i).D,xn);
      lwprs(ID).rfs(i).w = w;
      max_w = max([max_w,w]);

      % only predict if activation is high enough
      if (w > cutoff & lwprs(ID).rfs(i).trustworthy),

        % the mean zero input
        xmz = xn - lwprs(ID).rfs(i).mean_x;

        % compute the projected inputs
        s = compute_projection(xmz,lwprs(ID).rfs(i).W,lwprs(ID).rfs(i).U);

        % the prediction
        aux = lwprs(ID).rfs(i).B'*s + lwprs(ID).rfs(i).b0;
        yp = yp + aux * w;
        sum_yp2 = sum_yp2 + aux^2 * w;
        sum_w = sum_w + w;

        % confidence intervals if needed
        if (compute_conf)
          dofs = lwprs(ID).rfs(i).sum_w(1)-lwprs(ID).rfs(i).n_dofs;
          switch (lwprs(ID).conf_method),
            case 'std'
              sum_conf = sum_conf + w*lwprs(ID).rfs(i).sum_e2/dofs*(1+(s./lwprs(ID).rfs(i).ss2)'*s*w);
            case 't-test'
              sum_conf = sum_conf + tinv(0.975,dofs)^2*w*lwprs(ID).rfs(i).sum_e2/dofs*(1+(s./lwprs(ID).rfs(i).ss2)'*s*w);
          end
        end

      end % if (w > cutoff)

    end

    % the final prediction
    if (sum_w > 0),
      yp = yp/sum_w;
      aux = (sum_yp2/sum_w - yp.^2)*sum_w/sum_w^2;
      conf = sqrt(sum_conf/sum_w^2 + aux);
      yp = yp.*lwprs(ID).norm_out;
      conf = conf.*lwprs(ID).norm_out;
    end

    varargout(1) = {yp};
    varargout(2) = {max_w};
    if compute_conf,
      varargout(3) = {conf};
    end


    %..............................................................................
  case 'Structure'
    ID     = varargin{1};

    varargout(1) = {lwprs(ID)};


    %..............................................................................
  case 'Clear'
    ID     = varargin{1};

    lwprs(ID) = [];

end


%-----------------------------------------------------------------------------
function rf=init_rf(ID,template_rf,c,y)
% initialize a local model

global lwprs;

if ~isempty(template_rf),
  rf = template_rf;
else
  rf.D     = lwprs(ID).init_D;
  rf.M     = lwprs(ID).init_M;
  rf.alpha = lwprs(ID).init_alpha;
  rf.b0    = y;                             % the weighted mean of output
end

% if more than univariate input, start with two projections such that
% we can compare the reduction of residual error between two projections
n_in = lwprs(ID).n_in;
n_out = lwprs(ID).n_out;
if (n_in > 1)
  n_reg = 2;
else
  n_reg = 1;
end

rf.B           = zeros(n_reg,lwprs(ID).n_out); % the regression parameters
rf.c           = c;                         % the center of the RF
rf.SXresYres   = zeros(n_reg,n_in);         % needed to compute projections
rf.ss2         = ones(n_reg,1)/lwprs(ID).init_P; % variance per projection
rf.SSYres      = zeros(n_reg,n_out);        % needed to compute linear model
rf.SSXres      = zeros(n_reg,n_in);         % needed to compute input reduction
rf.W           = eye(n_reg,n_in);           % matrix of projections vectors
rf.Wnorm       = zeros(n_reg,1);            % normalized projection vectors
rf.U           = eye(n_reg,n_in);           % reduction of input space
rf.H           = zeros(n_reg,n_out);        % trace matrix
rf.r           = zeros(n_reg,1);            % trace vector
rf.h           = zeros(size(rf.alpha));     % a memory term for 2nd order gradients
rf.b           = log(rf.alpha+1.e-10);      % a memory term for 2nd order gradients
rf.sum_w       = ones(n_reg,1)*1.e-10;      % the sum of weights
rf.sum_e_cv2i  = zeros(n_reg,1);            % weighted sum of cross.valid. err. per dim
rf.sum_e_cv2   = 0;                         % weighted sum of cross.valid. err. of final output
rf.sum_e2      = 0;                         % weighted sum of error (not CV)
rf.n_data      = ones(n_reg,1)*1.e-10;      % discounted amount of data in RF
rf.trustworthy = 0;                         % indicates statistical confidence
rf.lambda      = ones(n_reg,1)*lwprs(ID).init_lambda; % forgetting rate
rf.mean_x      = zeros(n_in,1);             % the weighted mean of inputs
rf.var_x       = zeros(n_in,1);             % the weighted variance of inputs
rf.w           = 0;                         % store the last computed weight
rf.s           = zeros(n_reg,1);            % store the projection of inputs
rf.n_dofs      = 0;                         % the local degrees of freedom

%-----------------------------------------------------------------------------
function w=compute_weight(diag_only,kernel,c,D,x)
% compute the weight

% subtract the center
x = x-c;

if diag_only,
  d2 = x'*(diag(D).*x);
else,
  d2 = x'*D*x;
end

switch kernel
  case 'Gaussian'
    w = exp(-0.5*d2);
  case 'BiSquare'
    if (0.5*d2 > 1)
      w = 0;
    else
      w = (1-0.5*d2)^2;
    end
end


%-----------------------------------------------------------------------------
function [rf,xmz,ymz]=update_means(rf,x,y,w)
% update means and computer mean zero variables

rf.mean_x = (rf.sum_w(1)*rf.mean_x*rf.lambda(1) + w*x)/(rf.sum_w(1)*rf.lambda(1)+w);
rf.var_x  = (rf.sum_w(1)*rf.var_x*rf.lambda(1) + w*(x-rf.mean_x).^2)/(rf.sum_w(1)*rf.lambda(1)+w);
rf.b0     = (rf.sum_w(1)*rf.b0*rf.lambda(1) + w*y)/(rf.sum_w(1)*rf.lambda(1)+w);
xmz = x - rf.mean_x;
ymz = y - rf.b0;


%-----------------------------------------------------------------------------
function [rf,yp,e_cv,e] = update_regression(rf,x,y,w)
% update the linear regression parameters

[n_reg,n_in] = size(rf.W);
n_out = length(y);

% compute the projection
[rf.s,xres] = compute_projection(x,rf.W,rf.U);

% compute all residual errors and targets at all projection stages
yres  = rf.B .* (rf.s*ones(1,n_out));
for i=2:n_reg
  yres(i,:) = yres(i,:) + yres(i-1,:);
end
yres  = ones(n_reg,1)*y' - yres;
e_cv  = yres;
ytarget = [y';yres(1:n_reg-1,:)];

% update the projections
lambda_slow = 1-(1-rf.lambda)/10;
rf.SXresYres = rf.SXresYres .* (lambda_slow*ones(1,n_in)) + w * (sum(ytarget,2)*ones(1,n_in)).*xres;
rf.Wnorm = sqrt(sum(rf.SXresYres.^2,2))+1.e-10;
rf.W = rf.SXresYres ./ (rf.Wnorm * ones(1,n_in));

% update sufficient statistics for regressions
rf.ss2 = rf.lambda .* rf.ss2 + rf.s.^2 * w;
rf.SSYres = (rf.lambda*ones(1,n_out)) .* rf.SSYres + w * ytarget .* ...
  (rf.s*ones(1,n_out));
rf.SSXres = (rf.lambda*ones(1,n_in)) .* rf.SSXres + w * (rf.s*ones(1,n_in)).* xres;

% update the regression and input reduction parameters
rf.B = rf.SSYres ./ (rf.ss2*ones(1,n_out));
rf.U = rf.SSXres ./ (rf.ss2*ones(1,n_in));

% the new predicted output after updating
[rf.s,xres] = compute_projection(x,rf.W,rf.U);
yp = rf.B' * rf.s;
e  = y - yp;
yp = yp + rf.b0;

% is the RF trustworthy: a simple data count
if (rf.n_data > n_in*2)
  rf.trustworthy = 1;
end


%-----------------------------------------------------------------------------
function [rf,transient_multiplier] = update_distance_metric(ID,rf,x,y,w,e_cv,e,xn)

global lwprs;

% update the distance metric

% an indicator vector in how far individual projections are trustworthy
% based on how much data the projection has been trained on
derivative_ok = (rf.n_data > 0.1./(1.-rf.lambda)) & rf.trustworthy;

% useful pre-computations: they need to come before the updates
s                    = rf.s;
e_cv2                = sum(e_cv.^2,2);
e2                   = e'*e;
rf.sum_e_cv2i        = rf.sum_e_cv2i.*rf.lambda + w*e_cv2;
rf.sum_e_cv2         = rf.sum_e_cv2*rf.lambda(1) + w*e_cv2(end);
rf.sum_e2            = rf.sum_e2*rf.lambda(1) + w*e2;
rf.n_dofs            = rf.n_dofs*rf.lambda(1) + w^2*(s./rf.ss2)'*s;
e_cv                 = e_cv(end,:)';
e_cv2                = e_cv'*e_cv;
h                    = w*sum(s.^2./rf.ss2.*derivative_ok);
W                    = rf.sum_w(1);
E                    = rf.sum_e_cv2;
transient_multiplier = (e2/(e_cv2+1.e-10))^4; % this is a numerical safety heuristic
if transient_multiplier > 1, % when adding a projection, this can happen
  transient_multiplier = 1;
end
n_out                = length(y);

penalty   = lwprs(ID).penalty/length(x)*w/W; % normalize penality w.r.t. number of inputs
meta      = lwprs(ID).meta;
meta_rate = lwprs(ID).meta_rate;
kernel    = lwprs(ID).kernel;
diag_only = lwprs(ID).diag_only;

% is the update permissible?
if ~derivative_ok(1) | ~lwprs(ID).allow_D_update,
  transient_multiplier = 0;
  return;
end

% the derivative dJ1/dw
Ps    = s./rf.ss2.*derivative_ok;  % zero the terms with insufficient data support
Pse   = Ps*e';
dJ1dw = -E/W^2 + 1/W*(e_cv2 - sum(sum((2*Pse).*rf.H)) - sum((2*Ps.^2).*rf.r));

% the derivatives dw/dM and dJ2/dM
[dwdM,dJ2dM,dwwdMdM,dJ2J2dMdM] = dist_derivatives(w,rf,xn-rf.c,diag_only,kernel,penalty,meta);

% the final derivative becomes (note this is upper triangular)
dJdM = dwdM*dJ1dw/n_out + dJ2dM;

% the second derivative if meta learning is required, and meta learning update
if (meta)

  % second derivatives
  dJ1J1dwdw = -e_cv2/W^2 - 2/W*sum(sum((-Pse/W -2*Ps*(s'*Pse)).*rf.H)) + 2/W*e2*h/w - ...
    1/W^2*(e_cv2-2*sum(sum(Pse.*rf.H))) + 2*E/W^3;

  dJJdMdM = (dwwdMdM*dJ1dw + dwdM.^2*dJ1J1dwdw)/n_out + dJ2J2dMdM;

  % update the learning rates
  aux = meta_rate * transient_multiplier * (dJdM.*rf.h);

  % limit the update rate
  ind = find(abs(aux) > 0.1);
  if (~isempty(ind)),
    aux(ind) = 0.1*sign(aux(ind));
  end
  rf.b = rf.b - aux;

  % prevent numerical overflow
  ind = find(abs(rf.b) > 10);
  if (~isempty(ind)),
    rf.b(ind) = 10*sign(rf.b(ind));
  end

  rf.alpha = exp(rf.b);

  aux = 1 - (rf.alpha.*dJJdMdM) * transient_multiplier ;
  ind = find(aux < 0);
  if (~isempty(ind)),
    aux(ind) = 0;
  end

  rf.h = rf.h.*aux - (rf.alpha.*dJdM) * transient_multiplier;

end

% update the distance metric, use some caution for too large gradients
maxM = max(max(abs(rf.M)));
delta_M = rf.alpha.*dJdM*transient_multiplier;
ind = find(delta_M > 0.1*maxM);
if (~isempty(ind)),
  rf.alpha(ind) = rf.alpha(ind)/2;
  delta_M(ind) = 0;
  disp(sprintf('Reduced learning rate'));
end

rf.M = rf.M - delta_M;
rf.D = rf.M'*rf.M;

% update sufficient statistics: note this must come after the updates and
% is conditioned on that sufficient samples contributed to the derivative
H = (rf.lambda*ones(1,n_out)).*rf.H + (w/(1-h))*s*e_cv'*transient_multiplier;
r = rf.lambda.*rf.r + (w^2*e_cv2/(1-h))*(s.^2)*transient_multiplier;
rf.H = (derivative_ok*ones(1,n_out)).*H + (1-(derivative_ok*ones(1,n_out))).*rf.H;
rf.r = derivative_ok.*r + (1-derivative_ok).*rf.r;


%-----------------------------------------------------------------------------
function [dwdM,dJ2dM,dwwdMdM,dJ2J2dMdM] = dist_derivatives(w,rf,dx,diag_only,kernel,penalty,meta)
% compute derivatives of distance metric: note that these will be upper
% triangular matrices for efficiency

n_in      = length(dx);
dwdM      = zeros(n_in);
dJ2dM     = zeros(n_in);
dJ2J2dMdM = zeros(n_in);
dwwdMdM   = zeros(n_in);

for n=1:n_in,
  for m=n:n_in,

    sum_aux    = 0;
    sum_aux1   = 0;

    % take the derivative of D with respect to nm_th element of M */

    if (diag_only & n==m),

      aux = 2*rf.M(n,n);
      dwdM(n,n) = dx(n)^2 * aux;
      sum_aux = rf.D(n,n)*aux;
      if (meta)
        sum_aux1 = sum_aux1 + aux^2;
      end

    elseif (~diag_only),

      for i=n:n_in,

        % aux corresponds to the in_th (= ni_th) element of dDdm_nm
        % this is directly processed for dwdM and dJ2dM

        if (i == m)
          aux = 2*rf.M(n,i);
          dwdM(n,m) = dwdM(n,m) + dx(i) * dx(m) * aux;
          sum_aux = sum_aux + rf.D(i,m)*aux;
          if (meta)
            sum_aux1 = sum_aux1 + aux^2;
          end
        else
          aux = rf.M(n,i);
          dwdM(n,m) = dwdM(n,m) + 2. * dx(i) * dx(m) * aux;
          sum_aux = sum_aux + 2.*rf.D(i,m)*aux;
          if (meta)
            sum_aux1 = sum_aux1 + 2*aux^2;
          end
        end

      end

    end

    switch kernel
      case 'Gaussian'
        dwdM(n,m)  = -0.5*w*dwdM(n,m);
      case 'BiSquare'
        dwdM(n,m)  = -sqrt(w)*dwdM(n,m);
    end

    dJ2dM(n,m)  = 2.*penalty*sum_aux;

    if (meta)
      dJ2J2dMdM(n,m) = 2.*penalty*(2*rf.D(m,m) + sum_aux1);
      dJ2J2dMdM(m,n) = dJ2J2dMdM(n,m);
      switch kernel
        case 'Gaussian'
          dwwdMdM(n,m)   = dwdM(n,m)^2/w - w*dx(m)^2;
        case 'BiSquare'
          dwwdMdM(n,m)   = dwdM(n,m)^2/w/2 - 2*sqrt(w)*dx(m)^2;
      end
      dwwdMdM(m,n)   = dwwdMdM(n,m);
    end

  end
end

%-----------------------------------------------------------------------------
function [s,xres] = compute_projection(x,W,U)
% recursively compute the projected input

[n_reg,n_in] = size(W);

s = zeros(n_reg,1);

for i=1:n_reg,
  xres(i,:) = x';
  s(i)      = W(i,:)*x;
  x         = x - U(i,:)'*s(i);
end

%-----------------------------------------------------------------------------
function [rf] = check_add_projection(ID,rf)
% checks whether a new projection needs to be added to the rf

global lwprs;

[n_reg,n_in] = size(rf.W);
[n_reg,n_out]= size(rf.B);

if (n_reg >= n_in)
  return;
end

% here, the mean squared error of the current regression dimension
% is compared against the previous one. Only if there is a signficant
% improvement in MSE, another dimension gets added. Some additional
% heuristics had to be added to ensure that the MSE decision is
% based on sufficient data */

mse_n_reg   = rf.sum_e_cv2i(n_reg)  / rf.sum_w(n_reg) + 1.e-10;
mse_n_reg_1 = rf.sum_e_cv2i(n_reg-1)/ rf.sum_w(n_reg-1) + 1.e-10;

if (mse_n_reg/mse_n_reg_1 < lwprs(ID).add_threshold & ...
    rf.n_data(n_reg)/rf.n_data(1) > 0.99 & ...
    rf.n_data(n_reg)*(1.-rf.lambda(n_reg)) > 0.5),

  rf.B         = [rf.B; zeros(1,n_out)];
  rf.SXresYres = [rf.SXresYres; zeros(1,n_in)];
  rf.ss2       = [rf.ss2;1/lwprs(ID).init_P];
  rf.SSYres    = [rf.SSYres; zeros(1,n_out)];
  rf.SSXres    = [rf.SSXres; zeros(1,n_in)];
  rf.W         = [rf.W; zeros(1,n_in)];
  rf.Wnorm     = [rf.Wnorm; 0];
  rf.U         = [rf.U; zeros(1,n_in)];
  rf.H         = [rf.H; zeros(1,n_out)];
  rf.r         = [rf.r; 0];
  rf.sum_w     = [rf.sum_w; 1.e-10];
  rf.sum_e_cv2i= [rf.sum_e_cv2i; 0];
  rf.n_data    = [rf.n_data; 0];
  rf.lambda    = [rf.lambda; lwprs(ID).init_lambda];
  rf.s         = [rf.s; 0];

end

