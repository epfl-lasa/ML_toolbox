function [ h_p ] = rl_2D_plot_policy_uw(U,X,Y,h_p )
%RL_2D_PLOT_POLICY_UW Summary of this function goes here
%   Detailed explanation goes here


if isempty(h_p)
    h_p = quiver(X,Y,U(:,1),U(:,2),0,'Color',[0 0 0],'Linewidth',2);    
else
    
    set(h_p,'UData',U(:,1),'VData',U(:,2));
    
end

end

