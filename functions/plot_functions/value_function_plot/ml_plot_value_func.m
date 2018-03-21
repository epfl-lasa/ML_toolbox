function [handle,hs] = ml_plot_value_func(X,f,dims,options)
%ML_PLOT_VALUE_FUNC Plots a value function associated with a 
% generative density model, a regressor which provides a likelihood or any 
% other function.
%
%
%   input -----------------------------------------------------------------
%
%       o X    : (N x D), original dataset on which f was learned. It is
%                         needed to be able to determine the plotting boundaries.
%
%       o dims : (1 x 2), input dimensions of data X to be used with f.      
%
%
%       o f  : function handle, z = f(X)
%
%

%% Process input and set default options

num_samples = 50;
title_name  = 'your title';
handle      = [];
surf_type   = 'surf';
regr_type   = 'LR';
color       = 'k';
points_size = 15;
bFigure     = true;
bColorbar   = false;
Cmap        = 'hot'; 

if isfield(options,'Cmap'),         Cmap         = options.Cmap;        end
if isfield(options,'color'),        color        = options.color;       end
if isfield(options,'bFigure'),      bFigure      = options.bFigure;     end
if isfield(options,'bColorbar'),    bColorbar    = options.bColorbar;   end
if isfield(options,'points_size'),  points_size  = options.points_size; end
if isfield(options,'title'),        title_name   = options.title;       end
if isfield(options,'surf_type'),    surf_type    = options.surf_type;   end
if isfield(options,'regr_type'),    regr_type    = options.regr_type;   end

%% Get boundary of original data.
X = X(:,dims);
min_x = min(X(:,1));
max_x = max(X(:,1));
min_y = min(X(:,2));
max_y = max(X(:,2));
[X,Y]  = meshgrid(linspace(min_x,max_x,num_samples),linspace(min_y,max_y,num_samples));

%% Evaluate f

switch regr_type
    case 'LR'
        Data = [X(:),Y(:)];        
    case 'GMR'    
        Data = [X(:),Y(:)]';        
end
z      = f(Data);

%% Plot

if bFigure
    handle = figure;
    set(gcf,'color','w');

end

if strcmp(surf_type,'surf')

    hs = surf(X,Y,reshape(z,size(X)));
    
elseif strcmp(surf_type,'scatter')
    
    hs = scatter3(X(:),Y(:),z(:),points_size, color,'filled');

elseif strcmp(surf_type,'pcolor')

    hs = pcolor(X,Y,reshape(z,size(X))); shading interp;
   
end

%% Plot Colorbar
if bColorbar
    colorbar;
end
%% Plot attributes, name, lables, scaling, etc...

if bFigure
    title(title_name, 'Interpreter','Tex','FontName','Times', 'FontWeight','Light','FontSize',15); 
    xlabel('$\xi_x$','Interpreter','LaTex','FontName','Times', 'FontWeight','Light','FontSize',15);
    ylabel('$\xi_y$','Interpreter','LaTex','FontName','Times', 'FontWeight','Light','FontSize',15);
    zlabel('$\kappa$','Interpreter','LaTex','FontName','Times', 'FontWeight','Light', 'FontSize',15); 
    axis tight
end

colormap (Cmap)


end

