classdef LWR < handle
    % LWR Locally Weighted Regression
    
    properties
        
        D   % diagonal matrix element
        dim % dimension of input data
               
        X   % (N x dim+1)
        y   % (N x 1)
        N   % num points
        Mdl % KDTree object
        K   % num of neighbours for K-nearest search
        
        
        y_bias;  % output bias
        k_bias;  % stiffness of bias
        
        
    end
    
    methods
        
        function obj = LWR(options)
            
            if ~exist('options','var'),      options            = [];                   end;
            if ~isfield(options,'dim'),      options.dim        = 1;                    end;
            if ~isfield(options,'D'),        options.D          = ones(options.dim,1);  end;
            if ~isfield(options,'K'),        options.K          = 10;                   end;
            
            if length(options.D) ~= options.dim, error('diagonal of covariance should be equal to dim'); end
            
            obj.D       = inv(diag(options.D));
            obj.dim     = options.dim;
            obj.K       = options.K;
            
        end
        
        function obj = clear(obj)
            obj.X   = [];
            obj.y   = [];
            obj.Mdl = [];
        end
        
        function obj = train(obj,X,y)
            %
            %   input ----------------------------------------------------
            %
            %       o X : (N x D), N samples of dimension D
            %
            %       o y : (N x 1), N predictors of dimension 1
            %
            %  
            
            N           = size(X,1);
            obj.Mdl     = KDTreeSearcher(X);           
            obj.X       = [X,ones(N,1)];
            obj.y       = y;
            
        end
        
        
        function [hy,Wp,B] = f(obj,Xq)
            %
            %      input --------------------------------------------------
            %
            %          o  X  : (N x D), set of query points
            %
            %      output -------------------------------------------------
            %
            %          o  hy : (N x 1), predicted variable
            %
            
            N  = size(Xq,1);
            hy = zeros(N,1);
            B  = [];
            
            if ~isempty(obj.X)
                
                %(N x K)
                Idx = knnsearch(obj.Mdl,Xq,'K',obj.K);
                
                for i=1:size(Idx,1)
                    
                    diff = obj.X(Idx(i,:)',1:end-1) - repmat(Xq(i,:),obj.K,1);
                    d    = sum((diff*obj.D).* diff, 2);
                    
                    Wp   = exp(-d);  
                    W    = sparse(diag(Wp));
                    
                    X    = obj.X(Idx(i,:),:);
                    y    = obj.y(Idx(i,:));

                    
                    % (dim+1 x 1) = ((dim+1 x N)(N x N)(N x dim+1)) (dim+1 x N)(N x N)(N x 1)
                    % B = pinv(X' * W * X) * X' * W * y;
                    A = (X' * W * X) + (1e-5) .* eye(obj.dim+1,obj.dim+1);
                    B = (A) \ ( X' * W * y);
                    
                    %   (1 x dim+1) * (dim+1 x 1)
                    hy(i) = [Xq(i,:),1] * B;
                    
                end
                
            end
        end
        
        
    end
    
end

