function [B_hat,mapping,predict] = linear_classifier(mode,X,y,w,type,model,mapping)
%LINEAR_CLASSIFIER  Simple weak classifier (or regressor)
%
%
%  input ------------------------------------------------------------------
%
%       o  mode : string,  either 'train' or 'predict'
%
%       o   X   : (N x D), dataset of N samples of dimension D.
%
%       o   y   : (N x 1), predictor value.
%
%                - classification (binary):  y \in \{-1,+1}
%                - regression             :  y \in R
%
%       o   w   : (N x 1), set of weights; the importance each data point
%                         has with in terms of correctness. The weights
%                         must sum to one, sum(w) = 1.
%                  
%       o type  : string,  either 'classification' or 'regression'.
%               
%                 - default value = 'classification'
%
%       o model : set of learned regression parameters 
%
%   output ----------------------------------------------------------------
%
%       o  B_hat : (D+1 x K), K hyperplanes. The +1 term is the bias.
%
%

B_hat   = [];
predict = [];

if strcmpi(mode,'train')
    
    y = y(:);
    
    if (strcmpi(type, 'classification'))
        % (N x K)
        [Y,mapping] = ml_labels2Kencoding( y );
    end
    
    % The input matrix is prepended with a column of 1s to provide a bias
    % value. This makes the hat matrix N+1x1 or N+1xK, i.e. it represents
    % a hyperplane in one more than the number of dimensions in the
    % input space.
    
    % (N x D+1)
    Xone = [ones(size(X, 1), 1) X];
    
    % (N x N)
    W    = diag(w);
    
    %        (D+1 x N) (N x N) (N x D+1) \  (D+1 x N) (N x N) (N x K)
    %        (D+1 x D+1) \ (D+1 x K)
    %        (D+1 x K)
    B_hat = (Xone' * W * Xone) \ (Xone' * W * Y);
    
   
else
    
    % (N x D)
    %  X is test data    
    
    % (D+1 x K)
    B_hat = model;
    
    % (N x D+1)
    Xone  = [ones(size(X, 1), 1) X];
    
    % (N x D+1) * (D+1 x K)
    % (N x K)
    [~,predict] = max(Xone * B_hat,[],2);
    
    label_uniq = unique(predict);
    
    predict_tmp = zeros(size(predict));
   
    for i=1:length(label_uniq)
        idx = find(label_uniq(i)==predict);
        predict_tmp(idx) = mapping(i);
    end
    
    predict = predict_tmp;
    
end


end

