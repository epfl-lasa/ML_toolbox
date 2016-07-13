function [ total_reward,steps,Q, trace] = Episode_TD( maxsteps, Q,reward, trace, alpha, gamma, epsilon,lambda,statelist,actionlist,k,grafic,start_type)
%MountainCarEpisode do one episode of the mountain car with sarsa learning
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

if ~exist('start_type','var'),start_type='';end

x     = State_Initialise(start_type);

steps           = 0;
total_reward    = 0;

[knn,p] = GetkNNSet( x, statelist, k );
V       = GetValues( Q , knn , p );
a       = e_greedy_selection_TD( V , epsilon );


for i=1:maxsteps
        
    % convert the index of the action into an action value
    action = actionlist(a);    
    
    %do the selected action and get the next car state    
    xp  = DoAction( action , x );
        
    % observe the reward at state xp and the final state flag
    [r,f]        = reward(xp);
    total_reward = total_reward + r;
    
    % convert the continous state variables in [xp] to an index of the statelist    
    [knn2,p2] = GetkNNSet( xp, statelist, k );
   
    % get the values for current 
    V2      = GetValues( Q , knn2 , p2 );
    
    % select action prime
    ap = e_greedy_selection_TD( V2 , epsilon );
    
    % Update the Qtable, that is,  learn from the experience
    [Q, trace] = Update(Q , V , V2, knn , p , r , a, ap , trace, alpha, gamma, lambda ,f );
    
      
    % update the current variables   
    a   = ap;
    x   = xp;
    knn = knn2;
    p   = p2;
    V   = V2;
        
    %increment the step counter.
    steps=steps+1;
       
    % Plot of the mountain car problem
    if (grafic==true)        
       MountainCarPlot(x,action,steps);    
    end
    
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
    
end

end



