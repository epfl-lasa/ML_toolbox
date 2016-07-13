function rl_2D_plot_reward(reward_f,grid_world,handle)
%RL_2D_PLOT_REWARD


num_states = grid_world.num_states;
R          = zeros(num_states,1);
XY         = [grid_world.X(:),grid_world.Y(:)];

for i=1:num_states
    
    [~,s] = grid_world.discretise_state(XY(i,:));
    r     = reward_f(s,XY(i,:));
    R(i)  = r;
    
    
end

%set(handle,'CData',reshape(R,size(grid_world.X)));

[Xq,Yq] = meshgrid(linspace(0,10,50),linspace(0,10,50));
Vq = interp2(grid_world.X,grid_world.Y,reshape(R,size(grid_world.X)),Xq,Yq);
    

set(handle,'CData',Vq);


end

