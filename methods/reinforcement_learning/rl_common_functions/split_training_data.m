function [ xurxps ] = split_training_data(xurxp,D,action_list)
%SPLIT_TRAINING_DATA Split the training data according to actions. This is
% if we want to learn a seperate Q-value function for each type of action.
%
%   
%

M       = size(action_list,1);
xurxps  = cell(M,1);

for m = 1:M
    
    xurxps{m} = xurxp(find(xurxp(:,D+1) == action_list(m)),:);
    
end





end

