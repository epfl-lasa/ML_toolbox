function [Data] = get_advantage_data(xurxp,V,disc,mu_F,sd_F)
% GET_ADVANTAGE_DATA
%
%   input -----------------------------------------------------------------
%
%       o Data : cell(N,1) 
%
%       o V    : function handle, value function V(x)
%
%       o disc : (1 x 1), discount factor
%
%   output ----------------------------------------------------------------
%
%       o 
%

if ~exist('mu_F'), mu_F = 0; end;
if ~exist('sd_F'), sd_F = 1; end


Data = [];
% A(x,u) = r(x,u) + \gamma * V(xp) - V(x)

for i=1:size(xurxp,1)
    F       = (xurxp{i}.F - mu_F)./sd_F;
    vf      = V.f(F);
    
    FP      = (xurxp{i}.FP - mu_F)./sd_F;
    vfp     = V.f(FP);
    
    U       = xurxp{i}.U;
    R       = xurxp{i}.R;
    
    A       = R + disc * vfp - vf;
    A(end) = R(end);
    
    Data = [Data,[F';U';A']];
    
end



end

