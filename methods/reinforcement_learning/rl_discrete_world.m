%% Discrete STATE and ACTION RL examples

clear all;

%% initial world

gw_options = [];
gw_options.dims = [20,20];

grid_world = Grid_world(gw_options);

%% initialise policy

[agent_pos,s]   = grid_world.discretise_state([5,5]);
agent_orient    = [0 1];
agent_radius    = 0.3;

%% initialise Q-value function

alpha   = 0.1;
gamma   = 0.9;
epsilon = 0.9;
qtable  = Qtable(grid_world.num_states,4,alpha,gamma);

%% Setup reward function


[~,s_goal] = grid_world.discretise_state([10,10]);
reward     = @(s)reward_grid_world_goal(s,s_goal);


%% First initial plot
close all;
if exist('hg','var'), delete(hg); end;
hg = figure;
grid_world.plot_grid();
h_a1        = plot_round_agent(gca,agent_pos,agent_orient,agent_radius,[],[]);    hold on;
axis equal;
xlim([-1,11]);
ylim([-1,11]);
box on;
if exist('hQ','var'), delete(hQ); end;
hQ= plot_qtable(qtable.Q,grid_world.X,grid_world.Y);

%% Run simulation

num_episodes = 4000;

bPlot       = true;
maxsteps    = 1000;
x           = agent_pos;
episode      = 1;


for j = 1:num_episodes
    
    x           = [2,2];
    steps       = 0;
    [a,actions] = random_policy(x);

    
    for i=1:maxsteps
        
        agent_orient = actions(a,:);
        
        [xp,sp]      = grid_world.state_transition(actions(a,:), x);
        
        [r,f]        = reward(sp);
        
        
        % select action prime
        ap = e_qgreedy(qtable.Q,sp,epsilon);
        
        % qtable.sarsa_update(s,a,r,sp,ap);        
        qtable.qlearning(s,a,r,sp);
       
        %update the current variables
        s = sp;
        a = ap;
        x = xp;
        
        %increment the step counter.
        steps=steps+1;
        
        % Plot of the mountain car problem
        if (bPlot==true)
            plot_round_agent(gca,x,agent_orient,agent_radius,[],h_a1);
            plot_qtable(qtable.Q,grid_world.X,grid_world.Y,hQ);
            pause(0.01);
        end
        
        if (f==true)
            break
        end
        
        
    end
    
    epsilon = 0.999 * epsilon;
    
    disp(['Episode (' num2str(episode) ') epsilon: ' num2str(epsilon)]);
    
    episode = episode + 1;
    
end


%% plot Q-table

hQ = plot_qtable(qtable.Q,grid_world.X,grid_world.Y);


