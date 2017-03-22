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
%
%  output ----------------------------------------------------------------
%
%

%% Default options

outputs = [];
K       = 1;  % default number of clusters is assumed to be 1.
kernel  = 'gauss';
kpar    = 1;


%% Check input

if ~isfield(options,'method_name'),  error('field of method_name of structure options was not defined!'); end
if isfield(options,'K'),             K = options.K;end
if isfield(options,'kernel')         [kernel, kpar] = sanitise_kernel_input(options);end


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
        
        
        outputs.distance        = distance;
        outputs.K               = K;
        outputs.method_name     = 'kmeans';
        outputs.labels          = idx;
        outputs.centroids       = centroids;
        
        
    case 'kernel-kmeans'
        
        % Old implementation, not working properly
%        Kn                       = gram(X, X, kernel,kpar(1),kpar(2));
%        [idx,centroids,eigens]   = kernelkmeans(Kn, K);
%        outputs.K               = K;
%        outputs.method_name     = 'kernel-kmeans';
%        outputs.labels          = idx;
%        outputs.centroids       = centroids;
%        outputs.eigens          = eigens;
%        outputs.kernel          = kernel;
%        outputs.kpar            = kpar;

       % New implementation, working! But no decision boundaries or
       % isolines .. not yet at least
       [M, ~] = size(X);
       init = ceil(K*rand(1,M));
       % Using new implementation
       if strcmp(kernel,'gauss')            
            % Gaussian Kernel
            [y,model,mse] = knKmeans(X',init,@knGauss, kpar(1));
       elseif strcmp(kernel,'poly')
            % Gaussian Kernel
            [y,model,mse] = knKmeans(X',init,@knPoly, kpar(2), kpar(1));
       end
       outputs.K               = K;
       outputs.eigens          = model.eigens;
       outputs.lambda          = diag(model.lambda);
       outputs.centroids       = model.centroids;
       outputs.method_name     = 'kernel-kmeans';
       outputs.mse             = mse;
       outputs.labels          = y;       
       outputs.kernel          = kernel;
       outputs.kpar            = kpar;
            
end
