function [hy,model] = ml_lwr(X,y,model,lwr_options)
%LWR Locally Weighted Regression
%
%   This is a wrapper function such that it can be used easily with K-fold
%   cross validation.
%
%   input -----------------------------------------------------------------
%
%       o   X   : (N x D), input data
%
%       o   y   : (N x 1), output/predictor data
%
%       o model :  stuct, 
%
%   output ----------------------------------------------------------------
%
%   
%
%

if ~isempty(y)
% Train the model    
    lwr_obj         = LWR(lwr_options);
    lwr_obj.train(X,y);
    model.lwr       = lwr_obj;
    hy              = lwr_obj.f(X);
else
% Test the model    
    hy =  model.lwr.f(X);
end

end

