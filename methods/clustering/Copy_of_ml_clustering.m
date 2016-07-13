function [outputs] = ml_clustering(X,options,varargin)
%ML_CLUSTERING Applies clustering technique to the data
%
%   input -----------------------------------------------------------------
%   
%       o X : (N x D), a data set with N samples each being of dimension D.
%
%       o options : structure
%
%               options.method_name  = 'kmeans' : this options should be given
%               options.dimensionOfVisualization = 2 : number of dimension
%
%               options.gridStep = 0.05 : step to compute the region of the
%               clusters (!!! Don't put too small number (< 0.05) for 3D) 
%               of the space to vizualise the results
%               options.k =  2    : the number of clusters
%               options.distance = 'sqeuclidean' : for kmeans, the distance
%               used among 'sqeuclidean', 'cityblock' (L1), 'cosine'
%               options.kernel = 'gauss' : for kernel k-means, the kernel
%               used among 'gauss', 'poly'
%               options.kpar = 1 : parameter(s) of the kernel
%
%   output ----------------------------------------------------------------
%
%       o truePredictedCluster : the predicted labels (same order than the
%       given labels)
%       o outputs :
%           o trueCentroids : the centroids of the clusters
%           o region : the predicted labels for 2D points
%           o accuracy : the percentage of good prediction
%           o dataNormalized : normalization in [0 1] of X
%           o trueBadClassifiedSamples : the indices of the bad classified
%           samples
%           o XGrid : the 2D points used to predict the region of the clusters
%
%
%

%% Default options

outputs = [];
K       = 1;  % default number of clusters is assumed to be 1.


%% Check input

if ~isfield(options,'method_name'),  error('field of method_name of structure options was not defined!'); end
if isfield(options,'K'),             K = options.K;                                                       end



% if ~isfield(options,'dimensionOfVisualization')
%     warning('options.dimensionOfVisualization not specified!, default value : 2');
%     options.dimensionOfVisualization = 2;
% end
% 
% if(options.dimensionOfVisualization < 2 || options.dimensionOfVisualization > 3)
%     error('Please specify 2 or 3 for options.dimensionOfVisualization');
% end
% 
% if ~isfield(options,'k')
%     error('options.k not specified!, please indicate the number of clusters');
% end
% 
% if ~isfield(options,'distance') && strcmp(options.method_name,'kmeans')
%     warning('options.distance not specified!, Euclidian distance by default');
%     options.distance = 'sqeuclidean';
% end
% 
% if ~isfield(options,'gridStep')
%     warning('options.gridStep not specified!, 0.05 by default');
%     options.gridStep = 0.05;
% end



%Normalize the data

%dataNormalized = (X-min(X(:)))/(max(X(:)) - min(X(:)));

%Define number of clusters

switch options.method_name
                
    case 'kmeans'
           
        if isempty(varargin)
            [idx, centroids]    = kmeans(X, K);   
        else
            [idx, centroids]    = kmeans(X, K,varargin{:});
        end
        
        pnames                  =  {   'distance'  'start' 'replicates' 'emptyaction' 'onlinephase' 'options' 'maxiter' 'display'};
        dflts                   =  {'sqeuclidean' 'plus'          []  'singleton'         'on'        []        []        []};
        distance                =  internal.stats.parseArgs(pnames, dflts, varargin{:});
        distNames               = {'sqeuclidean','cityblock','cosine','correlation','hamming'};
        distance                =  internal.stats.getParamVal(distance,distNames,'''Distance''');
        
        outputs.K               = K;
        outputs.method_name     = 'kmeans';
        outputs.labels          = idx;
        outputs.centroids       = centroids;
        outputs.distance        = distance;
        
%         % Detemining the accuracy of the method
%         accuracy = 0;
%         perm = perms(1:k);
%         trueCentroids = centroids;
%         predictedClusterPerm = predictedCluster;
% 
%         for j=1:size(perm,1)
%             totalBadClassifiedSamples = 0;
%             badClassifiedSamples = [];
%             for i=1:length(predictedCluster)
%                 predictedClusterPerm(i)=perm(j,predictedCluster(i));
%                 if(predictedClusterPerm(i) ~= labels(i))
%                     totalBadClassifiedSamples = totalBadClassifiedSamples + 1;
%                     badClassifiedSamples = [badClassifiedSamples i];
%                 end
%             end
%             acc = 1 - totalBadClassifiedSamples/i;
%             if(acc > accuracy)
%                 accuracy=acc;
%                 truePredictedCluster = predictedClusterPerm;
%                 for ind=1:k
%                     trueCentroids(perm(j,ind),:) = centroids(ind,:);
%                 end
%                 trueBadClassifiedSamples = badClassifiedSamples;
%             end
%         end            
% 
%         x1 = 0:options.gridStep:1;
%         x2 = 0:options.gridStep:1;
%         [x1G,x2G] = meshgrid(x1,x2);
%         XGrid = [x1G(:),x2G(:)];   
%         if options.dimensionOfVisualization == 3
%             x3 = 0:options.gridStep:1;
%             [x1G,x2G,x3G] = meshgrid(x1,x2,x3);
%             XGrid = [x1G(:),x2G(:),x3G(:)];  
%         end
%         
%         region = kmeans(XGrid,k,'MaxIter',1,'Start',trueCentroids(:,1:options.dimensionOfVisualization));
        

    case 'kernel-kmeans'
        
        if strcmp(options.method_name, 'kernel-kmeans')
            [kernel, kpar] = sanitise_kernel_input(options);
        end

        switch kernel
            case 'gauss'
                Kn = knGauss(dataNormalized',dataNormalized',kpar);

            case'poly'
                Kn = knPoly(dataNormalized',dataNormalized',kpar(1),kpar(2));

        end

        [idx] = kernelkmeans(Kn, k);
        centroids=zeros(k,size(Kn,2));
        projectedClusteredData = Kn;
        for i = 1:k
            centroids(i,:)= sum(projectedClusteredData(idx==i,:),1)/size(projectedClusteredData(idx==i,:),1);
        end            

%         % Detemining the accuracy of the method
%         accuracy = 0;
%         perm = perms(1:k);
%         predictedClusterPerm = predictedCluster;
%         trueCentroids = centroids;
% 
%         for j=1:size(perm,1)
%             totalBadClassifiedSamples = 0;
%             badClassifiedSamples = [];
%             for i=1:length(predictedCluster)
%                 predictedClusterPerm(i)=perm(j,predictedCluster(i));
%                 if(predictedClusterPerm(i) ~= labels(i))
%                     totalBadClassifiedSamples = totalBadClassifiedSamples + 1;                        
%                     badClassifiedSamples = [badClassifiedSamples i];
%                 end
%             end
%             acc = 1 - totalBadClassifiedSamples/i;
%             if(acc > accuracy)
%                 accuracy=acc;
%                 for ind=1:k
%                     trueCentroids(perm(j,ind),:) = centroids(ind,:);
%                 end                
%                 truePredictedCluster = predictedClusterPerm;
%                 trueBadClassifiedSamples = badClassifiedSamples;
%             end
%         end
% 
%         x1 = 0:options.gridStep:1;
%         x2 = 0:options.gridStep:1;
%         [x1G,x2G] = meshgrid(x1,x2);
%         XGrid = [x1G(:),x2G(:)];   
%         if options.dimensionOfVisualization == 3
%             x3 = 0:options.gridStep:1;
%             [x1G,x2G,x3G] = meshgrid(x1,x2,x3);
%             XGrid = [x1G(:),x2G(:),x3G(:)];  
%         end
%                  
% 
%         switch kernel
%             case 'gauss'
%                 KnGrid = knGauss(XGrid',dataNormalized(:,1:options.dimensionOfVisualization)',kpar);
% 
%             case'poly'
%                 KnGrid = knPoly(XGrid',dataNormalized(:,1:options.dimensionOfVisualization)',kpar(1),kpar(2));
%         end
% 
%         region = kmeans(KnGrid,k,'MaxIter',1,'Start',trueCentroids);

end

% outputs.centroids           = trueCentroids;
% outputs.regions             = region;
% outputs.accuracy            = accuracy;
% outputs.dataNormalized      = dataNormalized;
% outputs.badClassifiedSamples= trueBadClassifiedSamples;
% outputs.gridPoints          = XGrid;
