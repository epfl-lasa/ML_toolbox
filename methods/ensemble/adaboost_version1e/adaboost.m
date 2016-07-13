function [estimateclasstotal,model,D]=adaboost(mode,X,labels,model,itt,weak_type)
% This function AdaBoost, consist of two parts a simpel weak classifier and
% a boosting part:
% The weak classifier tries to find the best treshold in one of the data
% dimensions to sepparate the data into two classes -1 and 1
% The boosting part calls the clasifier iteratively, after every classification
% step it changes the weights of miss-classified examples. This creates a
% cascade of "weak classifiers" which behaves like a "strong classifier"
%
%
%   input -----------------------------------------------------------------
%
%       o mode   : string,  'train' or 'apply'.
%
%       o X      : (N x D), dataset of N samples of dimension D.
%
%       o labels : (N x 1), class labels {-1,+1}
%
%       o model  : struct of model learned, set ot [] when training.
%
%       o itt    :  number of iterations to perform which is equivalent to
%                   the number of resulting weak classifiers.
%
%       o weak_type : string, weak classifier type:
%
%               - decision_stump : splits space along the dimension
%
%   output ----------------------------------------------------------------
%
%  inputs/outputs:
%    datafeatures : An Array with size number_samples x number_features
%    dataclass : An array with the class off all examples, the class
%                 can be -1 or 1
%    itt : The number of training itterations
%    model : A struct with the cascade of weak-classifiers
%    estimateclass : The by the adaboost model classified data
%

if ~exist('weak_type','var'), weak_type = 'decision_stump'; end


switch(mode)
    case 'train'
        % Train the adaboost model
        
        % Set the data class labels
        labels    = labels(:);
        model     = struct;
        
        % Weight of training samples, first every sample is even important
        % (same weight)
        D=ones(length(labels),1)/length(labels);
        
        % This variable will contain the results of the single weak
        % classifiers weight by their alpha
        predict_label   =   zeros(size(labels));
        
        % Calculate max min of the data
        boundary=[min(X,[],1) max(X,[],1)];
        % Do all model training itterations
        for t=1:itt
            % Find the best treshold to separate the data in two classes
            
            if strcmpi(weak_type,'decision_stump')
                
                [estimateclass,err,h] = WeightedThresholdClassifier(X,labels,D);
                
            elseif strcmpi(weak_type,'linear')
                
                [B_hat,mapping] = train_linear_classifier(X,labels,D);
                [estimateclass] = predictor_linear_classifier(X,B_hat,mapping);
                err             = sum(D(:) .* (estimateclass ~= labels));
            end
    
            
            % Weak classifier influence on total result is based on the current
            % classification error
            alpha=1/2 * log((1-err)/max(err,eps));
            
            
            % Store the model parameters
            model(t).alpha      = alpha;
            
            if strcmpi(weak_type,'decision_stump')
                model(t).dimension  = h.dimension;
                model(t).threshold  = h.threshold;
                model(t).direction  = h.direction;
                model(t).boundary   = boundary;
            elseif strcmpi(weak_type,'linear')
                model(t).B_hat   = B_hat;
                model(t).mapping = mapping;
            end
            
            
            % We update D so that wrongly classified samples will have more weight
            D = D.* exp(-model(t).alpha.*labels.*estimateclass);
            D = D./sum(D);
            
            % Calculate the current error of the cascade of weak
            % classifiers
            predict_label       =   predict_label + estimateclass * model(t).alpha;
            estimateclasstotal  =   sign(predict_label);
            
            model(t).error      =   sum(estimateclasstotal~=labels)/length(labels);
            
            if(model(t).error==0), break; end
            
        end
        
    case 'apply'
        % Apply Model on the test data
        
        if strcmpi(weak_type,'decision_stump')
            
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
            % If the total sum of all weak classifiers
            % is less than zero it is probablly class -1 otherwise class 1;
        elseif strcmpi(weak_type,'linear')
            
            predict_label = zeros(size(X,1),1);
            
            for t=1:length(model);
                estimateclass = predictor_linear_classifier(X,model(t).B_hat,model(t).mapping);
                predict_label = predict_label + model(t).alpha * estimateclass;
            end
            
        end

        estimateclasstotal = sign(predict_label);
        
    otherwise
        error('adaboost:inputs','unknown mode');
end




