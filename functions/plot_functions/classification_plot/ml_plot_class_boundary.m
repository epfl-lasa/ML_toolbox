function handle = ml_plot_class_boundary(X,options)
%ML_PLOT_DECISION_BOUNDARY Plot the boundary of the classes
%
%
%   input -----------------------------------------------------------------
%
%          o X       : (N x D), original data
%
%          o options : structure
%
%               options.method_name  = 'kmeans' : this options should be given
%
%
%
%
%
%
%
%% Extract plot parameters

b_plot_boundary = true;
dims            = [1,2];
titlename       = '';

if ~isfield(options,'method_name'),  error('field of method_name of structure options was not defined!'); end
if isfield(options,'b_plot_boundary'),  b_plot_boundary = options.b_plot_boundary; end
if isfield(options,'dims'),             dims = options.dims;                       end
if isfield(options,'title'),            titlename = options.title;                       end

%% Plot figure
handle = figure;

[N, D] = size(X);

switch options.method_name
    
    case 'kmeans'
        
        K          = options.K;
        centroids  = options.centroids;
        distance   = options.distance;
        labels     = options.labels;
        colors     = hsv(K);
        [Xs,Ys]    = get_grid(X,dims,1000);
        
        idx        = kmeans_classifier([Xs(:),Ys(:)],centroids(:,dims),distance);
        Z          = reshape(idx,size(Xs));
        
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        alpha(0.8)
        hold on;
        
        if b_plot_boundary == true
            scatter(X(:,1),X(:,2),50,colors(labels,:),'o','filled','MarkerEdgeColor',[0 0 0]);
        end
        ml_plot_centroid(centroids(:,dims),colors);
        
        if D == 2
            xlabel('x'); ylabel('y')
        end
        if D == 3
            xlabel('x'); ylabel('y'); zlabel('z');
        end
        
    case 'kernel-kmeans'
        
        K          = options.K;
        centroids  = options.centroids;
        labels     = options.labels;
        eigens     = options.eigens;
        kernel     = options.kernel;
        kpar       = options.kpar;
        colors     = hsv(K);
        [Xs,Ys]    = get_grid(X,dims,1000);
        
        idx        = kernelkmeans_classifier([Xs(:),Ys(:)],X,centroids(:,dims),eigens,kernel,kpar);
        Z          = reshape(idx,size(Xs));
        
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        hold on;
        if b_plot_boundary == true
            scatter(X(:,1),X(:,2),10,colors(labels,:),'filled','MarkerEdgeColor',[0 0 0]);
        end
        
    case 'adaboost'
        
        model   = options.model;
        [Xs,Ys] = get_grid(X,dims,1000);
        idx     = adaboost('apply',[Xs(:),Ys(:)],model);
        colors  = hsv(length(unique(idx)));
         Z      = reshape(idx,size(Xs));
         
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        
end

title(titlename);

end


function [Xs,Ys] = get_grid(X,dims,num_pts)

max_d1  = max(X(:,dims(1)));
min_d1  = min(X(:,dims(1)));
max_d2  = max(X(:,dims(2)));
min_d2  = min(X(:,dims(2)));
[Xs,Ys] = meshgrid(linspace(min_d1,max_d1,num_pts),linspace(min_d2,max_d2,num_pts));

end


