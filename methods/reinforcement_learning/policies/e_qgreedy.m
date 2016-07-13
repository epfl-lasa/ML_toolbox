function [ a ] = e_qgreedy(Q,s,epsilon )
%E_QGREEDY 
%
% input -------------------------------------------------------------------
%
%       o Q       : (num_states x num_actions), Q-value table
%
%       o s       : (1 x 1), current state index
%   
%       o epsilon : (1 x 1), exploration noise [0,1]
%

actions = size(Q,2);
if (rand()>epsilon) 
    [~,a] = max(Q(s,:));
else
    a = randi(actions);
end


end

