function [ res ] = bellman_residual(Qt,Qtmp)
%BELLMAN_RESIDUAL Computes the Bellman residual
%
%   input -------------------------------------------------------
%       
%       o Q: Q-value function at time t
%       
%       o Qtmp: Q-value function at time t-1
%


vt   = compute_value_function(Qt);
vtmp =  compute_value_function(Qtmp);

res = (vt - vtmp).^2;
res = sum(res(:)) / size(vt(:),1);



end


function v = compute_value_function(nfq_Q)

u           = BuildActionList();
num_actions = 2;
nbSamples   = 100;
xs          = linspace(-1,1,nbSamples);
[Xs,Ys]     = meshgrid(xs,xs);
test        = [Xs(:),Ys(:)];
vs          = zeros(size(test,1),num_actions);

M           = size(test,1);

if iscell(nfq_Q)
    for i=1:num_actions
        vs(:,i) = nfq_Q{i}.f(test);
    end
else
    for i=1:num_actions
        test_ui = [test,repmat(u(i),M,1)];
        vs(:,i) = nfq_Q.f(test_ui);
    end
end

v          = min(vs,[],2);


end