function [y, Sigma_y] = GMR(Priors, Mu, Sigma, x, in, out)
%
% Gaussian Mixture Regression.
% This source code is the implementation of the algorithms described in 
% Section 2.4, p.38 of the book "Robot Programming by Demonstration: A 
% Probabilistic Approach".
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% This function performs Gaussian Mixture Regression (GMR), using the 
% parameters of a Gaussian Mixture Model (GMM). Given partial input data, 
% the algorithm computes the expected distribution for the resulting 
% dimensions. By providing temporal values as inputs, it thus outputs a 
% smooth generalized version of the data encoded in GMM, and associated 
% constraints expressed by covariance matrices.
%
% Inputs -----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%   o x:       P x N array representing N datapoints of P dimensions.
%   o in:      1 x P array representing the dimensions to consider as
%              inputs.
%   o out:     1 x Q array representing the dimensions to consider as
%              outputs (D=P+Q).
% Outputs ----------------------------------------------------------------
%   o y:       Q x N array representing the retrieved N datapoints of 
%              Q dimensions, i.e. expected means.
%   o Sigma_y: Q x Q x N array representing the N expected covariance 
%              matrices retrieved. 
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

nbData = size(x,2);
nbVar = size(Mu,1);
nbStates = size(Sigma,3);

%% Fast matrix computation (see the commented code for a version involving 
%% one-by-one computation, which is easier to understand).
%%
%% Compute the influence of each GMM component, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:nbStates
  Pxi(:,i) = Priors(i).* gaussPDF(x, Mu(in,i), Sigma(in,in,i));
end
beta = Pxi./repmat(sum(Pxi,2)+realmin,1,nbStates);
%% Compute expected means y, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nbStates
  y_tmp(:,:,j) = repmat(Mu(out,j),1,nbData) + Sigma(out,in,j)*inv(Sigma(in,in,j)) * (x-repmat(Mu(in,j),1,nbData));
end
beta_tmp = reshape(beta,[1 size(beta)]);
y_tmp2 = repmat(beta_tmp,[length(out) 1 1]) .* y_tmp;
y = sum(y_tmp2,3);
%% Compute expected covariance matrices Sigma_y, given input x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nbStates
  Sigma_y_tmp(:,:,1,j) = Sigma(out,out,j) - (Sigma(out,in,j)*inv(Sigma(in,in,j))*Sigma(in,out,j));
end
beta_tmp = reshape(beta,[1 1 size(beta)]);
Sigma_y_tmp2 = repmat(beta_tmp.*beta_tmp, [length(out) length(out) 1 1]) .* repmat(Sigma_y_tmp,[1 1 nbData 1]);
Sigma_y = sum(Sigma_y_tmp2,4);


% %% Slow one-by-one computation (better suited to understand the algorithm) 
% %%
% %% Compute the influence of each GMM component, given input x
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:nbStates
%   Pxi(:,i) = gaussPDF(x, Mu(in,i), Sigma(in,in,i));
% end
% beta = (Pxi./repmat(sum(Pxi,2)+realmin,1,nbStates))';
% %% Compute expected output distribution, given input x
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y = zeros(length(out), nbData);
% Sigma_y = zeros(length(out), length(out), nbData);
% for i=1:nbData
%   % Compute expected means y, given input x
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for j=1:nbStates
%     yj_tmp = Mu(out,j) + Sigma(out,in,j)*inv(Sigma(in,in,j)) * (x(:,i)-Mu(in,j));
%     y(:,i) = y(:,i) + beta(j,i).*yj_tmp;
%   end
%   % Compute expected covariance matrices Sigma_y, given input x
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for j=1:nbStates
%     Sigmaj_y_tmp = Sigma(out,out,j) - (Sigma(out,in,j)*inv(Sigma(in,in,j))*Sigma(in,out,j));
%     Sigma_y(:,:,i) = Sigma_y(:,:,i) + beta(j,i)^2.* Sigmaj_y_tmp;
%   end
% end
