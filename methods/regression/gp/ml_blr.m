function [hy,model,Sigma] = ml_blr(X,y,model)
%ML_BLR Bayesian Linear Regression
%
%   Bayesian Linear Regression, we seek to learn a regression function 
%   where the relation between the predictor variable, y and the domain X
%   is linear in the parameters whilst assuming a prior probability
%   distribtion over the parameters
%
%     y = f(x) + \epsilon, \epsilon ~ N(0,var) (regression model)       (1)
%   
%     y = x' * w with w ~ N(0,\Sigma_p)                                 (2)

%  Documentation ----------------------------------------------------------
%
%   The input to the function will determine whether it will be used for
%   training or for testing.
%
%  [hy,model] = f(X_train,labels_train,[])   % Training
%
%  [hy]       = f(X_test,[],model)           % Testing
%
%
%   This is a wrapper function such that it can be used easily with K-fold
%   cross validation.
%
%   input -----------------------------------------------------------------
%
%       o   X   : (N x D), input data
%
%       o   y   : (N x 1), output/predictor data (for Training)
%
%       o model :  stuct,
%
%               model.w       : (D x 1), parameter of linear function
%               model.e_var   : (1 x 1), variance of the noise in the signal
%               model.Sigma_p : (D x D), digonal matrix, variance on the
%                                        weights, w.
%
%   output ----------------------------------------------------------------
%
%       o hy    : (N x 1), predicted output
%
%       o model : struct, trained model
%
%           - model.w = (1 x D).


N = size(X,1);

if ~isempty(y)
    % Train the model

    [w,A]       = train_blr(X,y,model.e_var,model.Sigma_p);
    model.A     = A;
    model.w     = w;
    
    X           = [X,ones(N,1)];
    hy          = w' * X';
    invA        = pinv(A);
    Sigma       = X * invA * X';
    
else
    
    % Test the model
    
    X           = [X,ones(N,1)];
    hy          = model.w' * X';
    invA        = pinv(model.A);
    Sigma       = X * invA * X';
    
end

hy = hy(:);


end

