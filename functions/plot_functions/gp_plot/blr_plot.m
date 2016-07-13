function handles = blr_plot(X,f,options)
%BLR_PLOT Plot Bayesian Linear regression
%
%   input -----------------------------------------------------------------
%
%       o X : (N x D), original data
%   
%       o f : function handle
%
%       o options : struct
%
%% Process input
bFigure = false;
dims    = [1,2];
num_pts = 100;
color   = [1 0 0];

if isfield(options,'bFigure'),      bFigure     = options.bFigure;      end
if isfield(options,'dims'),         dims        = options.dims;         end
if isfield(options,'num_pts'),      num_pts     = options.num_pts;      end
if isfield(options,'color'),        color       = options.color;        end

D = size(X,2);

%% Plot
handles = [];

if bFigure
   handles.hf = figure; 
   set(gcf,'color','w'); box on; grid on;
else
   hold on; 
end

[Xs,Ys] = ml_get_grid(X,1,num_pts);


if D == 1
    
    [hy,~,Sigma_h] = f(Xs(:));
    
    handles.r_line      = plot(Xs,hy,'-');
    handles.r_up_line   = plot(Xs,hy+1.*sqrt(diag(Sigma_h)),'--r','LineWidth',1);
    handles.r_down_line = plot(Xs,hy-1.*sqrt(diag(Sigma_h)),'--r','LineWidth',1);
    
    handles.r_line.Color        = color;
    handles.r_up_line.Color     = color;
    handles.r_down_line.Color   = color;
    
else
    
    
end



end

