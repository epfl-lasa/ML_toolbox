function [train_eval,test_eval] = ml_kcv_clustering_eval(X,labels,g,train,test,k,train_eval,test_eval,varargin)
%ML_CLUSTERING_EVAL
%
%  input ------------------------------------------------------------------
%   
%       o   X        : (N x D), dataset.
%
%       o   labels   : (N x 1),  class labels : if classification (discrete)
%
%       o   g        : function handle, y = g(x)
%
%       o   train    : (M x 1),  set of indicies of X to use as train data.
%
%       o   test     : (P x 1),  set of indicies of X to use for testing.
%
%       o   k        : (1 x 1),  current iteration of k-fold
%
%       o   varargin : if you want to have a different set of labels to
%                       test put it here
%
%   output ----------------------------------------------------------------
%       
%       o   train_eval : struct
%
%       o   test_eval  : struct



 % Evaluate classifier on train data
    
    M                        = ml_confusion_matrix(X(train(:),:),labels(train(:)),g);
    [A, P, R, F, FPR, TNR]   = ml_confusion_matrix_evaluation(M);
    
    if isempty(k)
        k = 1;
    end
    train_eval.accuracy(k)    = A;
    %     train_eval.precision(:,k) = P;
    %     train_eval.recall(:,k)    = R;
    train_eval.fmeasure(k)    = F;
    train_eval.fpr(k)         = FPR;
    train_eval.tnr(k)         = TNR;    
    
    if (test~=0)
        % Evaluate classifier on test data
        if(length(varargin) == 0)
            M           = ml_confusion_matrix(X(test(:),:),labels(test(:)),g);
        else
            labelsTest = varargin{1};
            M           = ml_confusion_matrix(X(test(:),:),labelsTest(test(:)),g);
        end
       
        [A, P, R, F, FPR, TNR]   = ml_confusion_matrix_evaluation(M);
        
        test_eval.accuracy(k)    = A;
        %     train_eval.precision(:,k) = P;
        %     train_eval.recall(:,k)    = R;
        test_eval.fmeasure(k)    = F;
        test_eval.fpr(k)         = FPR;
        test_eval.tnr(k)         = TNR;
    end
end

