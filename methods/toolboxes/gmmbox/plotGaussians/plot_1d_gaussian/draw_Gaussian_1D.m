function [xs,ys] = draw_Gaussian_1D(Mu,Var)
%DRAW_1D_GAUSSIAN Draws a Gaussian function onto axis.
%
%
%   input -----------------------------------------------------------------
%
%       o haxes, axis handle
%
%       o Mu & Sigma of Gaussian

Mu = Mu(:);

D = size(Mu,1);

if D == 1
    
    Max = Mu + 4.0*sqrt(Var);
    Min = Mu - 4.0*sqrt(Var);
    xs=linspace(Min,Max, 400);
    ys = normpdf(xs,Mu,sqrt(Var));
else
    
    disp('Not implemented yet');
    
end


end

