function [ a ] = GetBestAction( Q, s )
%GetBestAction return the best action for state (s)
%Q: the Qtable
%s: the current state
% Q has structure  Q(states,actions)

[v a] = max(Q(s,:));