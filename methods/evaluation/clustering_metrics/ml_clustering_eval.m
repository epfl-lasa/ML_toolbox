function [rss,aic,bic] = ml_clustering_eval(X,options)
%ML_CLUSTERING_EVAL Evaluate a clustering method. This is the main
% clustering evaluation function.
%
%   input -----------------------------------------------------------------
%
%       o X : (N x D), a data set with N samples each being of dimension D.
%
%       o options : structure
%
%               options.method_name  = 'kmeans' : this options should be given



if ~isfield(options,'method_name'),  error('field of method_name of structure options was not defined!'); end


switch options.method_name
                
    case 'kmeans'
        
        [labels,C,dist] = ml_kmeans_get_param(options);               
        
        if isfield(options,'lambda')
            [rss,bic,aic]  = ml_kmeans_eval(X,labels,C,dist,options.lambda);
        else                         
            [rss,bic,aic]  = ml_kmeans_eval(X,labels,C,dist);     
        end
        
        
    case 'kernel-kmeans'
    
        
        
end



end

