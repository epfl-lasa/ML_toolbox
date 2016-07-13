function XY = rl_reward_firepit( type )
%RL_REWARD_FIREPITE 
%
%   intput-----------------------------------------------------------------
%
%           o type : string, type of fire pit.
%
%   output----------------------------------------------------------------- 
%
%           o XY   : (N x 2)
%
%


XY = [];

if strcmp(type,'central_pit')
    
    [X,Y] = meshgrid(linspace(3,7,20),linspace(3,7,20));
    XY    = [X(:),Y(:)];
    
else
    
end









end

