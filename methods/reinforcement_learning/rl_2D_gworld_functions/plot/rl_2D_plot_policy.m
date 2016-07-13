function [ h_p ] = rl_2D_plot_policy(X,Y,Q,actions,dx,dy,h_p)
%RL_2D_PLOT_POLICY
%
%   input -----------------------------------------------------------------
%
%       o X       : meshgrid X values.
%   
%       o Y       : meshgrid Y values
%
%       o Q       : (num_states x num_actions)
%
%       o actions : (M x 2)
%
%       o h_p     : plot function handle    
%

[~,idx] = max(Q,[],2); 
uv      = 0.5 .* actions(idx,:);
   

if isempty(h_p)
    h_p = quiver(X,Y,uv(:,1),uv(:,2),0,'Color',[0 0 0],'Linewidth',2);    
else
    
    set(h_p,'UData',uv(:,1),'VData',uv(:,2));
    
end



end

