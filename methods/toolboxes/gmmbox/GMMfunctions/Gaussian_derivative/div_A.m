function [y,dy] = div_A(Sigma_dxxp,Sigma_xx,x,Mu)
%DIV_A
%
%   A = Sigma_dxx * inv(Sigma_xx)
%

Sigma_dxx = [Sigma_dxxp(1) Sigma_dxxp(2); Sigma_dxxp(3) Sigma_dxxp(4)];
invSigma  = inv(Sigma_xx);

y = Sigma_dxx * x;

if nargout > 1
 
    dy = [x(1),x(2),x(1),x(2)];
 
end



end

