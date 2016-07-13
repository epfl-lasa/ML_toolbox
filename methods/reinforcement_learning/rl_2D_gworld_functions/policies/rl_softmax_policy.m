function q = rl_softmax_policy(s,Qs,t)
%RL_SOFTMAX_POLICY Discrete Softmax policy
%
%   input ----------------------------------------------------------------
%
%       o s  : (1 x 1), state index
%
%       o Qs : (num_states x num_actions), Q-table
%
%       o t  : (1 x 1), temperature when 0, softmax becomes a max
%
%   output ----------------------------------------------------------------
%
%       o q  : (1 x num_actions), probability of taking an action
%
%

% q-> probability of choosing each action
q = exp(Qs(s,:)./t) ./ sum( exp(Qs(s,:)./t) );






end

