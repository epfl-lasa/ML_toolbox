function [projectedData, mapping] = ml_projection(X,options)
%ML_PROJECTION Does a proection of the data.
%
%   input -----------------------------------------------------------------
%   
%       o X : (N x D), a data set with N samples each being of dimension D.
%
%       o options : structure containing the options for the projection
%                   method in question.
%
%               options.method_name  = 'PCA' : this options should be given
%               options.nbDimensions =  3    : the number of dimensions to
%                                             keep when doing the
%                                             projection.
%
%   output ----------------------------------------------------------------
%
%      o projectedData : data after the projection, keeping only the number
%      of dimensions given in the options
%      o mapping : a structure containing the main parameter, results of
%      the algorithm (eigen values ...)
%
%
%

if ~isfield(options,'method_name')
    error('field of method_name of structure options was not defined!');
end

if ~isfield(options,'nbDimensions')
    warning('options.nbDimensions not specified!, setting default value, options.nbDimensions=2');
    options.nbDimensions = 2;
end

if ~isfield(options,'neighbors') && (strcmp(options.method_name,'Isomap') || strcmp(options.method_name,'LLE') || strcmp(options.method_name,'Laplacian'))
    warning('options.neighbors not specified!, setting default value, options.neighbors=7');
    options.neighbors = 7;
end

nbDimensions        = options.nbDimensions;

switch options.method_name
    
    case {'PCA', 'MDS'}     
        [projectedData, mapping] = compute_mapping(X, options.method_name, nbDimensions);
        
    case 'KPCA'
        
        [kernel,kpar]                = sanitise_kernel_input(options);
        norm_K = true;
        
        if isfield(options,'norm_K')
            if (options.norm_K == false)
            display('Kernel (Gram) matrix will NOT be normalized!');
            norm_K = false;
            end            
        end
        
        if length(kpar) == 1
            [projectedData, mapping] = compute_mapping(X, 'KPCA',nbDimensions,norm_K,kernel,kpar(1));
        else
            [projectedData, mapping] = compute_mapping(X, 'KPCA',nbDimensions,norm_K,kernel,kpar(1),kpar(2));    
        end
        
    case {'Isomap'}
	neighbors = options.neighbors;
    [projectedData, mapping] = compute_mapping(X, options.method_name, nbDimensions, neighbors);

    
    case {'Laplacian'}
	neighbors = options.neighbors;
    sigma = options.sigma;
    [projectedData, mapping] = compute_mapping(X, options.method_name, nbDimensions, neighbors, sigma);
        
        
    otherwise
        error(['no such method [' options.method_name '] handled!']);
        
end


end

