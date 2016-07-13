function [mus, stds] = ml_clustering_optimise(X,Ks,repeats,cluster_options,varargin)
% ML_CLUSTERING_OPTIMISE Find the optimal number of clusters.
%
%
%   input -----------------------------------------------------------------
%
%       o X      : (N x D), a data set with N samples each being of dimension D.
%
%       o Ks     : (1 x M), set of clusters to try
%
%       o repeats: (1 x 1), number of repetitions  (needed for error bars)
%
%       o options: structure, clustering data strucutre
%
%               options.method_name  = 'kmeans' : this options should be given
%
%   output ----------------------------------------------------------------
%
%       o mus   : (3 x |Ks|), mean values of rss, aic and bic
% 
%       o stds  : (3 x |Ks|), standard deviation of rss, aic and bic
%
%

Ks          = Ks(:);
M           = length(Ks);
evals       = zeros(repeats,3,length(Ks));
mus         = zeros(3,size(evals,3));
stds        = mus;
aic_lambda  = [];

if isfield(cluster_options,'lambda'), aic_lambda = cluster_options.lambda; end
   

%% Main loop
fprintf('\nOptimising clusters\n');
for i=1:repeats
    disp(['repeat: ' num2str(i) '/' num2str(repeats)]);
    for j=1:M
        disp([num2str(j) '/' num2str(M)]);
        cluster_options.K   = Ks(j);
        result              = ml_clustering(X,cluster_options,varargin{:});
        option_eval         = result;
                    
        if ~isempty(aic_lambda)
            option_eval.lambda  = aic_lambda;
        end
             
        [rss,aic,bic]       = ml_clustering_eval(X,option_eval);          

        evals(i,1,j)        = rss;
        evals(i,2,j)        = aic;
        evals(i,3,j)        = bic;
        
    end
end

%% Compute mean and standard deviations

if repeats == 1
    for i=1:3
        tmp = reshape(evals(:,i,:),repeats,[]);
        mus(i,:)  = tmp;
    end 
else
    for i=1:3
        tmp = reshape(evals(:,i,:),repeats,[]);
        mus(i,:)  = mean(tmp);
        stds(i,:) = std(tmp);
    end 
end

end

