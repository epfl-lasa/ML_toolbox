classdef Qtable < handle

    
    properties

        Q       % (num_states x num_actions), Q-value table        
        alpha   % (1 x 1), learning rate
        gamma   % (1 x 1), discount factor
        
    end
    
    methods
        
        function obj = Qtable(num_actions,num_states,alpha,gamma)
            
            obj.Q     = zeros(num_actions,num_states);
            obj.alpha = alpha;
            obj.gamma = gamma;
            
        end
        
        function obj =init_q(obj,qinit)
            
            if strcmp(qinit,'random')
                obj.Q = rand(size(obj.Q));
            elseif strcmp(qinit,'zeros')
                obj.Q = zeros(size(obj.Q));
            else
               error(['no such init method: ' qinit]); 
            end
            
        end
        

        
        function sarsa_update(obj,s,a,r,sp,ap)
        %   
        %   SARSA 
        %
        %     input -------------------------------------------------------
        %
        %           o s  : (1 x 1), index of current state
        %   
        %           o a  : (1 x 1), index of current action
        %
        %           o r  : (1 x 1), reward
        %
        %           o sp : (1 x 1), index of next state 
        %
        %           o ap : (1 x 1), index of next action
        %
            
            obj.Q(s,a) =  obj.Q(s,a) + obj.alpha * ( r + obj.gamma * obj.Q(sp,ap) - obj.Q(s,a) );
        

        end
        
        function qlearning(obj,s,a,r,sp)
            
            [~,ap]     = max(obj.Q(sp,:)); 
            
            obj.Q(s,a) =  obj.Q(s,a) + obj.alpha * ( r + obj.gamma * obj.Q(sp,ap) - obj.Q(s,a) );

        end
                
        
    end
    
end

