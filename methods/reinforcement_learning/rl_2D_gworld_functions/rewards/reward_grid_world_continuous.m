function [ r,flag ] =  reward_grid_world_continuous(s,x,beta,s_goal,x_goal,x_bad,r_bad,r_goal)
%
%
%
if s == s_goal 

    r    = r_goal;
    flag = true;
   
elseif ismember(s,x_bad)
    
    r    = r_bad;
    flag = true;
    
else
    r    = r_goal .* exp(-beta * pdist([x;x_goal]).^2);
    flag = false;
    
end

end