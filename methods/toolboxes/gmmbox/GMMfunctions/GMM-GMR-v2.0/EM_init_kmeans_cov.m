function [Priors, Mu, Sigma] = EM_init_kmeans_cov(Data, nbStates,CovarianceType,regularise)
%
% This function initializes the parameters of a Gaussian Mixture Model
% (GMM) by using k-means clustering algorithm.
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Data:     D x N array representing N datapoints of D dimensions.
%   o nbStates: Number K of GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:   1 x K array representing the prior probabilities of the
%               K GMM components.
%   o Mu:       D x K array representing the centers of the K GMM components.
%   o Sigma:    D x D x K array representing the covariance matrices of the
%               K GMM components.
% Comments ---------------------------------------------------------------
%   o This function uses the 'kmeans' function from the MATLAB Statistics
%     toolbox. If you are using a version of the 'netlab' toolbox that also
%     uses a function named 'kmeans', please rename the netlab function to
%     'kmeans_netlab.m' to avoid conflicts.

[nbVar, nbData] = size(Data);

if ~exist('CovarianceType','var'),CovarianceType='full';end
if ~exist('regularise','var'),regularise=1E-5;end


%Use of the 'kmeans' function from the MATLAB Statistics toolbox
[Data_id, Centers] = kmeans(Data', nbStates,'dist','sqeuclidean','replicates',3,'start','plus','MaxIter',500);
Mu = Centers';

regulisation = 1E-5;

if strcmp(CovarianceType,'full')
    
    for i=1:nbStates
        idtmp = find(Data_id==i);
        Priors(i) = length(idtmp);
        Sigma(:,:,i) = cov([Data(:,idtmp) Data(:,idtmp)]');
        %Add a tiny variance to avoid numerical instability
        Sigma(:,:,i) = Sigma(:,:,i) + regularise.*diag(ones(nbVar,1));
    end
    
elseif strcmp(CovarianceType,'diag')
    
    for i=1:nbStates
        idtmp = find(Data_id==i);
        Priors(i) = length(idtmp);
        Sigma(:,:,i) = cov([Data(:,idtmp) Data(:,idtmp)]');
        %Add a tiny variance to avoid numerical instability
        Sigma(:,:,i) = Sigma(:,:,i) + regularise.*diag(ones(nbVar,1));
        
        Sigma(:,:,i) = diag(diag(Sigma(:,:,i)));
    end
    
elseif strcmp(CovarianceType,'isotropic')
    
    for i=1:nbStates
        idtmp = find(Data_id==i);
        N     = length(idtmp);
        Priors(i) = N;
        
        % square distance betweeen cluster points and the mean
        sqr_dist     = sum((Data(:,idtmp)'  - repmat(Mu(:,i),1,N)').^2,2);       
        c_var        = max(((sum(sqr_dist) ./ N) ./ nbVar),regulisation);
        Sigma(:,:,i) = eye(nbVar,nbVar) .* c_var;
        %Add a tiny variance to avoid numerical instability
      %  Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
    end
    
end



Priors = Priors ./ sum(Priors);


