function [ ctest, ctrain, cranges ] = ml_grid_search_class( X, labels, options )
%ML_GRID_SEARCH_CLASS DO grid_search for classification
%   Detailed explanation goes here

% At the moment only working for SVM 2-parameter grid search

% Store results
ctest  = cell(options.K,1);
ctrain = cell(options.K,1);

switch options.svm_type
    case 0
        range_p1 = linspace(options.limits_C(1), options.limits_C(2), options.steps);
    case 1
        range_p1 = linspace(options.limits_nu(1), options.limits_nu(2), options.steps);
end


if isfield(options,'kernel_type')
    kernel_type = options.kernel_type;
else
    kernel_type = 0;
end


switch kernel_type
    case 0 
         range_p2 = linspace(options.limits_w(1), options.limits_w(2), options.steps);
    case 1
         range_p2 = linspace(options.limits_d(1), options.limits_d(2), options.steps);
end

for i=1:length(range_p1)
    for j=1:length(range_p2)
        
        disp([num2str(i) '/' num2str(length(range_p1)) ,',', num2str(j) '/' num2str(length(range_p2)) ]);
         
        switch options.svm_type
            case 0
                options.C       = range_p1(i);
            case 1
                options.nu       = range_p1(i);
        end       
        
        switch kernel_type
            case 0 
                options.sigma    = range_p2(j); 
            case 1
                options.degree   = range_p2(j);
        end
        

        f = @(X,labels,model)svm_classifier(X, labels, options, model);        
        [test_eval,train_eval] = ml_kcv(X,labels,options.K,f,'classification',options.C);
        
        ctest{i,j}  = test_eval;
        ctrain{i,j} = train_eval;
    end
end

cranges = [range_p1;range_p2];

end

