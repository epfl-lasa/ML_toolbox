function [idx,actions] = random_policy(x)
%RANDOM_POLICY for a 2D grid world 
%      
%   4 actions : [left,right,up,down]
%

actions = [1 0; 
          -1 0;
           0 1;
           0 -1];
         
idx = randi(4);       
a   = actions(idx,:);


end

