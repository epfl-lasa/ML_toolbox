function rl_run_loop(rl_param,agent_param,plot_parameters,handles)
%RUN_RL_LOOP 
%
%     
%
%
%% Extract parameters
% RL parameters
alpha           = rl_param.alpha; 
gamma           = rl_param.gamma;     
qtable          = rl_param.qtable;    
maxsteps        = rl_param.maxiter;   
num_episodes    = rl_param.num_episodes;  
reward          = rl_param.reward;
qinit           = rl_param.qinit;
method          = rl_param.method;
rl_plot_policy  = plot_parameters.rl_plot_policy;
h_policy        = plot_parameters.h_policy;
p_noise         = rl_param.p_noise;  


qtable.alpha = alpha;
qtable.gamma = gamma;   % (1 x 1), discount factor
        
qtable.init_q(qinit);


% Plot parameters
h_a = plot_parameters.h_a;
h_Q = plot_parameters.h_Q;
p_h = plot_parameters.p_h;

grid_world = handles.grid_world;



% Agent parameters

agent_start_pos = agent_param.agent_pos;
agent_orient    = agent_param.agent_orient;
agent_radius    = agent_param.agent_radius;


%% Global parameters

global bPlot_RL;
global bStop_loop;
global epsilon
global speed;

bStop_loop = false;

%% Run simulation loop

episode                = 1;
average_rewards_episodes = [];

for j = 1:num_episodes
    
    steps       = 0;
    
    [x,s]       = grid_world.discretise_state(agent_start_pos);

    
    [a,actions]  = random_policy(x);
    total_reward = 0;

    
    for i=1:num_episodes
        
        if(bStop_loop == true)
            break;
        end
        
        agent_orient = actions(a,:);
        
        if (rand()<p_noise)
            a = randi(4);
        end
        
        [xp,sp]      = grid_world.state_transition(actions(a,:), x);
        
        [r,f]        = reward(sp,xp);
        
        total_reward = total_reward + r;
        
        
        % select action prime
        ap = e_qgreedy(qtable.Q,sp,epsilon);
        
        if strcmp(method,'SARSA')
            qtable.sarsa_update(s,a,r,sp,ap);    
        elseif strcmp(method,'Q-Learning')
            qtable.qlearning(s,a,r,sp);
        end
            
               
        %update the current variables
        s = sp;
        a = ap;
        x = xp;
        
        %increment the step counter.
        steps=steps+1;
        
        % Plot of the mountain car problem
        if (bPlot_RL==true)
            
            axes(handles.axes1);            
            plot_round_agent(handles.axes1,x,agent_orient,agent_radius,[],h_a);
            
            rl_plot_policy(qtable.Q,h_policy);
            
            

            plot_qtable([],qtable.Q,grid_world.X,grid_world.Y,h_Q);
            pause(speed);
        end
        
        if (f==true)
            break
        end
        
        
    end

    % Plot total reward per episode
    average_rewards_episodes = [average_rewards_episodes,total_reward/i];
    plot_accum_reward(episode,average_rewards_episodes,p_h);
    
    % decay exploration rate
    epsilon = 0.999 * epsilon;
    
    disp(['Episode (' num2str(episode) ') epsilon: ' num2str(epsilon) ' steps: ' num2str(steps)]);
    
    episode = episode + 1;
    
    pause(0.02);
    
    if(bStop_loop == true)
        break;
    end
    
end

disp('Finished!');

% Plot resut
axes(handles.axes1);
plot_round_agent(handles.axes1,x,agent_orient,agent_radius,[],h_a);

plot_qtable([],qtable.Q,grid_world.X,grid_world.Y,h_Q);



end

