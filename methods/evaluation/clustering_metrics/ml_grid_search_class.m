function [ ctest, ctrain, cranges ] = ml_grid_search_class( X, labels, options )
%ML_GRID_SEARCH_CLASS DO grid_search for classification
%   Detailed explanation goes here

% At the moment only working for SVM 2-parameter grid search

% Store results
ctest  = cell(options.steps,1);
ctrain = cell(options.steps,1);

% Check if Parameter Ranges Should in in linearly or log spaced
log_grid = 0;
if isfield(options,'log_grid')
   if (options.log_grid == 1)
       log_grid = 1;
   end
end

if isfield(options,'model_type')
    model_type = option.model_type;
else
    model_type = 'svm';
end


switch options.svm_type
    case 0       
        if log_grid
            range_p1 = logspace(log10(options.limits_C(1)),log10(options.limits_C(2)),options.steps);
        else
            range_p1 = linspace(options.limits_C(1), options.limits_C(2), options.steps);
        end
    case 1
        if log_grid
            range_p1 = logspace(log10(options.limits_nu(1)), log10(options.limits_nu(2)), options.steps);
        else
            range_p1 = linspace(options.limits_nu(1), options.limits_nu(2), options.steps);
        end
end


if isfield(options,'kernel_type')
    kernel_type = options.kernel_type;
else
    kernel_type = 0;
end


switch kernel_type
    case 0 
        if log_grid
            range_p2 = logspace(log10(options.limits_w(1)), log10(options.limits_w(2)), options.steps);
        else            
            range_p2 = linspace(options.limits_w(1), options.limits_w(2), options.steps);
        end
    case 1
        if log_grid
            range_p2 = logspace(log10(options.limits_d(1)), log10(options.limits_d(2)), options.steps);
        else            
            range_p2 = linspace(options.limits_d(1), options.limits_d(2), options.steps);
        end
end


for i=1:length(range_p1)
    for j=1:length(range_p2)
        
        disp([num2str(i) '/' num2str(length(range_p1)) ,',', num2str(j) '/' num2str(length(range_p2)) ]);
        
       switch kernel_type
            case 0 
                options.sigma    = range_p2(j); 
                fprintf('with sigma: %f \n', options.sigma);
            case 1
                options.degree   = range_p2(j);
                fprintf('with p: %f \n', options.degree);
        end
         
        switch options.svm_type
            case 0
                options.C     = range_p1(i);
                fprintf('Evaluating Param C: %f ', options.C);
                f = @(X,labels,model)svm_classifier(X, labels, options, model);                
                [test_eval,train_eval] = ml_kcv(X,labels,options.K,f,'classification',options.C, model_type);
            case 1
                options.nu    = range_p1(i);
                fprintf('Evaluating Param $\nu$: %f ', options.nu);
                f = @(X,labels,model)svm_classifier(X, labels, options, model);                
                [test_eval,train_eval] = ml_kcv(X,labels,options.K,f,'classification');
        end                         
        
        ctest{i,j}  = test_eval;
        ctrain{i,j} = train_eval;
    end
end

cranges = [range_p1;range_p2];

end

