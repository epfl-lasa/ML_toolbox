function [handles] = ml_plot_regression(X,f,options)
%ML_PLOT_REGRESSION Plots a regression function
%
%   input -----------------------------------------------------------------
%
%       o X : (N x D), original data; used to find boundaries
%
%       o f : function handle, handle to regressor function y = f(x)
%
%       o options : struct
%
%   output ----------------------------------------------------------------
%
%       o handle : figure handle
%
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
    
    hy = f(Xs(:));
    handles.r_line = plot(Xs,hy,'-');
    handles.r_line.Color = color;
    
else
    
    
end



end

