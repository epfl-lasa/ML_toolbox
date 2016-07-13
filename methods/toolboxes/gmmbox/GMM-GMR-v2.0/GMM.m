
classdef GMM < hgsetget
    %   GMM Gaussian Mixture Model Class
    
    properties (SetAccess = public, GetAccess = public)
        Priors
        Mu
        Sigma        
        color 
        D
        K
        STD
        bUseAlpha
        L
        name
        text_handle;
    end
    
    methods 
        
        function obj = GMM(Priors,Mu,Sigma)
           obj.Priors = Priors;
           obj.Mu = Mu;
           obj.Sigma = Sigma;
           obj.K = size(Priors,2);
           obj.D = size(Mu(:,1),1); 
           obj.color = [0 0 1];
           obj.STD = 1;
           obj.bUseAlpha=true;
           obj.L = zeros(obj.D,obj.D,obj.K);
           obj.name = '';
           obj.text_handle = [];
        end
              
        function [handle,Z,X,Y] = draw(obj,axes,draw_type,height)
            
            if nargin < 3
                draw_type = 'contour';
            end
            
            Z = [];X=[];Y=[];
            if ~exist('height', 'var'),height=[]; end

            
            if obj.D == 1
                handle = draw1D(obj,axes);
            else
                
                if  strcmp(draw_type,'contour')
                    
                    handle = drawContourAlpha(obj,axes);
                else
                    [handle,Z,X,Y] = drawDensity(obj,axes,height);
                end
                
            end

        end
               
        function setColor(obj,c)
           if size(c,2) == 3
               obj.color = c;
           else
              error('Invalid RGB specification, must be 1x3'); 
           end 
        end
        
        function [X,i] = sample(obj,nbSamples)
            for k=1:obj.K
               obj.L(:,:,k) = inv(chol(obj.Sigma(:,:,k),'lower'))'; 
            end
                i = discretesample(obj.Priors', nbSamples);
                Z = randn(nbSamples,obj.D);
                X = zeros(nbSamples,obj.D);
                for v = 1:nbSamples
                    x = obj.L(:,:,i(v)) * Z(v,:)';
                    X(v,:) = (x + obj.Mu(:,i(v)))';
                end       
        end
    

        
    end
    
    methods (Access=private)
        
        function handle = draw1D(obj,axes)
            for k=1:obj.K
                Max = obj.Mu(k) + 4.0*sqrt(obj.Sigma(k));
                Min = obj.Mu(k) - 4.0*sqrt(obj.Sigma(k));
                xs=linspace(Min,Max, 400);
                ys = normpdf(xs,obj.Mu(k),sqrt(obj.Sigma(k)));
                handle = plot(axes,xs,ys);
                set(handle,'Color',obj.color,'LineWidth',2)
            end
        end
        
        
        function handle = drawContourAlpha(obj,axes)
            obj.text_handle = [];
            for k=1:obj.K
                l = max(obj.Priors);
                for i=3:(-1):obj.STD
                    w = obj.Priors(k)/l;
                    handle = plot_gaussian_ellipsoid(obj.Mu(:,k),obj.Sigma(:,:,k),i,100,axes,w,obj.color);
                    set(handle,'LineWidth',2);
                    obj.text_handle = [obj.text_handle text(obj.Mu(1,k),obj.Mu(2,k),num2str(k),'FontWeight','bold','FontSize',24,'Color',obj.color,'VerticalAlignment','middle','HorizontalAlignment','center')];
                end
            end
        end
        
        function [handle,ppdraw,X,Y] = drawDensity(obj,axes,height)
            
            spacing=300;
            handle = [];
            
            xMus = obj.Mu(1,:);
            yMus = obj.Mu(2,:);
            
            xSigmas = squeeze(obj.Sigma(1,1,:));
            ySigmas = squeeze(obj.Sigma(2,2,:));
            
            xs=linspace(min(xMus'-3*sqrt(xSigmas)),max(xMus'+3*sqrt(xSigmas)),spacing);
            ys=linspace(min(yMus'-3*sqrt(ySigmas)),max(yMus'+3*sqrt(xSigmas)),spacing);
            
            pdraw=zeros(1,spacing^2);
            [X Y]=meshgrid(xs,ys);
            x=X(:);
            y=Y(:);
            vtests2=[x y]';
            for k=1:obj.K
                pdraw=pdraw+obj.Priors(k).*gaussPDF(vtests2,obj.Mu(:,k),obj.Sigma(:,:,k))';
            end
            ppdraw=reshape(pdraw,spacing,spacing);


            handle = surf(axes,xs,ys,ppdraw);
            shading interp;
            
        end
        
    end
    
end

