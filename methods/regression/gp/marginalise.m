function [PA,PO,dX] = marginalise(Xdata,ydata,Xtest,GP,ns)
%                       Xdata,Ydata,GPvar,RBF_GP_var,20,20
%
%   input -----------------------------------------------------------------
%
%       ------ Sample points ----------------------
%           
%       o Xtest: (D x N), points to compute the joint distribution
%
%       ------ Gaussian Process parameters --------
%
%       o X: (D x N), set of stat points 
%
%       o y: (1 x N), value at the each point
%       
%       -------------------------------------------
%
%       o ns: (1 x D), sizes of joint dimensions nx = ns(1), ny = ns(2),...
%
%   output ----------------------------------------------------------------
%
%       o Mu: (1 x M), Gaussian Process smoothed y values at query points
%
%       o hy: (1 x M), marginal values at chosen discrete points
%

[D,N] = size(Xtest);

max_x = max(Xtest')';
min_x = min(Xtest')';

dX = abs(max_x - min_x)./ns';

PAO = GP(Xdata,ydata,Xtest);
PAO = reshape(PAO,ns);

if D == 2

    PA = sum(PAO.*dX(2),1);
    PO = sum(PAO.*dX(1),2);
    PA = PA(:);
    PO = PO(:);

else
   
    PA = sum(sum(PAO .* dX(3),4) .* dX(4),3);
    PO = sum(sum(PAO .* dX(2),1) .* dX(1),2);
    PA = squeeze(PA);
    PO = squeeze(PO);
    
end






end