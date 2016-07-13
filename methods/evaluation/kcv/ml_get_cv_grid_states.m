function [ stats ] = ml_get_cv_grid_states(test,train)
%ML_GET_CV_GRID_STATS Compute statistics on K-fold Cross Validation (CV).
%
%   input -----------------------------------------------------------------
%
%       o test  : cell array (M x 1), M is the number of parameters for
%                                     which K-fold CV has been evaluated on.
%
%           test{i}.accuracy  : (1 x K), K number of
%           test{i}.precision : (P x K), P is the total number of classes
%           test{i}.recall    : (P x K)
%           test{i}.fmeasure  : (P x K)
%
%
%       o train : cell array (M x 1),
%
%               train{i}: structure is the same as for test
%
%   output ----------------------------------------------------------------
%      
%       o stats : struct , returns statistics on train and test sets
%
%           stats.train  : (statistics on the training data set)                     
%               
%               - stats.train.acc : (statistics on the accuracy for the training set)                      
%
%                   - stats.train.acc.mean 
%                   - stats.train.acc.std
%
%       the structure is the same for the test statistics 
%
%% Check if grid search was done on > 1 parameters

[P, N] = size(test);

if N > 1
    test = test(:);
    train = train(:);
end

%% Extract Statitistics
M = length(test);
K = length(test{1}.accuracy);

stats.train.acc.mean = zeros(1,K);
stats.train.acc.std  = zeros(1,K);

stats.test.acc.mean = zeros(1,K);
stats.test.acc.std  = zeros(1,K);

for m=1:M

    stats.test.acc.mean(m) = mean(test{m}.accuracy);
    stats.test.acc.std(m)  = std(test{m}.accuracy);
    
    stats.train.acc.mean(m) = mean(train{m}.accuracy);
    stats.train.acc.std(m)  = std(train{m}.accuracy);
    
end


%% Reshape stats if grid search on > 1 parameters
if N > 1
    
    tmp = reshape(stats.test.acc.mean, P, N);
    stats.test.acc.mean = tmp;
    stats.test.acc.std  = reshape(stats.test.acc.std, P, N);

    stats.train.acc.mean = reshape(stats.train.acc.mean, P, N);
    stats.train.acc.std  = reshape(stats.train.acc.std, P, N);

end


end

