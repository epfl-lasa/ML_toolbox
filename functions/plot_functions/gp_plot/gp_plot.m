function [handle,hps] = gp_plot(X,f,dims,options)
%GP_PLOT 
%
%   input -----------------------------------------------------------------
%
%       o X :    (N x D),    original training data, used to determine the bounaries
%                            of the plot.
%
%       o dims : (1 x 2),    input dimensions of data X to be used with f.      
%
%
%       o f : function handle,  a trained GP model
%
%         - [Mu,Sigma]  = f(X_test)                      
%
%
%

%% Process input
num_samples = 50;
D           = size(X,2); 
bFigure     = true;
title_name  = 'your title';
handle      = [];
hps         = [];

if isfield(options,'bFigure'), bFigure = options.bFigure;       end
if isfield(options,'title'),   title_name   = options.title;    end
if isfield(options,'num_samples'),   num_samples   = options.num_samples;    end


%% Plot

if D == 1 % plot 1 input, 1 output regressor function
    
    if bFigure
        handle = figure;
        set(gcf,'color','w');
    end
   
    min_x  = min(X);
    max_x  = max(X);
    X_test = linspace(min_x,max_x,num_samples)';
   
    [Mu,~,Sigma]  = f(X_test);     
    
    hps.f   = plot(X_test,Mu,'-r','LineWidth',1);
    hps.fsm = plot(X_test,Mu-1.*sqrt(Sigma),'--r','LineWidth',1);
    hps.fsp = plot(X_test,Mu+1.*sqrt(Sigma),'--r','LineWidth',1);
    
    if bFigure
        title(title_name);
    end
else      % plot 2 input, 1 output regressor function
   

   handle = ml_plot_value_func(X,f,dims,options);
    
end

%% Plot attributes, name, lables, scaling, etc...


end

