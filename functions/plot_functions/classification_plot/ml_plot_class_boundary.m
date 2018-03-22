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
%               options.method_name  = 'kmeans' : for k-means clustering
%                                      'gmm'    : for GMM clustering
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
plot_labels     = [];
label_font_size = 14;
axis_limits     = [];

if ~isfield(options,'method_name'),  error('field of method_name of structure options was not defined!'); end
if isfield(options,'b_plot_boundary'),   b_plot_boundary = options.b_plot_boundary; end
if isfield(options,'dims'),              dims = options.dims;                       end
if isfield(options,'title'),             titlename = options.title;                       end
if isfield(options,'plot_labels'),       plot_labels = options.plot_labels;  end
if isfield(options,'axis_limits'),       axis_limits = options.axis_limits;  end

%% Plot figure
handle = figure;

[N, D] = size(X);

switch options.method_name
    
    case 'kmeans'
        
        K          = options.K;
        centroids  = options.centroids;
        distance   = options.distance;
        
        if strcmp(distance,'L1')
            distance    = 'cityblock';
        elseif strcmp(distance,'L2')
            distance    = 'sqeuclidean';
        elseif strcmp(distance,'Linf')
            distance    = 'Linf';
        end
        
        labels     = options.labels;
        colors     = hsv(K);
        
        if isempty(axis_limits)
            [Xs,Ys] = get_grid(X,dims,1000);
        else
            [Xs,Ys] = get_grid_limits(X,axis_limits,1000);
        end
        
        if ~strcmp(distance,'LInf')
            idx        = kmeans_classifier([Xs(:),Ys(:)],centroids(:,dims),distance);
        else
            d_i =  my_distX2Mu([Xs(:),Ys(:)]', centroids', distance);
            [~, idx] = min(d_i, [], 1);
        end
        
        Z          = reshape(idx,size(Xs));
        
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        alpha(0.8)
        hold on;
        
        if b_plot_boundary == true
            scatter(X(:,1),X(:,2),50,colors(labels,:),'o','filled','MarkerEdgeColor',[0 0 0]);
        end
        ml_plot_centroid(centroids(:,dims),colors);       
        
    case 'kernel-kmeans'
        
        K          = options.K;
        centroids  = options.centroids;
        labels     = options.labels;
        eigens     = options.eigens;
        kernel     = options.kernel;
        kpar       = options.kpar;
        colors     = hsv(K);
        
        if isempty(axis_limits)
            [Xs,Ys] = get_grid(X,dims,250);
        else
            [Xs,Ys] = get_grid_limits(X,axis_limits,250);
        end
               
        if strcmp(kernel,'gauss')            
            % Gaussian Kernel
            idx = knKmeansPredict([Xs(:),Ys(:)]', X', labels, @knGauss, kpar(1));
       elseif strcmp(kernel,'poly')
            % Polynomial Kernel
            idx = knKmeansPredict([Xs(:),Ys(:)]', X', labels, @knPoly,  kpar(2), kpar(1));
        end        
%         idx        = kernelkmeans_classifier([Xs(:),Ys(:)],X,centroids(dims,:),eigens,kernel,kpar);
        Z          = reshape(idx,size(Xs));
        
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        alpha(0.8)
        hold on;
        if b_plot_boundary == true
            scatter(X(:,1),X(:,2),50,colors(labels,:),'filled','MarkerEdgeColor',[0 0 0]);
        end
        
    case 'adaboost'
        
        model   = options.model;
        
        if isempty(axis_limits)
            [Xs,Ys] = get_grid(X,dims,1000);
        else
            [Xs,Ys] = get_grid_limits(X,axis_limits,1000);
        end
        
        idx     = adaboost('apply',[Xs(:),Ys(:)],model);
        colors  = hsv(length(unique(idx)));
         Z      = reshape(idx,size(Xs));
         
        pcolor(Xs,Ys,Z); shading interp;
        colormap(colors);
        
    case 'gmm'

        Priors = options.gmm.Priors;
        Mu = options.gmm.Mu;
        Sigma = options.gmm.Sigma;
        type = options.type;
        labels = options.labels;
        K = length(Priors);
        
        if isempty(axis_limits)
            [Xs,Ys] = get_grid(X,dims,1000);
        else
            [Xs,Ys] = get_grid_limits(X,axis_limits,1000);
        end
        colors  = hsv(K);
        colors(end+1,:) = 0.5*[1;1;1];
        
        switch type
            case 'hard'
                idx = gmm_cluster([Xs(:), Ys(:)]', Priors, Mu, Sigma, type, options.softThresholds);
                Z = reshape(idx,size(Xs));
                pcolor(Xs,Ys,Z); shading interp;
                colormap(colors(1:K,:));
            case 'soft'
                [idx] = gmm_cluster([Xs(:), Ys(:)]', Priors, Mu, Sigma, type, options.softThresholds);
                
                idx(find(idx==0)) = K + 1;
                %idx_clustered = idx(find(idx~=0));
                %idx_clustered = idx(find(idx~=0));
                Z = reshape(idx,size(Xs));
                pcolor(Xs,Ys,Z); shading interp;
                
                if(length(unique(idx)) == K)
                    colormap(colors(1:K,:));
                else
                    colormap(colors(:,:));
                end
        end
        
        hold on;
        
        labels(find(labels==0)) = K + 1;
        if b_plot_boundary == true
            scatter(X(:,1),X(:,2),50,colors(labels,:),'o','filled','MarkerEdgeColor',[0 0 0]);
        end
        
        ml_plot_centroid(Mu(dims,:)',colors);
        
        if D == 2
            xlabel('x'); ylabel('y')
        end 
         
end



if isempty(plot_labels)
    if D >= 1
        xlabel({'$x_1$'}, 'Interpreter','Latex','FontSize',label_font_size,'FontName','Times', 'FontWeight','Light');
    end
    if D >= 2
        ylabel({'$x_2$'}, 'Interpreter','Latex','FontSize',label_font_size,'FontName','Times', 'FontWeight','Light');
    end
else
    if D >= 1
        xlabel(plot_labels{1},'Interpreter','Latex', 'FontSize',label_font_size,'FontName','Times', 'FontWeight','Light');
    end
    if D >= 2
        ylabel(plot_labels{2},'Interpreter','Latex','FontSize',label_font_size,'FontName','Times', 'FontWeight','Light');
    end
end

title(titlename, 'Interpreter','Latex', 'FontSize',14);

end


function [Xs,Ys] = get_grid(X,dims,num_pts)

max_d1  = max(X(:,dims(1)));
min_d1  = min(X(:,dims(1)));
max_d2  = max(X(:,dims(2)));
min_d2  = min(X(:,dims(2)));
[Xs,Ys] = meshgrid(linspace(min_d1,max_d1,num_pts),linspace(min_d2,max_d2,num_pts));

end

function [Xs,Ys] = get_grid_limits(X,axis_limits,num_pts)

max_d1  = axis_limits(1);
min_d1  = axis_limits(2);
max_d2  = axis_limits(3);
min_d2  = axis_limits(4);
[Xs,Ys] = meshgrid(linspace(min_d1,max_d1,num_pts),linspace(min_d2,max_d2,num_pts));

end

