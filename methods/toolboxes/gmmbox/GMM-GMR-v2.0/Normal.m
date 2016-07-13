classdef Normal < hgsetget
    %NORMAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = public, GetAccess = public)
        Mu
        Sigma        
        color 
        D
        K
        STD
    end
    
    methods
        
        function obj = Normal(Mu,Sigma)
            obj.Mu = Mu(:);
            obj.Sigma = Sigma;
            obj.K = size(Mu,1);
            obj.D = size(Mu(:,1),1);
            obj.color = [0 0 1];
            obj.STD = 1;
        end
        
        function y = P(obj,X)
           % X (N x D)
           [N,D] = size(X);
           Diff = X - repmat(obj.Mu',N,1);
           prob = sum((Diff*inv(obj.Sigma)).*Diff, 2);
           y = exp(-0.5*prob) / sqrt((2*pi)^N * (abs(det(obj.Sigma))+realmin));
            
        end
        
        function normal = condition(obj,a,in)
            out = 1:obj.D;
            out(int) = [];
            mu1 = obj.Mu(out);
            mu2 = obj.Mu(in);
            Sig11 = obj.Sigma(out,out);
            Sig12 = obj.Sigma(out,in);
            Sig21 = Sig12';
            invSig22 = inv(obj.Sigma(in,int));
            
            Mu = mu1 + Sig12*invSig22*(a - mu2);
            Sigma = Sig11 - Sig12*invSig22*Sig21;
            
            normal = Normal(Mu,Sigma);
            
        end
        
        function X = sample(obj,nbSamples)
            R = chol(obj.Sigma);
            X = repmat(obj.Mu',nbSamples,1) + randn(nbSamples,2)*R; 
        end
        
        function handle = draw(obj,axes)
                if obj.D == 1
                    handle = draw_Gaussian(axes,obj.Mu,obj.Sigma);
                    set(handle,'Color',obj.color,'LineWidth',3) 
                else
                    for i=3:(-1):obj.STD
                        handle = plot_gaussian_ellipsoid(obj.Mu,obj.Sigma,i,200,axes,1,obj.color);
                        %set(handle,'color',obj.color,'LineWidth',2);
                    end
                end             
        end
        
        function handle = draw_eigen_vector(obj,axes)
            
            [eig_vector,eig_value] = eig(obj.Sigma);
            [eig_value order] = sort(diag(eig_value),'descend');  %# sort eigenvalues in descending order
            eig_vector = eig_vector(:,order);
            
            uv = zeros(2,2);
            uv(1,:) =  3*sqrt(eig_value(1))*eig_vector(:,1);
            uv(2,:) =  3*sqrt(eig_value(2))*eig_vector(:,2);
            
            xy = repmat(obj.Mu',2,1);
            handle = quiver(axes,xy(:,1),xy(:,2),uv(:,1),uv(:,2));
            set(handle,'color',obj.color,'LineWidth',2);       
            
        end
        
    end
    
end

