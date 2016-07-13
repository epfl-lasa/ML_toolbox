function [ mu_F,sd_F ] = get_mu_sd_xurxp( xurxp )
%GET_MU_SD_XURXP Summary of this function goes here
%   Detailed explanation goes here

F     = [];
for i=1:size(xurxp,1)
     F   = [F;xurxp{i}.F];
end
mu_F = mean(F);
sd_F = std(F);

end

