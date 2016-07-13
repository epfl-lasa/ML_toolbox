classdef Reward_gridworld < handle
    %REWARD_GRIDWORLD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        x_goal      % (1 x 2), x-y position on the 2D grid which indicates a goal state
        s_goal      % (1 x 1), index of goal state
        x_bad       % (N x 2), a set of states which are part of the fire pit.
        s_bad       % (N x 1), indicies of bad states.
        grid_world  % 2D grid world object.
        
        r_goal      % (1 x 1), reward for reaching the goal.
        r_pit       % (1 x 1), reward for falling into a pit.
        r_step      % (1 x 1), reward incurred for each time step.
        
    end
    
    methods
        
        function obj = Reward_gridworld(options)
            x_goal          = options.x_goal;
            x_bad           = options.x_bad;
            obj.grid_world  = options.grid_world;
            obj.r_goal      = options.r_goal;
            obj.r_pit       = options.r_pit;
            obj.r_step      = options.r_step;
            
            [x_goal,s_goal] = obj.grid_world.discretise_state(x_goal);
            obj.x_goal      = x_goal;
            obj.s_goal      = s_goal;
            
            
            if ~isempty(x_bad)
                
                % discretise the bad states
                for i=1:size(x_bad,1)
                    [x,s] = obj.grid_world.discretise_state(x_bad(i,:));
                    x_bad(i,:) = x;
                    s_bad(i)   = s;
                end
                
                obj.x_bad = unique(x_bad,'rows');
                obj.s_bad = unique(s_bad);
                
            end
        end
        
        
        function in_pit =  is_in_pit(obj,s)
            in_pit = ismember(s,obj.s_bad);
        end
        
        
        function handle = plot_goal_state(obj)
            
            handle = plot(obj.x_goal(1),obj.x_goal(2),'-pk','markersize',15,'MarkerFaceColor',[1 .7 .1]);
        end
        
        function handle = plot_firpit(obj)
            if ~isempty(obj.x_bad)
                handle = plot(obj.x_bad(:,1),obj.x_bad(:,2),'sk','markersize',20,'MarkerFaceColor',[1 0 0]);
            end
        end
        
        
    end
    
end

