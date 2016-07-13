function [total_reward,steps,xurxp,f,num_actions_taken] = car_run_policy_episode(maxsteps,policy,reward,Hz,grafic,start_type,bRecord)
%RUN_EPISODE 
%
%
%   input ----------------------------------------------------
%
%       o max_step: (1 x 1), maximum number of steps for the episode
%   
%       o lambda: (1 x 1), TD(lamda)
%
%       o gamma: (1 x 1), discount factor
%
%       o Q: cell(1 x num_actions), array of value function objects
%
%              Q{1}.f(x), evaluates value of state,x, for action 1
%
%       o Hz: control frequency: 
%
%
%
%

if ~exist('start_type','var'),start_type='';end
if ~exist('bRecord','var'),bRecord = false;end

x = State_Initialise(start_type);

steps        = 0;
total_reward = 0;

disp(['maxsteps: ' num2str(maxsteps)]);

xurxp = []; % tuple

t_threash = floor(100/Hz);

action    = policy(x);   
a1        = action;
x1        = x;

num_actions_taken = 1;
count             = 1;

% this loop will be done 1000 times per second (real time)
while(num_actions_taken <= maxsteps)
    
    tic;
    if count >= t_threash
        if bRecord
            r     = reward(xp);
            xurxp = [xurxp;[x1,a1,r,xp]];
        end
        
        action = policy(x);  
        a1     = action;
        x1     = x;
        
        num_actions_taken = num_actions_taken + 1;
        count  = 0;
    end 
   
    
    %do the selected action and get the next car state    
    xp  = DoAction( action , x );
        
    % observe the reward at state xp and the final state flag
    [r,f]   = reward(xp);
    total_reward = total_reward + r;

    x   = xp;
       
    % Plot of the mountain car problem
    if (grafic==true)        
       MountainCarPlot(x,action,steps);    
    end
    
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
   
    steps=steps+1;
    count=count+1;

    pause(0.01);
  
end







end


function x = init_state(sr,ar)

a    = sr(1);
b    = sr(2);
x(1) = a + (b-a).*rand(1,1);

a    = ar(1);
b    = ar(2);
x(2) = a + (b-a).*rand(1,1);

end


function [a] = e_action_selection(Q,x,epsilon)

% e-greedy action selection
Qa = zeros(1,size(Q,2));
for k=1:size(Q,2)
    Qa(k) = Q{k}.f(x);
end
[~,a] = max(Qa);

end

