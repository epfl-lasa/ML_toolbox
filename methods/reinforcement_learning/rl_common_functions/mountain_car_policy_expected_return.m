function [er] = mountain_car_policy_expected_return(nfq_Q,X)
%MOUNTAIN_CAR_POLICY_EXPECTED_RETURN Computes the average expected return
% of a policy given a Q-value function and set set of Initial starting
% positions , X
%
%   input ------------------------------------
%
%       o Q: either handle or cell array
%
%       o X: (M x D), set of initial starting positions
%


maxsteps = 500;
grafic   = false;
bRecord  = false;
epsilon  = 0;

policy      = @(x,epsilon)nfq_policy(x,nfq_Q,BuildActionList(),epsilon);
reward      = @(x)nfq_mountain_car_reward( x );
start_type  = 'semi-random';


N = size(X,1);

R = zeros(N,1);

for i=1:N
    %                                            maxsteps,epsilon,policy,reward,grafic,bRecord
    disp(['  i(' num2str(i) ')']);
    x_init = X(i,:);
    [~,steps] = car_run_policy(maxsteps,epsilon,policy,reward,grafic,start_type,bRecord,x_init);
    R(i) = steps./maxsteps; % undiscounted total reward
end

er = [mean(R),var(R)];


end

