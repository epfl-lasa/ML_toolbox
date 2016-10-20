function [ Sigma ] = ml_covariance( X, Mu, type )
%ML_COVARIANCE computes the covariance matrix of X given a covariance type.
%
% Inputs -----------------------------------------------------------------
%       o X     : (N x M), a data set with M samples each being of dimension N.
%                          each column corresponds to a datapoint
%       o Mu    : (N x 1), an Nx1 matrix corresponding to the centroid mu_k \in R^Nn
%       o type  : string , type={'full', 'diag', 'iso'} of Covariance matrix
%
% Outputs ----------------------------------------------------------------
%       o Sigma : (N x N), an NxN matrix representing the covariance matrix of the 
%                          Gaussian function
%%

% Auxiliary Variable
[N, M] = size(X);
regularization = 1e-4;

% Output Variable
Sigma = zeros(N, N);

switch type
        case 'full'  % Equation 6   

            % Zero-mean Data
            X = bsxfun(@minus, X, Mu);
            Sigma = (1/(M-1))*X*X';
            
        case 'diag' % Equation 6  + diag()
            % Zero-mean Data
            X = bsxfun(@minus, X, Mu);
            Sigma = (1/(M-1))*X*X';
            Sigma = diag(diag(Sigma));

        case 'iso'    % Equation 7         
            sqr_dist = sum((X - repmat(Mu,1,M)).^2,1);                                
            c_var    = sum(sqr_dist) ./ M ./ N;
            Sigma    = eye(N) .* c_var;

        otherwise
            warning('Unexpected Covariance type. No Covariance computed.')
end

% Add a tiny variance to avoid numerical instability
Sigma = Sigma + regularization*eye(N);

end

