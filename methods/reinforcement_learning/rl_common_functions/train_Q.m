function [ Q ] = train_Q(Q,P )
%TRAIN_Q Train the parameters of the Q-Value function(s).

if iscell(P)
    M = size(P,1);
    for i = 1:M
       P_i = P{i};
       Q{i}.train(P_i(:,1:end-1),P_i(:,end));
    end    
else
    
    Q.train(P(:,1:end-1),P(:,end));
       
end

end

