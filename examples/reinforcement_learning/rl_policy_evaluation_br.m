%% Policy evaluation
%
% V(s) = \sum_a \pi(s,a) \sum_s' P_ss'^a [R_ss'^a + \gamma V(s')]
%

clear all; 

gw_options = [];
gw_options.dims = [15,15];
grid_world = Grid_world(gw_options);
actions    = [1 0; -1 0;  0 1;  0 -1];


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

%% Create Transition and Reward Model

p_noise   = 0.0;

[P,N,R]   = rl_create_PR_models(grid_world,actions,reward_f,p_noise);


%% Value Iteration
bRecord    = true;
V          = zeros(grid_world.num_states,1);
gamma      = 0.9;
stop_c     = 0.001;

Q          = rand(grid_world.num_states,4);
tau        = 10;
policy     = @(s)rl_softmax_policy(s,Q,tau);

num_iterations = 1;
dtau1          = @(i) -(tau)/(num_iterations+1) * i + tau;
s              = tau;
dtau2          = @(i) 10 * exp(- 0.1 * i*i) + 0.05;
dtau2(1)
dtau2(2)


% Policy Evaluation -> Policy Improvement -> Policy Evaluation -> .... -> until convergence

data_save = [];
data_save.V   = cell(num_iterations,1);
data_save.Q   = cell(num_iterations,1);
data_save.tau = [];
%%
close all;
hf = figure('Position',[195         359        1143         419]);

subplot(1,2,1);
[~,idx] = max(Q,[],2);
U       = actions(idx,:);hold on;
h_P     = rl_2D_plot_policy_uw(0.5 .* U,grid_world.X(:),grid_world.Y(:),[]);
reward.plot_firpit();
reward.plot_goal_state();
xlim([-1 11]);
ylim([-1 11]);
box on;

subplot(1,2,2);
h_Q = plot_qtable(gca,V,grid_world.X,grid_world.Y);


title(['Policy Evaluation # ' num2str(1) ]);
pause(0.1);

for i=1:num_iterations
    
    disp(['Policy Evaluation (' num2str(i) ')']);
    [V,Q,data] = rl_policy_evaluation(policy,V,actions,P,reward_f,N,gamma,stop_c,bRecord);
    
    disp('Policy Improvement');
    tau        = dtau2(i);
    policy     = @(s)rl_softmax_policy(s,Q,tau);
    
    data_save.V{i} = V;
    data_save.Q{i} = Q;
    data_save.tau  = [data_save.tau,tau];
    
    % Plot Update
    [~,idx] = max(Q,[],2);
    U       = actions(idx,:);hold on;
    rl_2D_plot_policy_uw(0.5 .* U,grid_world.X(:),grid_world.Y(:),h_P);
    plot_qtable(gca,V,grid_world.X,grid_world.Y,h_Q);
    title(['Policy Evaluation # ' num2str(i) ]);
    pause(0.1);

    
end




%% Play Sequce of Evaulation

bSaveVideo = true;

if bSaveVideo 
   writer = VideoWriter('PE_multiple.avi');
   open(writer);
end

V =  data_save.V{1};
Q =  data_save.Q{1};
close all;
hf = figure('Position',[195         359        1143         419]);

subplot(1,2,1);
[~,idx] = max(Q,[],2);
U       = actions(idx,:);hold on;
h_P     = rl_2D_plot_policy_uw(0.5 .* U,grid_world.X(:),grid_world.Y(:),[]);
reward.plot_firpit();
reward.plot_goal_state();
xlim([-1 11]);
ylim([-1 11]);
box on;

subplot(1,2,2);
h_Q = plot_qtable(gca,V,grid_world.X,grid_world.Y);
title(['Policy Evaluation # ' num2str(1) ]);

bRun     = true;
i        = 1;
count    = 0;
num_iter = 20;% size(data_save.V,1);

while(bRun)

    
    V =  data_save.V{i};
    Q =  data_save.Q{i};
    
    % Plot Policy
    [~,idx] = max(Q,[],2);
    U       = actions(idx,:);hold on;
    rl_2D_plot_policy_uw(0.5 .* U,grid_world.X(:),grid_world.Y(:),h_P);
    
    % Plot Value function
    plot_qtable(gca,V,grid_world.X,grid_world.Y,h_Q);
    title(['Policy Evaluation # ' num2str(i) ]);
    
    if bSaveVideo == true
        F = getframe(hf);
        writeVideo(writer,F);
        pause(0.01);
        count = count + 1;
        if(count == 10)
            count = 0;
            i = i + 1;
        end
    else
        i = i + 1;
        pause(1);  
    end

    if i == num_iter
        bRun = false;
    end
    
end
disp('Finished');

if bSaveVideo 
 close(writer);
end


%% Record video for Policy Evaluation Iterations (single)



bSaveVideo = true;

if bSaveVideo 
   writer = VideoWriter('PE_single.avi');
   open(writer);
end

close all;
hf = figure;
set(gcf,'color','w');
h_Q = plot_qtable(gca,data.Vs(:,1),grid_world.X,grid_world.Y);
title(['Policy Evaluation #1 iter(' num2str(1) ')']);

bRun     = true;
i        = 1;
count    = 0;
num_iter = size(data.Vs,1);


while(bRun)

    
    
    % Plot Policy
    
    % Plot Value function
    plot_qtable(gca,data.Vs(:,i),grid_world.X,grid_world.Y,h_Q);
    title(['Policy Evaluation #1 iter(' num2str(i) ')']);
    
    if bSaveVideo == true
        F = getframe(hf);
        writeVideo(writer,F);
        pause(0.01);
        count = count + 1;
        if(count == 10)
            count = 0;
            i = i + 1;
        end
    else
        i = i + 1;
        pause(1);  
    end

    if i == num_iter
        bRun = false;
    end
    
end
disp('Finished');

if bSaveVideo 
 close(writer);
end

%%











