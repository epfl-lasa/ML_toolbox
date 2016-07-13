function [hy,model,Sigma] = ml_gpr(X,y,model,epsilon,rbf_var,method)
%ML_GP Gaussian Process Regression
%
%   Desired structure for ml_kcv ------------------------------------------
%
%  [hy,model] = f(X_train,labels_train,model) : used to train
%
%  hy         = f(X_test,[],model) : used to predict
%
%   input -----------------------------------------------------------------
%
%       o X         : (N x D), N input samples of dimension D.
%
%       o y         : (N x 1), N output predictions of dimension 1.
%
%       o model     : struct 
%
%       o epsilon   : measurement noise
%
%       o rbf_var   : kernel width
%
%   output ----------------------------------------------------------------
%
%
%


Sigma = [];

if ~exist('method','var'), method='gpml'; end


if ~isempty(y)
% Train the model    
    model.X_train = X;
    model.y_train = y;
    
    if strcmp(method,'gdc')
        
        [hy,Sigma] = gaussian_process(X,y,X,epsilon,rbf_var);
        
    elseif strcmp(method,'gpml')
        
        meanfunc     = {@meanZero};
        covfunc      = {@covSEiso}; 
        ell          = rbf_var;     % kernel width of RBF covariance function.
        sf           = 1;           % signal variance (not measurement noise)
        sn           = epsilon;      % measurement noise
        hyp          = [];
        hyp.cov      = log([ell; sf]);
        hyp.lik      = log(sn);
        [hy,Sigma]   = gp(hyp, @infExact, meanfunc, covfunc, @likGauss, X, y, X);
    
    else
        
        error(['No such method defined: ' method]);
    
    end
    
    
else
% Test the model    
    
    if strcmp(method,'gdc')
        
        [hy,Sigma]    = gaussian_process(model.X_train,model.y_train,X,epsilon,rbf_var);
        
    elseif strcmp(method,'gpml')
        
        meanfunc     = {@meanZero};
        covfunc      = {@covSEiso}; 
        ell          = rbf_var;     % kernel width of RBF covariance function.
        sf           = 1;           % signal variance (not measurement noise)
        sn           = epsilon;      % measurement noise
        hyp          = [];
        hyp.cov      = log([ell; sf]);
        hyp.lik      = log(sn);
        
        
        [hy,Sigma]   = gp(hyp, @infExact, meanfunc, covfunc, @likGauss, model.X_train,model.y_train, X);      
        
    else
        
        error(['No such method defined: ' method]);
    
    end
    
end





end

