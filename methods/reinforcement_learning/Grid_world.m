classdef Grid_world < handle
    %GRID_WORLD
    
    properties
        
        dims  % (1 x 2), num cells for x and y dimension
        grid  % (N x 2), center of grid coordinates
        
        delta    % (1 x 2), length and height of grid cell

        num_states
        
        xs
        ys
        
        X
        Y
        
    end
    
    methods
        
        function obj = Grid_world(options)
            
            obj.dims = [10, 10];
            
            if isfield(options,'dims'), obj.dims = options.dims; end
            
            obj.xs       = linspace(0,10,obj.dims(1));
            obj.ys       = linspace(0,10,obj.dims(2));
            
            obj.delta    = [obj.xs(2) - obj.xs(1), obj.ys(2) - obj.ys(1)] ./2;
            
            
            [obj.X,obj.Y]    = meshgrid(obj.xs,obj.ys);
            obj.grid         = [obj.X(:),obj.Y(:)];
            
            obj.num_states   = size(obj.grid,1);     
            
            
        end
        
        function x = check_bounard(obj,x)
            
            % x left-right boundardy
            if x(1) < -obj.delta(1),     x(1) = obj.delta(1);  end
            if x(1) > 10 + obj.delta(1), x(1)= 10; end
            
            % y top-bottom boundary
            if x(2) < -obj.delta(2),  x(2) = 0;  end
            if x(2) > 10 + obj.delta(2), x(2)= 10; end
            
            
        end
        
        
        
        function [xp,sp] = state_transition(obj,a,x)
            %   State transition function T(x,a,xp)
            %
            %   input -----------------------------------------
            %
            %       o x  : (1 x 2), location on the 2D grid
            %
            %       o a  : (1 x 2), velocity, dx and dy
            %
            %   output ----------------------------------------
            %
            %       o xp : (1 x 2), next position on the grid.
            %
            
            % make velocity discrete
            a  = 2 * obj.delta .* a;
            xp = x + a;
            
            %xp = check_bounard(obj,xp);
            
            [xp,sp] = discretise_state(obj,xp);
            
        end
        
        function [xd,i] = discretise_state(obj,x)
            %
            %   input ---------------------------------------
            %
            %       o x : (1 x 2), current state
            %

            
           
            [~ , sx] = min(dist(obj.xs',x(1)));
            [~ , sy] = min(dist(obj.ys',x(2))); 
            
            xd(1)    = obj.xs(sx);
            xd(2)    = obj.ys(sy);
            
            i        = discrete_state_to_index(obj,[sx,sy]-1);
            
            
        end
        
        function i = discrete_state_to_index(obj,idx)
             i =  idx(1) *  obj.dims(2) + idx(2) + 1;
        end
        
        
        function plot_grid(obj)
            
            hold on; box on;
            %pcolor(obj.X,obj.Y,zeros(size(obj.X)));
            %scatter(obj.X(:),obj.Y(:),10,[0 0 0],'filled');          
            %colormap(gray(2));
            title('2D world','FontSize',12);
            axes = gca;
            axes.XTick = [1,10];
            axes.YTick = [1,10];
            axes.XTickLabel = {'1','10'};
            axes.YTickLabel = {'1','10'};
            xlim([-1,11]);
            ylim([-1,11]);
            
        end
        
        
    end
    
end

