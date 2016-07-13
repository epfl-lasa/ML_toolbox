function [ Q ] = UpdateSARSA( s, a, r, sp, ap, tab , alpha, gamma )
% UpdateQ update de Qtable and return it using Whatkins QLearing
% s1: previous state before taking action (a)
% s2: current state after action (a)
% r: reward received from the environment after taking action (a) in state
%                                             s1 and reaching the state s2
% a:  the last executed action
% tab: the current Qtable
% alpha: learning rate
% gamma: discount factor
% Q: the resulting Qtable

Q = tab;
Q(s,a) =  Q(s,a) + alpha * ( r + gamma*Q(sp,ap) - Q(s,a) );