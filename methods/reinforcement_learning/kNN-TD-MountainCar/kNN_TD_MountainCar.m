%% kNN-TD mountain car
clear all;
%%
maxepisodes = 800;
maxsteps    = 10000;

clc
clf
rand('seed',1)

set(gco,'BackingStore','off')
statelist   = BuildStateList();  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);
Q           = BuildQTable( nstates,nactions );  % the QTable
trace       = BuildQTable( nstates,nactions );  % the elegibility trace

alpha       = 1.5;   % learning rate
gamma       = 0.95;   % discount factor
lambda      = 0.95;   % the decaying elegibiliy trace parameter
epsilon     = 0.01;  % probability of a random action selection
grafica     = false;%true; % indicates if display the graphical interface
k           = 2^8;

reward      = @(x)GetReward(x);

start_type  = 'semi-random';

xpoints=[];
ypoints=[];

for i=1:maxepisodes
    
    [total_reward,steps,Q,trace ] = Episode( maxsteps, Q, reward, trace , alpha, gamma, epsilon, lambda, statelist, actionlist, k ,grafica, start_type );
    trace(:,:)=0.0;
    disp(['Espisode: ',int2str(i),' steps: ',int2str(steps),' reward: ',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    epsilon = epsilon * 0.99;
    
    xpoints(i)=i-1;
    ypoints(i)=steps;
    subplot(2,1,1);
    plot(xpoints,ypoints)
    title(['Episode: ',int2str(i),' epsilon: ',num2str(epsilon)])
    drawnow
    
    if (i==maxepisodes)
        grafica=true;
    end
end

%% Plot policy

if exist('h','var'),delete(h);end
h(1) = plot_q_mountain_car(Q);

%% Visualise Q-value function and policy

grafica                       = true;
start_type                    = '';
bRecord                       = true;
alpha                         = 0;
reward                        = @(x)GetReward(x);

[ total_reward,steps,xurxp] = Episode_no_learning( maxsteps, Q,reward,statelist,actionlist,k,grafica,start_type,bRecord);


%% Get Data Samples

grafic      = false;
start_type  = 'semi-random';
bRecord     = true;
reward      = @(x)nfq_smooth_reward(x);
N           = 200;
xurxps      = cell(N,1);
maxsteps    = 2000;

for n=1:N
      
    disp(['n(' num2str(n) ')']); 
    [ total_reward,steps,xurxp] = Episode_no_learning( maxsteps, Q,reward,statelist,actionlist,k,grafic,start_type,bRecord);
     xurxps{n} = xurxp;

end


%% Plot Trajectories

[ h1 ] = plot_sample_trajectories( xurxps );


%% Save data

path_to_save = '/home/guillaume/MatlabWorkSpace/RL/Data';

save([path_to_save '/xurxps_knn.mat'],'xurxps');








