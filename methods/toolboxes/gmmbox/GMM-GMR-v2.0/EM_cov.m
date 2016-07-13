function [Priors, Mu, Sigma, Pix] = EM_cov(Data, Priors0, Mu0, Sigma0,CovarianceType,regulisation)
%
% Expectation-Maximization estimation of GMM parameters.
% This source code is the implementation of the algorithms described in
% Section 2.6.1, p.47 of the book "Robot Programming by Demonstration: A
% Probabilistic Approach".
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% This function learns the parameters of a Gaussian Mixture Model
% (GMM) using a recursive Expectation-Maximization (EM) algorithm, starting
% from an initial estimation of the parameters.
%
%
% Inputs -----------------------------------------------------------------
%   o Data:    D x N array representing N datapoints of D dimensions.
%   o Priors0: 1 x K array representing the initial prior probabilities
%              of the K GMM components.
%   o Mu0:     D x K array representing the initial centers of the K GMM
%              components.
%   o Sigma0:  D x D x K array representing the initial covariance matrices
%              of the K GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the
%              K GMM components.
%
% This source code is given for free! However, I would be grateful if you refer
% to the book (or corresponding article) in any academic publication that uses
% this code or part of it. Here are the corresponding BibTex references:
%
% @book{Calinon09book,
%   author="S. Calinon",
%   title="Robot Programming by Demonstration: A Probabilistic Approach",
%   publisher="EPFL/CRC Press",
%   year="2009",
%   note="EPFL Press ISBN 978-2-940222-31-5, CRC Press ISBN 978-1-4398-0867-2"
% }
%
% @article{Calinon07,
%   title="On Learning, Representing and Generalizing a Task in a Humanoid Robot",
%   author="S. Calinon and F. Guenter and A. Billard",
%   journal="IEEE Transactions on Systems, Man and Cybernetics, Part B",
%   year="2007",
%   volume="37",
%   number="2",
%   pages="286--298",
% }

%% Criterion to stop the EM iterative update
loglik_threshold = 1e-6;

%% Regularisation

if ~exist('regulisation','var'), regulisation = 1e-4; end

%% Initialization of the parameters
[nbVar, nbData] = size(Data);
nbStates = size(Sigma0,3);
loglik_old = -realmax;
nbStep = 0;

Mu = Mu0;
Sigma = Sigma0;
Priors = Priors0;


%% EM fast matrix computation (see the commented code for a version
%% involving one-by-one computation, which is easier to understand)
while 1
    %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:nbStates
        %Compute probability p(x|i)
        Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
    end
    %Compute posterior probability p(i|x)
    Pix_tmp = repmat(Priors,[nbData 1]).*Pxi;
    Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 nbStates]);
    %Compute cumulated posterior probability
    E = sum(Pix);
    
    %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(CovarianceType,'full')
        for i=1:nbStates
            %Update the priors
            Priors(i) = E(i) / nbData;
            %Update the centers
            Mu(:,i) = Data*Pix(:,i) / E(i);
            %Update the covariance matrices
            Data_tmp1 = Data - repmat(Mu(:,i),1,nbData);
            Sigma(:,:,i) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(i);
            %% Add a tiny variance to avoid numerical instability
            Sigma(:,:,i) = Sigma(:,:,i) + regulisation.*diag(ones(nbVar,1));
        end
        
    elseif strcmp(CovarianceType,'diag')
                    %Update the priors
            Priors(i) = E(i) / nbData;
            %Update the centers
            Mu(:,i) = Data*Pix(:,i) / E(i);
            %Update the covariance matrices
            Data_tmp1 = Data - repmat(Mu(:,i),1,nbData);
            Sigma(:,:,i) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(i);
            %% Add a tiny variance to avoid numerical instability
            Sigma(:,:,i) = Sigma(:,:,i) + regulisation.*diag(ones(nbVar,1));
            Sigma(:,:,i) = diag(diag(Sigma(:,:,i)));
        
    elseif strcmp(CovarianceType,'isotropic')

            %Update the priors
            Priors(i) = E(i) / nbData;
            %Update the centers
            Mu(:,i) = Data*Pix(:,i) / E(i);
            %Update the covariance matrices
            Dist_sqr      = sum((Data - repmat(Mu(:,i),1,nbData)).^2,1);
            Sigma(:,:,i)  = eye(nbVar,nbVar) .* ((Dist_sqr * Pix(:,i))./sum(Pix(:,i))) ./ nbVar;
            Sigma(:,:,i) = Sigma(:,:,i) + regulisation.*diag(ones(nbVar,1));
    end
    
    %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
    for i=1:nbStates
        %Compute the new probability p(x|i)
        Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
    end
    %Compute the log likelihood
    F = Pxi*Priors';
    F(find(F<realmin)) = realmin;
    loglik = mean(log(F));
    %Stop the process depending on the increase of the log likelihood
    if abs((loglik/loglik_old)-1) < loglik_threshold
        break;
    end
    loglik_old = loglik;
    nbStep = nbStep+1;
end



% %% EM slow one-by-one computation (better suited to understand the
% %% algorithm)
% while 1
%   %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Compute probability p(x|i)
%     Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
%   end
%   %Compute posterior probability p(i|x)
%   for j=1:nbData
%     Pix(j,:) = (Priors.*Pxi(j,:))./(sum(Priors.*Pxi(j,:))+realmin);
%   end
%   %Compute cumulated posterior probability
%   E = sum(Pix);
%   %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Update the priors
%     Priors(i) = E(i) / nbData;
%     %Update the centers
%     Mu(:,i) = Data*Pix(:,i) / E(i);
%     %Update the covariance matrices
%     covtmp = zeros(nbVar,nbVar);
%     for j=1:nbData
%       covtmp = covtmp + (Data(:,j)-Mu(:,i))*(Data(:,j)-Mu(:,i))'.*Pix(j,i);
%     end
%     Sigma(:,:,i) = covtmp / E(i);
%   end
%   %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Compute the new probability p(x|i)
%     Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
%   end
%   %Compute the log likelihood
%   F = Pxi*Priors';
%   F(find(F<realmin)) = realmin;
%   loglik = mean(log(F));
%   %Stop the process depending on the increase of the log likelihood
%   if abs((loglik/loglik_old)-1) < loglik_threshold
%     break;
%   end
%   loglik_old = loglik;
%   nbStep = nbStep+1;
% end

%% Add a tiny variance to avoid numerical instability
for i=1:nbStates
    Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
end

