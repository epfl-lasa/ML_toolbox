function  [V,Qs,Record] = rl_policy_evaluation(Policy,V,A,P,reward,N,gamma,theta,bRecord)
%RL_POLICY_EVALUATION 
%
%   input -----------------------------------------------------------------
%
%       o grid_world : 2D Grid World object
%
%       o V : (num_states x 1)
%
%       o A : (num_actions x 2), actions
%
%       o P : (num_states x num_actions x num_states), state transition function
%
%       o R : (num_states x 1),  reward model
%
%       o N : (num_states x 4), neighourhood states
%
%       o gamma : (discount factor)
%
%       o theta : threashold value
%

num_states  = length(V);
num_actions = size(A,1);


Q    = zeros(1,num_actions);
U    = zeros(num_states,2);
Vtmp = rand(num_states,1);


if ~exist('bRecord','var'), bRecord = false; end

Record.Vs = V(:);


disp(' ');
disp(' Start Policy Evaluation ');
disp(' ');
iter = 0;
err  = max(abs(V - Vtmp));

Qs   = zeros(num_states,num_actions);

while(err > theta)
       
    Vtmp = V;    
    
    for i=1:num_states
        % iterate over each action
    
        Q = zeros(1,num_actions);
        for a = 1:num_actions
            % neighbouring states
            sp = N(i,:);
            % iterate over each possible state
            P(i,a,:) = P(i,a,:)./sum(P(i,a,:));
            xp = [];
            
            for j=1:length(sp)
                [r,f] = reward(sp(j),xp);
                if f == 1
                    Q(a) = Q(a) + P(i,a,j) * r;                 
                else
                    Q(a) = Q(a) + P(i,a,j) * ( r + gamma * V(sp(j)) );        
                end
            end
        end
        
        v = 0;
        Qs(i,:) = Q;
        prob  = Policy(i);
        for a = 1:num_actions
            v = v + prob(a) * Q(a); 
        end
        V(i)        = v;
    end
    
    if bRecord == true       
        Record.Vs = [Record.Vs,V(:)];      
    end
    
    
    err  = max(abs(V - Vtmp));
    
    if (iter > 200)
       break; 
    end

    iter
    iter = iter + 1;
end

disp(['iter: ' num2str(iter)]);
disp(['max(abs(V - Vtmp)): ' num2str(max(abs(V - Vtmp)))]);
disp(' ');

end

