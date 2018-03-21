function [y,dy] = div_gmc(dx,x,Mu_x,Mu_dx,Sigma_dxdx,Sigma_xx,Sigma_dxx,Sigma_xdx)
%GMC_DIV Derivative of the conditional Gaussian Mixture model P(dx|x)
%
%    sqrt((2*pi)^nbVar * (abs(det(Sigma))+realmin))
%   check the derivative of  log exp(- 0.5 * (dx - \Mu_{dx|x})'(\Sigma_{dx|x}^-1) (dx - \Mu_{dx|x})  )
%
%   input -----------------------------------------------------------------
%
%       o dx : (P x 1)
%
%       o x  : (Q x 1)
%   
%       o Mu_dx : (P x 1), $\mu_{\dot{x}}$
%
%       o Mu_x  : (Q x 1), $\mu_x$
%
%           P + Q = D
%
%       o Sigma_dxdx   : (P x P), covariance between dx and dx
%           
%       o Sigma_{dx,x} : (P x Q), covarariance between dx and x
%
%       o Sigma_{x,x}  : (Q x Q), covariance between x and x
%
%       o Sigma_{x,dx} : (Q x P),  covariance between x and dx
%
%


x   = x(:);
dx  = dx(:);
P   = size(Mu_dx,1);


% (P x 1) = (P x 1) + (P x Q)    (Q x Q)    *  (Q x 1) - (Q x 1)    
% (P x 1) =           (P x 1)
invSig_xx   =  inv(Sigma_xx);
% (P x Q) = (P x Q) * (Q x Q) 
A           = Sigma_dxx * invSig_xx;

% (P x 1)
Mu_dx_x = Mu_dx + A * (x - Mu_x);

% (P x P)
Sigma_dx_x = Sigma_dxdx - A * Sigma_xdx;


%  (P x N) 
invSigma_dx_x = inv(Sigma_dx_x);
%norm_fac      = 0.9;%1/( (2*pi^(P/2)) * sqrt(det(Sigma_dx_x)));
%norm_fac      = -P/2 * log(pi) - 0.5*log(det(Sigma_dx_x));
denom         = sqrt((2*pi)^P * (abs(det(Sigma_dx_x))+realmin));
%norm_fac      = log(1/denom);
norm_fac      = -log(denom);
%norm_fac      = -log(sqrt((2*pi)^P) - log(abs(det(Sigma_dx_x))+realmin));


%y             =  norm_fac .* exp(-0.5 .* (dx - Mu_dx_x)' * (invSigma_dx_x *  (dx - Mu_dx_x)));
y             =   norm_fac + (-0.5 .* (dx - Mu_dx_x)' * (invSigma_dx_x *  (dx - Mu_dx_x)));


% 
% (dx - Mu_dx_x)' * (invSigma_dx_x *  (dx - Mu_dx_x))
% 
% (dx' * invSigma_dx_x - Mu_dx_x' * invSigma_dx_x) * (dx - Mu_dx_x)
% dx' * invSigma_dx_x * dx - Mu_dx_x' * invSigma_dx_x * dx - dx' * invSigma_dx_x * Mu_dx_x +  Mu_dx_x' * invSigma_dx_x * Mu_dx_x
% 
% dx' * invSigma_dx_x * dx - 2 * Mu_dx_x' * invSigma_dx_x * dx  +  Mu_dx_x' * invSigma_dx_x * Mu_dx_x
% 
% dx' * invSigma_dx_x * dx - 2 * (Mu_dx + A * (x - Mu_x))' * invSigma_dx_x * dx  +  (Mu_dx + A * (x - Mu_x))' * invSigma_dx_x * (Mu_dx + A * (x - Mu_x))
% 'here'
% tmp1  = (x - Mu_x)' * A' * invSigma_dx_x;
% 
% part1 = dx' * invSigma_dx_x * dx  - 2 *Mu_dx' *invSigma_dx_x * dx  - 2 * tmp1 * dx;
% 
% part1 + (Mu_dx' * invSigma_dx_x + tmp1) * (Mu_dx + A * (x - Mu_x))
%  'max expansion'
% part1 + Mu_dx' * invSigma_dx_x * Mu_dx + tmp1 * Mu_dx + Mu_dx' * invSigma_dx_x * (A * (x - Mu_x)) + tmp1 * (A * (x - Mu_x))
% 
% part1 + Mu_dx' * invSigma_dx_x * Mu_dx + tmp1 * Mu_dx + tmp1 * Mu_dx + tmp1 * (A * (x - Mu_x))
% 
% 
% dx' * invSigma_dx_x * dx  - 2 *Mu_dx' *invSigma_dx_x * dx +  Mu_dx' * invSigma_dx_x * Mu_dx  - 2 * tmp1 * dx  + tmp1 * Mu_dx + tmp1 * Mu_dx + tmp1 * (A * (x - Mu_x))
% 
% dx' * invSigma_dx_x * dx  - 2 *Mu_dx' *invSigma_dx_x * dx +  Mu_dx' * invSigma_dx_x * Mu_dx +  tmp1 * (- 2 * dx  + Mu_dx + Mu_dx + (A * (x - Mu_x)));

%fac = (x - Mu_x)' * A' * invSigma_dx_x;
% y2 = dx' * invSigma_dx_x * dx   -2 *Mu_dx' *invSigma_dx_x * dx +  Mu_dx' * invSigma_dx_x * Mu_dx + fac * (-2*dx + 2*Mu_dx + A * (x - Mu_x));        
% 
% y2 = exp(-0.5 .* y2);



if nargout > 1
    %                                         
    %          -            (1 x P)          (1 x P)                      (1 x P)
%    dy = y .* ((dx' * invSigma_dx_x)' - (Mu_dx' * invSigma_dx_x)' - fac' );
 %   dy = ((dx' * invSigma_dx_x)' - (Mu_dx' * invSigma_dx_x)' - ( (x - Mu_x)' * A' * invSigma_dx_x)' );
    dy = invSigma_dx_x' * ( dx - Mu_dx  -  ((x - Mu_x)' * A')' );


end





end

