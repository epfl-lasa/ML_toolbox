function [test_eval,train_eval] = ml_kcv(X,labels,K,f, ml_type, varargin)
%ML_KCV K-fold Cross-Validation
%
%  input ------------------------------------------------------------------
%
%       o   X       : (N x D), dataset.
%
%       o   labels  : (N x 1),
%
%               - class labels : if classification (discrete)
%
%               - predictor y  : if regression (continuous)
%
%       o   K       : (1 x 1), number of folds .
%
%       o   f       : function handle, can be used both to train and test
%                     a classifier.
%
%                     [labels_predict,model] = f(X_train,labels_train,[])
%
%                     [labels_predict]       = f(X_test,[],model)
%
%       o  ml_type  : string, can be 'classification' or 'regression'
%
%
%       o  varargin : if you want to have a different set of labels to
%                     test put it here
%
%   output ----------------------------------------------------------------
%
%       o test_eval  : struct, containes evaluation metrics for each test bin.
%
%                       test_eval.accuracy  : (1 x K)
%                       test_eval.precision : (1 x K)
%                       test_eval.recall    : (1 x K)
%                       test_eval.fmeasure  : (1 x K)
%
%
%       o train_eval : struct, same as for test_eval, but evaluation is
%                              instead done on the test data.
%

N           = size(X,1);
idx         = randperm(N);
bin_size    = round(N/K);
bins        = cell(1,K);

if length(varargin) > 0
    C = varargin{1};
    model_type = varargin{2};
else
    C = 1;
    model_type = '';
end
%% Divid indices of data into K bins
s_i = 1;
e_i = bin_size;
for k=1:K-1
    bins{k} = idx(s_i:e_i);
    s_i     = e_i + 1;
    e_i     = s_i + bin_size -1;
end
bins{K}     = idx(s_i:end);
%% CV

if strcmp(ml_type,'classification')
    num_class           = length(unique(labels));

    train_eval.accuracy  = zeros(1,K);
    %     train_eval.precision = zeros(num_class,K);
    %     train_eval.recall    = zeros(num_class,K);
    train_eval.fmeasure  = zeros(1,K);
    train_eval.fpr       = zeros(1,K);
    train_eval.tnr       = zeros(1,K);
    
    test_eval.accuracy   = zeros(1,K);
    %     train_eval.precision = zeros(num_class,K);
    %     train_eval.recall    = zeros(num_class,K);
    test_eval.fmeasure  = zeros(1,K);
    test_eval.fpr       = zeros(1,K);
    test_eval.tnr       = zeros(1,K);
    
    % Model Statistics for SVM
    train_eval.totSV      = zeros(1,K);
    train_eval.ratioSV    = zeros(1,K);
    train_eval.posSV      = zeros(1,K);
    train_eval.negSV      = zeros(1,K);
    train_eval.boundSV    = zeros(1,K);            
    
    
elseif strcmp(ml_type,'regression')
    
    train_eval.mse      = zeros(1,K);    %  '1'  - mean squared error (mse)
    train_eval.nmse     = zeros(1,K);    %  '2'  - normalised mean squared error (nmse)
    train_eval.rmse     = zeros(1,K);    %  '3'  - root mean squared error (rmse)
    train_eval.nrmse    = zeros(1,K);    %  '4'  - normalised root mean squared error (nrmse)
    train_eval.mae      = zeros(1,K);    %  '5'  - mean absolute error (mae)
    train_eval.mare     = zeros(1,K);    %  '6'  - mean  absolute relative error  (mare)
    train_eval.r        = zeros(1,K);    %  '7'  - coefficient of correlation (r)
    train_eval.d        = zeros(1,K);    %  '8'  - coefficient of determination (d)
    train_eval.e        = zeros(1,K);    %  '9'  - coefficient of efficiency (e)
    train_eval.me       = zeros(1,K);    %  '10' - maximum absolute error
    train_eval.mre      = zeros(1,K);    %  '11' - maximum absolute relative error    
    test_eval           = train_eval;

else
    
    error(['No such ml_type: ' ml_type ' supported, only classification and regression']);
    
end


if K == 1 % Do grid search on data - no cv
    
    train = 1:length(labels);
    test  = 0;
    
    % Train the classifier
    [~,model]    = f(X(train(:),:),labels(train(:)),[]);
    
    % g is the trained classifier
    g           = @(X)f(X,[],model);
    
    if strcmp(ml_type,'classification')

        if strcmp(model_type,'rvm')
            % Check binary labels are correct
            labels(find(labels==-1)) = 0;           
        end       
        
       [train_eval,test_eval] = ml_kcv_clustering_eval(X,labels,g,train,test,k,train_eval,test_eval);        
       
       if strcmp(model_type,'svm')
            % Model Statistics for SVM
            train_eval.totSV         = model.totalSV;
            train_eval.ratioSV       = model.totalSV/length(train);
            train_eval.posSV         = model.nSV(1)/model.totalSV;
            train_eval.negSV         = model.nSV(2)/model.totalSV;
            train_eval.boundSV       = sum(abs(model.sv_coef) == C)/model.totalSV;
        end
        

        
    elseif strcmp(ml_type,'regression')
        
        [train_eval,test_eval] = ml_kcv_regression_eval(X,labels,g,train,test,k,train_eval,test_eval);
        
    end
    
else    % Do proper cv on split data
    
    
    disp(' ');
    disp('starting K-fold Cross-Validation');
    disp(' ');

    for k=1:K
        
        disp([num2str(k) '/' num2str(K)]);
        
        train_idx    = 1:K;
        train_idx(k) = [];
        
        test         = bins{k};
        train        = cell2mat(bins(train_idx));
        
        disp(['train pts ' num2str(length(train)) '/ test pts ' num2str(length(test))]);
        
        % Train the classifier
        [~,model]    = f(X(train(:),:),labels(train(:)),[]);
        if isempty (model)
            warning('Something went wrong, skipping this fold!')
        else
            % g is the trained classifier
            g           = @(X)f(X,[],model);
            
            if strcmp(ml_type,'classification')
                
                if strcmp(model_type,'rvm')
                    % Check binary labels are correct
                    labels(find(labels==-1)) = 0;
                end
                
                [train_eval,test_eval] = ml_kcv_clustering_eval(X,labels,g,train,test,k,train_eval,test_eval);
                
                if strcmp(model_type,'svm')
                    % Model Statistics for SVM
                    train_eval.totSV(k)      = model.totalSV;
                    train_eval.ratioSV(k)    = model.totalSV/length(train);
                    train_eval.posSV(k)      = model.nSV(1)/model.totalSV;
                    train_eval.negSV(k)      = model.nSV(2)/model.totalSV;
                    train_eval.boundSV(k)    = sum(abs(model.sv_coef) == C)/model.totalSV;
                end
                
            elseif strcmp(ml_type,'regression')
                
                [train_eval,test_eval] = ml_kcv_regression_eval(X,labels,g,train,test,k,train_eval,test_eval);
                
            end
        end
        
    end
    

end

disp('....CV finished!');

end

