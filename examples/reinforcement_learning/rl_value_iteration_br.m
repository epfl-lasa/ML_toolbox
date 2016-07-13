%% Value Iteration (VI)
%
%   V(s) = max_a \sum_s' P_ss'^a [R_ss'^a + \gamma V(s')]
%
%%

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

gammas = [0.99 0.9 0.8 0.5 0.1];

residuals = cell(length(gammas),1);

for i = 1:length(gammas)
    [V,U,data] = rl_value_iteration(V,actions,P,reward_f,N,gammas(i),0.0000000000001,bRecord);
    residuals{i} = data.bel_residual; 
end       


%% 

bSaveVideo = true;

if bSaveVideo 
   writer = VideoWriter('VI.avi');
   open(writer);
end


close all;
hf = figure;


h_Q = plot_qtable(gca,data.Vs(:,1),grid_world.X,grid_world.Y);
title(['Value Iteration # ' num2str(1) ]);

bRun = true;
i    = 1;
count = 0;

while(bRun)

    plot_qtable(gca,data.Vs(:,i),grid_world.X,grid_world.Y,h_Q);
    title(['Value Iteration # ' num2str(i) ]);
    
    if bSaveVideo == true
        F = getframe(hf);
        writeVideo(writer,F);
        count = count + 1;
        if(count == 10)
           count = 0;
           i = i + 1;
           if i == size(data.Vs,2)
               bRun = false;
           end
        end
        
        
        pause(0.01);
    else
        pause(1);  
    end
    
end


if bSaveVideo 
 close(writer);
end

%%


%% Plot Bellman Residual
close all;
figure; hold on; box on; grid on;
set(0,'defaulttextinterpreter','latex');

set(gcf,'color','w');

%for i = 2:length(gammas)
    plot(residuals{2}(1:end),'-s');
%end     

hl = legend('$\gamma = 0.9$');
set(gca,'FontSize',16);
set(hl,'FontSize',18,'Interpreter','Latex');
title('Bellman residual','FontSize',18);
ylabel('$\max\limits_{s} |V_{k+1}(s) - V_{k}(s)|$','FontSize',20);
xlabel('interation $k$','FontSize',18);






























