function handle = ml_plot_class_boundary_2(X,f,options)
%ML_PLOT_DECISION_BOUNDARY Plot the boundary of the classes
%
%
%   input -----------------------------------------------------------------
%
%          o X       : (N x D), original data
%
%          o f       : function handle, classifier, f.
%                       - y = f(X); y are class labels.
%                                 
%
%% Extract plot parameters

dims            = [1,2];
no_figure       = false; % if false plots a new figure

if isfield(options,'dims'),             dims        = options.dims;                       end
if isfield(options,'no_figure'),        no_figure   = options.no_figure;                  end



%% Plot figure
if no_figure == false
    handle = figure;
else
    handle = [];
end


[Xs,Ys]     = get_grid(X,dims,1000);
    Zs      = f([Xs(:),Ys(:)]);     
num_classes = unique(Zs);        

colors      = hsv(length(num_classes));
         
pcolor(Xs,Ys,reshape(Zs,size(Xs))); 
shading interp;
colormap(colors);
        


end


function [Xs,Ys] = get_grid(X,dims,num_pts)

max_d1  = max(X(:,dims(1)));
min_d1  = min(X(:,dims(1)));
max_d2  = max(X(:,dims(2)));
min_d2  = min(X(:,dims(2)));
[Xs,Ys] = meshgrid(linspace(min_d1,max_d1,num_pts),linspace(min_d2,max_d2,num_pts));

end


