function [train_eval,test_eval]  = ml_kcv_regression_eval( X,y,g,train,test,k,train_eval,test_eval)
%ML_KCV_REGRESSION_EVAL 
%
%   Evaluation of the Goodness of Fit of your regression model. Have look
%   at http://uk.mathworks.com/help/curvefit/evaluating-goodness-of-fit.html
%   for a reference.
%
%  input ------------------------------------------------------------------
%   
%       o   X        : (N x D),  input variables
%
%       o   y        : (N x 1),  output variables
%
%       o   g        : function handle, y = g(x)
%
%       o   train    : (M x 1),  set of indicies of X to use as train data.
%
%       o   test     : (P x 1),  set of indicies of X to use for testing.
%
%       o   k        : (1 x 1),  current iteration of k-fold
%

%   output ----------------------------------------------------------------
%       
%       o   train_eval : struct
%
%       o   test_eval  : struct


%% Evaluate regression function on training data

hy = g(X(train(:),:));

gf = gfit2(y(train(:)),hy,'all');

train_eval.mse(k)   = gf(1);    %  '1'  - mean squared error (mse)
train_eval.nmse(k)  = gf(2);    %  '2'  - normalised mean squared error (nmse)
train_eval.rmse(k)  = gf(3);    %  '3'  - root mean squared error (rmse)
train_eval.nrmse(k) = gf(4);    %  '4'  - normalised root mean squared error (nrmse)
train_eval.mae(k)   = gf(5);    %  '5'  - mean absolute error (mae)
train_eval.mare(k)  = gf(6);    %  '6'  - mean  absolute relative error  (mare)
train_eval.r(k)     = gf(7);    %  '7'  - coefficient of correlation (r)
train_eval.d(k)     = gf(8);    %  '8'  - coefficient of determination (d)
train_eval.e(k)     = gf(9);    %  '9'  - coefficient of efficiency (e)
train_eval.me(k)    = gf(10);   %  '10' - maximum absolute error
train_eval.mre(k)   = gf(11);   %  '11' - maximum absolute relative error


%% Evaluate regression function on test data

hy = g(X(test(:),:));

gf = gfit2(y(test(:)),hy,'all');

test_eval.mse(k)   = gf(1);    %  '1'  - mean squared error (mse)
test_eval.nmse(k)  = gf(2);    %  '2'  - normalised mean squared error (nmse)
test_eval.rmse(k)  = gf(3);    %  '3'  - root mean squared error (rmse)
test_eval.nrmse(k) = gf(4);    %  '4'  - normalised root mean squared error (nrmse)
test_eval.mae(k)   = gf(5);    %  '5'  - mean absolute error (mae)
test_eval.mare(k)  = gf(6);    %  '6'  - mean  absolute relative error  (mare)
test_eval.r(k)     = gf(7);    %  '7'  - coefficient of correlation (r)
test_eval.d(k)     = gf(8);    %  '8'  - coefficient of determination (d)
test_eval.e(k)     = gf(9);    %  '9'  - coefficient of efficiency (e)
test_eval.me(k)    = gf(10);   %  '10' - maximum absolute error
test_eval.mre(k)   = gf(11);   %  '11' - maximum absolute relative error


end

