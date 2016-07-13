function [ stats ] = ml_get_cv_grid_states_regression(test,train)
%ML_GET_CV_GRID_STATES_REGRESSION
%
%   input -----------------------------------------------------------------
%
%       o test  : cell array (M x 1), M is the number of parameters for
%                                     which K-fold CV has been evaluated on.
%
%           test{i}.mse  : (1 x K), K number of
%
%   output ----------------------------------------------------------------
%
%       o stats : struct , returns statistics on train and test sets
%
%           stats.train  : (statistics on the training data set)                     
%               
%               - stats.train.acc : (statistics on the accuracy for the training set)                      
%
%                   - stats.train.mse.mean 
%                   - stats.train.mse.std
%
%       the structure is the same for the test statistics 
%
%

%% Check if grid search was done on > 1 parameters

N = size(test);

if length(N) > 1
    test = test(:);
    train = train(:);
end

%% Prepare train statistics struct
M                    = length(test);

%% Get statistics

for m=1:M

    
    %% Get Mean for [Train]
    stats.train.mse.mean(m)     = mean(train{m}.mse);   
    stats.train.nmse.mean(m)    = mean(train{m}.nmse);   
    stats.train.rmse.mean(m)    = mean(train{m}.rmse);  
    stats.train.nrmse.mean(m)   = mean(train{m}.nrmse);  
    stats.train.mae.mean(m)     = mean(train{m}.mae);  
    stats.train.mare.mean(m)    = mean(train{m}.mare);  
    stats.train.r.mean(m)       = mean(train{m}.r);  
    stats.train.d.mean(m)       = mean(train{m}.d);  
    stats.train.e.mean(m)       = mean(train{m}.e);  
    stats.train.me.mean(m)      = mean(train{m}.me);  
    stats.train.mre.mean(m)     = mean(train{m}.mre);  
    
    %% Get Std for [Train]
    
    stats.train.mse.std(m)     = std(train{m}.mse);   
    stats.train.nmse.std(m)    = std(train{m}.nmse);   
    stats.train.rmse.std(m)    = std(train{m}.rmse);  
    stats.train.nrmse.std(m)   = std(train{m}.nrmse);  
    stats.train.mae.std(m)     = std(train{m}.mae);  
    stats.train.mare.std(m)    = std(train{m}.mare);  
    stats.train.r.std(m)       = std(train{m}.r);  
    stats.train.d.std(m)       = std(train{m}.d);  
    stats.train.e.std(m)       = std(train{m}.e);  
    stats.train.me.std(m)      = std(train{m}.me);  
    stats.train.mre.std(m)     = std(train{m}.mre);  
    
    %% Get Mean for [Test]
    stats.test.mse.mean(m)     = mean(test{m}.mse);   
    stats.test.nmse.mean(m)    = mean(test{m}.nmse);   
    stats.test.rmse.mean(m)    = mean(test{m}.rmse);  
    stats.test.nrmse.mean(m)   = mean(test{m}.nrmse);  
    stats.test.mae.mean(m)     = mean(test{m}.mae);  
    stats.test.mare.mean(m)    = mean(test{m}.mare);  
    stats.test.r.mean(m)       = mean(test{m}.r);  
    stats.test.d.mean(m)       = mean(test{m}.d);  
    stats.test.e.mean(m)       = mean(test{m}.e);  
    stats.test.me.mean(m)      = mean(test{m}.me);  
    stats.test.mre.mean(m)     = mean(test{m}.mre);  
    
    %% Get Std for [Test]
    
    stats.test.mse.std(m)     = std(test{m}.mse);   
    stats.test.nmse.std(m)    = std(test{m}.nmse);   
    stats.test.rmse.std(m)    = std(test{m}.rmse);  
    stats.test.nrmse.std(m)   = std(test{m}.nrmse);  
    stats.test.mae.std(m)     = std(test{m}.mae);  
    stats.test.mare.std(m)    = std(test{m}.mare);  
    stats.test.r.std(m)       = std(test{m}.r);  
    stats.test.d.std(m)       = std(test{m}.d);  
    stats.test.e.std(m)       = std(test{m}.e);  
    stats.test.me.std(m)      = std(test{m}.me);  
    stats.test.mre.std(m)     = std(test{m}.mre);  
     
        
end

if length(N) > 1
    
    stats.train.mse.mean     = reshape(stats.train.mse.mean,N);  
    stats.train.nmse.mean    = reshape(stats.train.nmse.mean,N);   
    stats.train.rmse.mean    = reshape(stats.train.rmse.mean,N);
    stats.train.nrmse.mean   = reshape(stats.train.nrmse.mean,N);
    stats.train.mae.mean     = reshape(stats.train.mae.mean,N);
    stats.train.mare.mean    = reshape(stats.train.mare.mean,N);  
    stats.train.r.mean       = reshape(stats.train.r.mean,N);
    stats.train.d.mean       = reshape(stats.train.d.mean,N); 
    stats.train.e.mean       = reshape(stats.train.e.mean,N);  
    stats.train.me.mean      = reshape(stats.train.me.mean,N);
    stats.train.mre.mean     = reshape(stats.train.mre.mean,N);

    
    stats.train.mse.std     = reshape(stats.train.mse.std,N);  
    stats.train.nmse.std    = reshape(stats.train.nmse.std,N);   
    stats.train.rmse.std    = reshape(stats.train.rmse.std,N);
    stats.train.nrmse.std   = reshape(stats.train.nrmse.std,N);
    stats.train.mae.std     = reshape(stats.train.mae.std,N);
    stats.train.mare.std    = reshape(stats.train.mare.std,N);  
    stats.train.r.std       = reshape(stats.train.r.std,N);
    stats.train.d.std       = reshape(stats.train.d.std,N); 
    stats.train.e.std       = reshape(stats.train.e.std,N);  
    stats.train.me.std      = reshape(stats.train.me.std,N);
    stats.train.mre.std     = reshape(stats.train.mre.std,N);
    
    stats.test.mse.mean     = reshape(stats.test.mse.mean,N);  
    stats.test.nmse.mean    = reshape(stats.test.nmse.mean,N);   
    stats.test.rmse.mean    = reshape(stats.test.rmse.mean,N);
    stats.test.nrmse.mean   = reshape(stats.test.nrmse.mean,N);
    stats.test.mae.mean     = reshape(stats.test.mae.mean,N);
    stats.test.mare.mean    = reshape(stats.test.mare.mean,N);  
    stats.test.r.mean       = reshape(stats.test.r.mean,N);
    stats.test.d.mean       = reshape(stats.test.d.mean,N); 
    stats.test.e.mean       = reshape(stats.test.e.mean,N);  
    stats.test.me.mean      = reshape(stats.test.me.mean,N);
    stats.test.mre.mean     = reshape(stats.test.mre.mean,N);
    
    stats.test.mse.std     = reshape(stats.test.mse.std,N);  
    stats.test.nmse.std    = reshape(stats.test.nmse.std,N);   
    stats.test.rmse.std    = reshape(stats.test.rmse.std,N);
    stats.test.nrmse.std   = reshape(stats.test.nrmse.std,N);
    stats.test.mae.std     = reshape(stats.test.mae.std,N);
    stats.test.mare.std    = reshape(stats.test.mare.std,N);  
    stats.test.r.std       = reshape(stats.test.r.std,N);
    stats.test.d.std       = reshape(stats.test.d.std,N); 
    stats.test.e.std       = reshape(stats.test.e.std,N);  
    stats.test.me.std      = reshape(stats.test.me.std,N);
    stats.test.mre.std     = reshape(stats.test.mre.std,N);

end


end

