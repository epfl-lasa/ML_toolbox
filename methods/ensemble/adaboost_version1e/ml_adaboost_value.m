function [predict_label] = ml_adaboost_value(X,model)
%ML_ADABOOST_VALUE Computes the value of the adaboost classifer f
%
%   AdaBoost classifer  f(x) = sign ( \sum_{m=1}^m \alpha_m h_m(x) )
%
%   input ----------------------------------------------------------------
%
%       o X     : (N x D), dataset of N points of dimension D.
%
%       o model : struct,  returned by adaboost.m
%
%
%




% Limit datafeatures to orgininal boundaries
if(length(model)>1);
    minb=model(1).boundary(1:end/2);
    maxb=model(1).boundary(end/2+1:end);
    X=bsxfun(@min,X,maxb);
    X=bsxfun(@max,X,minb);
end

% Add all results of the single weak classifiers weighted by their alpha
predict_label=zeros(size(X,1),1);
for t=1:length(model);
    predict_label=predict_label+model(t).alpha*ApplyClassTreshold(model(t), X);
end




end

