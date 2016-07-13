%% Start the RL GUI
clear all;
addpath(genpath('./'))

%% Create grid world

gw_options = [];
gw_options.dims = [15,15];
grid_world = Grid_world(gw_options);

%% Create reward 


r_options               = [];
r_options.x_goal        = [10,10];
r_options.x_bad         = rl_reward_firepit( 'central_pit' );

r_options.type           = 'discrete';
r_options.r_goal         =   10; % reward for reaching the goal.
r_options.r_pit          =   -10; % reward for falling into a pit.
r_options.r_step         =     -1; % reward for each time step.

r_options.grid_world    = grid_world;

reward                  = Reward_gridworld(r_options);

% Discrete reward function

reward_f                = @(s,x)reward_grid_world_goal(s,x,reward.s_goal,reward.s_bad,reward.r_goal,reward.r_pit,reward.r_step);


% Continuous reward function

%beta                    = 0.1;                          %  (s,x,beta,       s_goal,          x_goal  ,        x_bad,           r_bad,        r_goal)
%reward_fc               = @(s,x)reward_grid_world_continuous(s,x,beta, reward.s_goal,  reward.x_goal  ,  reward.s_bad,  reward.r_pit,  reward.r_goal);


%% Select agents starting position.

agent_pos               = [2,2];


%% Open GUI
global speed;
speed = 0.5;
hOut    = rl_demo_gui(grid_world,reward,agent_pos,reward_f);
handles = hOut{2};

