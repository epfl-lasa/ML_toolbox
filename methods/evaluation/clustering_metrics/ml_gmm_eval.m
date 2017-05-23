function [] =  ml_gmm_eval(X, K_range, repeats, cov_type)
%GMM_EVAL Implementation of the GMM Model Fitting with AIC/BIC metrics.
%
%   input -----------------------------------------------------------------
%   
%       o X        : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o repeats  : (1 X 1), # times to repeat k-means
%       o K_range  : (1 X K), Range of k-values to evaluate
%
%   output ----------------------------------------------------------------
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


AIC_mean = zeros(1, length(K_range));
BIC_mean = zeros(1, length(K_range));
AIC_std = zeros(1, length(K_range));
BIC_std = zeros(1, length(K_range));
plot_iter = 0;  

% Populate Curves
for i=1:length(K_range)
    
    % Select K from K_range
    K = K_range(i); 
    
    % Repeat GMM X times
    AIC_ = zeros(1, repeats); BIC_= zeros(1, repeats);     
            
    for ii = 1:repeats        
        fprintf('Iteration %d of K=%d\n',ii,i);
        
        % Estimate 
        [Priors, Mu, Sigma] = ml_gmmEM(X, K);                
        
        % Compute GMM Likelihood
        [ ll ] = ml_LogLikelihood_gmm(X, Priors, Mu, Sigma);
        if isnan(ll)
            Mu 
            Priors
            Sigma
            error('Shitty estimation');            
        end
        
        % Compute metrics from implemented function
        AIC_(ii) =  ml_gmm_aic(X, Priors, Mu, Sigma, cov_type);
        BIC_(ii) =  ml_gmm_bic(X, Priors, Mu, Sigma, cov_type);
    end 
    
    % Get the max of those X repeats
    AIC_mean(i) = mean (AIC_); AIC_std(i) = std (AIC_);
    BIC_mean(i) = mean (BIC_); BIC_std(i)= std (BIC_);
    
end

% Plot Metric Curves
figure('Color',[1 1 1]);
errorbar(K_range',AIC_mean(K_range)', AIC_std(K_range)','--or','LineWidth',2); hold on;
errorbar(K_range',BIC_mean(K_range)', BIC_std(K_range)','--ob','LineWidth',2);
grid on
xlabel('Number of K components','Interpreter','LaTex','FontSize',10); ylabel('AIC/BIC Score','Interpreter','LaTex','FontSize',10)
title('Model Selection for Gaussian Mixture Model','Interpreter','LaTex','FontSize',20)
legend('AIC', 'BIC')


end