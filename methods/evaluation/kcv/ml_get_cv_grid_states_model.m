function [ stats ] = ml_get_cv_grid_states_model(test,train)
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

[P, N] = size(train);

if N > 1
    test = test(:);
    train = train(:);
end

%% Extract Statitistics
M = length(train);
K = length(train{1}.accuracy);

% For Training Data
stats.train.acc.mean = zeros(1,K);
stats.train.acc.std  = zeros(1,K);

stats.train.fmeasure.mean = zeros(1,K);
stats.train.fmeasure.std  = zeros(1,K);

stats.train.fpr.mean = zeros(1,K);
stats.train.fpr.std  = zeros(1,K);

stats.train.tnr.mean = zeros(1,K);
stats.train.tnr.std  = zeros(1,K);

% bla bli
% Model Statistics for SVM
stats.model.totSV.mean   = zeros(1,K);
stats.model.totSV.std    = zeros(1,K);

stats.model.ratioSV.mean = zeros(1,K);
stats.model.ratioSV.std  = zeros(1,K);

stats.model.posSV.mean   = zeros(1,K);
stats.model.posSV.std    = zeros(1,K);

stats.model.negSV.mean   = zeros(1,K);
stats.model.negSV.std    = zeros(1,K);

stats.model.boundSV.mean = zeros(1,K);
stats.model.boundSV.std  = zeros(1,K);

% For Testing Data
if ~isempty(test)
    stats.test.acc.mean = zeros(1,K);
    stats.test.acc.std  = zeros(1,K);
    
    stats.test.fmeasure.mean = zeros(1,K);
    stats.test.fmeasure.std  = zeros(1,K);
    
    stats.test.fpr.mean = zeros(1,K);
    stats.test.fpr.std  = zeros(1,K);
    
    stats.test.tnr.mean = zeros(1,K);
    stats.test.tnr.std  = zeros(1,K);
end

for m=1:M
    
    % For Testing Data
    if ~isempty(test)
        stats.test.acc.mean(m)      = mean(test{m}.accuracy);
        stats.test.acc.std(m)       = std(test{m}.accuracy);
        
        stats.test.fmeasure.mean(m) = mean(test{m}.fmeasure);
        stats.test.fmeasure.std(m)  = std(test{m}.fmeasure);
        
        stats.test.fpr.mean(m)      = mean(test{m}.fpr);
        stats.test.fpr.std(m)       = std(test{m}.fpr);
        
        stats.test.tnr.mean(m)      = mean(test{m}.tnr);
        stats.test.tnr.std(m)       = std(test{m}.tnr);
    end
    
    % For Training Data
    stats.train.acc.mean(m)      = mean(train{m}.accuracy);
    stats.train.acc.std(m)       = std(train{m}.accuracy);
    
    stats.train.fmeasure.mean(m) = mean(train{m}.fmeasure);
    stats.train.fmeasure.std(m)  = std(train{m}.fmeasure);
    
    stats.train.fpr.mean(m)      = mean(train{m}.fpr);
    stats.train.fpr.std(m)       = std(train{m}.fpr);
    
    stats.train.tnr.mean(m)      = mean(train{m}.tnr);
    stats.train.tnr.std(m)       = std(train{m}.tnr);
    
    
    % Model Statistics for SVM
    stats.model.totSV.mean(m)   = mean(train{m}.totSV);
    stats.model.totSV.std(m)    = std(train{m}.totSV);
    
    stats.model.ratioSV.mean(m) = mean(train{m}.ratioSV);
    stats.model.ratioSV.std(m)  = std(train{m}.ratioSV);
    
    stats.model.posSV.mean(m)   = mean(train{m}.posSV);
    stats.model.posSV.std(m)    = std(train{m}.posSV);
    
    stats.model.negSV.mean(m)   = mean(train{m}.negSV);
    stats.model.negSV.std(m)    = std(train{m}.negSV);
    
    stats.model.boundSV.mean(m) = mean(train{m}.boundSV);
    stats.model.boundSV.std(m)  = std(train{m}.boundSV);
    
    
end


%% Reshape stats if grid search on > 1 parameters
if N > 1
    % For Testing Data
    if ~isempty(test)
        stats.test.acc.mean = reshape(stats.test.acc.mean, P, N);
        stats.test.acc.std  = reshape(stats.test.acc.std, P, N);
        
        stats.test.fmeasure.mean = reshape(stats.test.fmeasure.mean, P, N);
        stats.test.fmeasure.std  = reshape(stats.test.fmeasure.std, P, N);
        
        stats.test.fpr.mean = reshape(stats.test.fpr.mean, P, N);
        stats.test.fpr.std  = reshape(stats.test.fpr.std, P, N);
        
        stats.test.tnr.mean = reshape(stats.test.tnr.mean, P, N);
        stats.test.tnr.std  = reshape(stats.test.tnr.std, P, N);
        
    end
    
    % For Training Data
    stats.train.acc.mean = reshape(stats.train.acc.mean, P, N);
    stats.train.acc.std  = reshape(stats.train.acc.std, P, N);

    stats.train.fmeasure.mean = reshape(stats.train.fmeasure.mean, P, N);
    stats.train.fmeasure.std  = reshape(stats.train.fmeasure.std, P, N);
    
    stats.train.fpr.mean = reshape(stats.train.fpr.mean, P, N);
    stats.train.fpr.std  = reshape(stats.train.fpr.std, P, N);
    
    stats.train.tnr.mean = reshape(stats.train.tnr.mean, P, N);
    stats.train.tnr.std  = reshape(stats.train.tnr.std, P, N);
    
    % For model Statistics 
    stats.model.totSV.mean   = reshape(stats.model.totSV.mean, P, N);
    stats.model.totSV.std    = reshape(stats.model.totSV.std, P, N);
    
    stats.model.ratioSV.mean = reshape(stats.model.ratioSV.mean, P, N);
    stats.model.ratioSV.std  = reshape(stats.model.ratioSV.std, P, N);
    
    stats.model.posSV.mean   = reshape(stats.model.posSV.mean, P, N);
    stats.model.posSV.std    = reshape(stats.model.posSV.std, P, N);
    
    stats.model.negSV.mean   = reshape(stats.model.negSV.mean, P, N);
    stats.model.negSV.std    = reshape(stats.model.negSV.std, P, N);
    
    stats.model.boundSV.mean = reshape(stats.model.boundSV.mean, P, N);
    stats.model.boundSV.std  = reshape(stats.model.boundSV.std, P, N);
        
end


end

