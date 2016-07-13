function [P,N,R] = rl_create_PR_models(grid_world,actions,reward,epsilon)
%RL_CREATE_PR_MODELS Create transitional and reward model.
%
%   input -----------------------------------------------------------------
%
%
%       o grid_world : 2D Grid World object
%
%       o reward : function handle, reward
%
%       o epsilon : [0,1], how much noise to add to the state transition
%                          fucntion.
%
%   output ----------------------------------------------------------------
%
%
%       o P : (num_states x num_actions x 4), 4 is for the number of
%                                              neighoubring states.
%
%
%

xy          = [grid_world.X(:), grid_world.Y(:)];
num_states  = grid_world.num_states;
num_actions = size(actions,1);

% 
N           = zeros(num_states,4);
R           = zeros(num_states,1);
P           = ones(num_states,4,4) .* epsilon;



for s = 1:num_states
   
    
    % get all the neighbour states
    neigh_id = [];
    for j=1:num_actions 
          [~,sp]    = grid_world.state_transition(actions(j,:),xy(s,:));
          neigh_id  = [neigh_id,sp];
          P(s,j,j)  = 1;     
    end
    
    P(s,j,:) = P(s,j,:) / sum(P(s,j,:));
    
    
    
    N(s,1:4)    = neigh_id;
    R(s)        = reward(s,xy(s,:));

end






end

