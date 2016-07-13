function [hy,model] = ml_ls(X,y,model)
%ML_LS Least-Square Regression
%
%   hy = w^{T} x
%
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
%               model.w = (D x 1), parameter of linear function, y = w^T x
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
X         = [X,ones(N,1)]; % add bias

%         (D x N) (N x D) \ (D x N) (N x 1) = (D x 1)
model.w = (X'* X) \ ( X' * y);
%        (1 x D)  * (D x N) = (1 x N)
hy      = model.w' * X';
hy      = hy(:); % (N x 1)

else
% Test the model    
X       = [X,ones(N,1)]; 
hy      = model.w' * X';
hy      = hy(:); % (N x 1)
end



end

