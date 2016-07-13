function [ total_reward,steps,Q,x_init,us,xs,xurxp] = Episode( maxsteps, Q , alpha, gamma,epsilon,statelist,actionlist,grafic,bRecord)
%MountainCarEpisode do one episode of the mountain car with sarsa learning
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214


if ~exist('bRecord','var'),bRecord=false;end

x             = [-0.5,0];%init_state([-1.2,0.5],[-0.07,0.07]);
x_init        = x;
steps         = 0;
total_reward  = 0;
us            = [];
xs            = [];

% xurxp        = []; % tuple {x,u,r,xp}


% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);


for i=1:maxsteps    
        
    % convert the index of the action into an action value
    action = actionlist(a);    
%     us = [us;action];
%     xs = [xs;x];
%     
    % convert the index of the action into an action value
    action = actionlist(a);    
    
    %do the selected action and get the next car state    
    xp  = DoAction( action , x );    
    
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp);
    total_reward = total_reward + r;
    
    % convert the continous state variables in [xp] to an index of the statelist    
    sp  = DiscretizeState(xp,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    
    
    % Update the Qtable, that is,  learn from the experience
    Q = UpdateSARSA( s, a, r, sp, ap, Q , alpha, gamma );
    
    
    if bRecord 
        xurxp = [xurxp;[x,action,r,xp]];
    end
    
    %update the current variables
    s = sp;
    a = ap;
    x = xp;
    
    
    %increment the step counter.
    steps=steps+1;
    
   
    % Plot of the mountain car problem
    if (grafic==true)        
       MountainCarPlot(x,action,steps);    
       %MountainCarPlotSingle(x,action,steps);    
    end
    
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
    
end

function x = init_state(sr,ar)

x(1) = sr(1) + (sr(2)-sr(1)).*rand(1,1);
x(2) = ar(1) + (ar(2)-ar(1)).*rand(1,1);




