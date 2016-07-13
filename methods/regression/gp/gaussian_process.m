function  [Mu,Sigma,K,py] = gaussian_process(X,y,X_test,epsilon,rbf_var)
%GAUSSIAN_PROCESS 
%
%
%       y_i = f(x_i) + \epsilon,   \epsilon ~ N(0,var)
%
%       S = {(y_i,x_i)}, set of training data
%
%       p(y_test|x_test,S) = P(|) P(S) 
%
%
%   input -----------------------------------------------------------------
%
%       o X      : (N x D), set of training points 
%
%       o y      : (N x 1), set of prediction training points
%
%       o X_test : (M x D), set of testing points
%
%   output ----------------------------------------------------------------
%
%       o Mu: (M x 1), mean of the regression (prediction)
%       
%       o Sigma: (M x M), Covariance of the regression (prediction)


%% Get Dimension and number of data points
[N,D]   = size(X);
M       = size(X_test,1);

X       = X';
y       = y(:)';
X_test  = X_test';



%     (D x (N + M))

[index_i,index_j] = meshgrid(1:(N+M),1:(N+M));

X = [X, X_test];
K = rbf_k(index_i(:),index_j(:),X,rbf_var);

i = 1:N; % index for test
j = (N+1):(N+M);

%  Inv    = inv(K(i,i) +  epsilon .* eye(N,N)) 
%  Mu     = K(j,i) * Inv * y_train';
%  Sigma  = K(j,j) + epsilon .* eye(M,M) - K(j,i) * Inv * K(i,j); 

%% Page 19, Algorithm 2.1 [http://www.gaussianprocess.org/gpml/chapters/RW2.pdf]
L       = chol(K(i,i) +  epsilon .* eye(N,N),'lower'); 
alpha   = L'\(L\y');
Mu      = K(j,i) * alpha;
v       = L\K(i,j);
Sigma   = K(j,j) - v'* v;

py      = -0.5 * y * alpha - sum(log(diag(L))) - (D/2) * log(2*pi); % log marginal


Sigma  = diag(Sigma);


end

