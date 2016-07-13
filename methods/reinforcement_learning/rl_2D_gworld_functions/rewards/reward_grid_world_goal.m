function [ r,flag ] = reward_grid_world_goal(s,x,x_goal,x_bad,r_goal,r_bad,r_step)
%reward 
%
%   input ---------------------------------------------------------
%
%       o x      : (1 x 1), current grid index of the agent.
%
%       o x_goal : (1 x 1), goal grid index.
%
%   output ---------------------------------------------------------
%
%       o r      : (1 x 1), reward value
%


if s == x_goal 

    r    = r_goal;
    flag = true;
   
elseif ismember(s,x_bad)
    
    r    = r_bad;
    flag = true;
    
else
   
    r    = r_step;
    flag = false;
    
end


end

