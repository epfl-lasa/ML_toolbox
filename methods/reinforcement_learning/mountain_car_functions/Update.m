function [Q, trace] = Update(Q , V , V2, knn , p , r , a, ap , trace, alpha, gamma, lambda, f )
% Update update de Qtable
% V: previous values from state before taking action (a)
% V2: current values after action (a)
% r: reward received from the environment after taking action (a) in state
%                                             s1 and reaching the state s2
% knn: the features in previous states
% p:  the features coeficients (probabilities a.k.a. unit activations)
% a:  the last executed action
% Q: the current Q-table
% alpha: learning rate
% gamma: discount factor
% lambda: eligibility trace decay factor
% trace : eligibility trace vector
% f: true if episode ends



trace(knn,:) = 0.0; %optional trace reset
trace(knn,a) = p;

if f==true
     delta  =  r - V(a); 
else
    delta  =  ( r + gamma .* V2(ap) ) - V(a); 
end

Q      =  Q  + alpha .* delta .* trace; 
trace  =  gamma * lambda .* trace;
end
