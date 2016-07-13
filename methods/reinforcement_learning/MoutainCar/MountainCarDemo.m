function  [maxsteps,Q,alpha,gamma,epsilon,statelist,actionlist,us,xs] = MountainCarDemo( maxepisodes,maxsteps)
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214


clc
clf
set(gcf,'BackingStore','off')  % for realtime inverse kinematics
set(gcf,'name','Reinforcement Learning Mountain Car')  % for realtime inverse kinematics
set(gco,'Units','data')

if ~exist('maxsteps','var'),maxsteps=100000;end              % maximum number of steps per episode
statelist   = BuildStateList();  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);
Q           = BuildQTable( nstates,nactions );  % the Qtable

alpha       = 0.005;   % learning rate
gamma       = 0.99;   % discount factor
epsilon     = 0.0;  % probability of a random action selection
grafica     = false; % indicates if display the graphical interface

xpoints=[];
ypoints=[];

for i=1:maxepisodes    
    
    [total_reward,steps,Q,x_init,us,xs ] = Episode( maxsteps, Q , alpha, gamma,epsilon,statelist,actionlist,grafica );    
    
    disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    epsilon     = epsilon * 0.99;
    xpoints(i)  = i-1;
    ypoints(i)  = steps;
    subplot(2,1,1);    
    plot(xpoints,ypoints)      
    title(['Episode: ',int2str(i),' epsilon: ',num2str(epsilon)])    
    drawnow
    
%      if (i>300)
%          grafica=true;
%     end
end


   

