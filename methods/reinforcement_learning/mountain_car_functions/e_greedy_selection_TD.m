function [ a ] = e_greedy_selection_TD( V, epsilon )
% e_greedy_selection selects an action using Epsilon-greedy strategy
% V: the available values for each action

actions = size(V,1);
	
if (rand()>epsilon)     
    a = GetBestAction_TD(V);    
else
    % selects a random action based on a uniform distribution
    % +1 because randint goes from 0 to N-1 and matlab matrices goes from
    % 1 to N
    a = randi(actions);    
end

