function [X,labels,gmm] = ml_clusters_data(num_samples,dim,num_classes, varargin)
%ML_CLUSTERS_DATA Generates a set of Clusters, where one cluster is one
% class. The data is samples from a Gaussian Mixture Model
%
%   input ----------------------------------------------------------------
%
%       o num_samples : (1 x 1), number of data points to generate.
%
%       o dim         : (1 x 1), dimension of the data. [2 or 3]
%
%       o num_classes : (1 x 1), number of classes. if vector
%   output ----------------------------------------------------------------
%
%       o X          : (num_samples x D), number of samples.
%
%       o labels     : (num_samples x 1), class lables of the data.
%

%% Hyperparamters to generate the data

min_dist_clusters   = 2;           % minimum distance between the cluster centers
K                   = num_classes; % number of Gaussian functions
cov_type            = 'iso';       % covariance type [full,diag,iso]
max_cov_std         = 0.8;
min_cov_std         = 0.1;

% Parameters of the GMM
Priors              = ones(1,K)./K;
Mu                  = zeros(dim,K);
Sigma               = zeros(dim,dim,K);


% number of data points per class
nb_data_per_class = zeros(1,num_classes);
if length(num_samples) == 1    
    for n=1:num_classes
        nb_data_per_class(n) = floor(num_samples/num_classes);
    end
    if sum(nb_data_per_class) ~= num_samples
        c_index = randi(3);
        nb_data_per_class(c_index) = nb_data_per_class(c_index) + (num_samples-sum(nb_data_per_class));
    end
else 
    nb_data_per_class    = num_samples;
end

% sampling volume range
a =  - num_classes * min_dist_clusters;
b =    num_classes * min_dist_clusters;

% position of first mean
Mu(:,1)      = rand_r(a,b,1,dim)';
if     strcmp(cov_type,'iso') == true
   for k=1:K
        Sigma(:,:,k) = eye(dim) .* rand_r(min_cov_std,max_cov_std,1,1); 
   end
elseif strcmp(cov_type,'diag') == true
        Sigma(:,:,k) = diag(rand_r(min_cov_std,max_cov_std,1,dim));
elseif strcmp(cov_type,'full') == true
    
else
    
end

for k=2:K
    
    % (dim x 1)
    mu_k            = rand_r(a,b,1,dim)';
    mu_k_min        = mu_k;
    min_dists       = min(sqrt(sum((repmat(mu_k',k-1,1) - Mu(:,1:k-1)').^2,2)));
    min_dist_tmp    = min_dists;
    attempts        = 0;

    while min_dists < min_dist_clusters && attempts < 20
        mu_k        = rand_r(a,b,1,dim)';
        min_dists   = min(sqrt(sum((repmat(mu_k',k-1,1) - Mu(:,1:k-1)').^2,2)));
        if(min_dists < min_dist_tmp)
           mu_k_min     = mu_k;
           min_dist_tmp = min_dists; 
        end
        attempts    = attempts + 1;
    end
    
    Mu(:,k) = mu_k_min;
    
    
end

X      = [];
labels = [];

for k=1:K    
    if nargin == 4
        offset_origin = varargin{1};
        size(offset_origin)
        Mu(:,k) = Mu(:,k) + offset_origin;        
    end    
    X       = [X;  gmm_sample(nb_data_per_class(k),1,Mu(:,k),Sigma(:,:,k))'   ];
    labels  = [labels;[ones(nb_data_per_class(k),1) .* k]];    
end
    
% [X,labels]  = gmm_sample(nb_data_class,Priors,Mu,Sigma);
% X           = X'; 
% labels      = labels(:);

gmm.Priors  = Priors;
gmm.Mu      = Mu;
gmm.Sigma   = Sigma;




end

function x = rand_r(a,b,num_samples,dim)
    x = a + (b-a) * rand(num_samples,dim);
end
