function [ a ] = e_greedy_selection( Q , s, epsilon )
% e_greedy_selection selects an action using Epsilon-greedy strategy
% Q: the Qtable
% s: the current state

actions = size(Q,2);
	
if (rand()>epsilon) 
    a = GetBestAction(Q,s);    
else
    % selects a random action based on a uniform distribution
    % +1 because randint goes from 0 to N-1 and matlab matrices goes from
    % 1 to N
   % a = randint(1,1,actions)+1;
    a = randi(actions);
end

