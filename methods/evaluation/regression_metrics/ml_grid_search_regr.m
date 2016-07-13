function [ ctest, ctrain, ranges ] = ml_grid_search_regr( X, y, Kfold,parameters,step,ml_function)
%ML_GRID_SEARCH_CLASS DO grid_search for regression

% parameters is 1x3 vector with limits (start, end) and step

% ml_function : if size 2, SVR (type, kernel) | if size 1, GPR

nbParameters = size(parameters,1);
ranges = cell(nbParameters,1);

for i = 1:nbParameters
    ranges{i} = linspace(parameters(i,1), parameters(i,2), step);    
end

steps = allcomb(ranges{1:end});

ctest  = cell(size(steps,1),1);
ctrain = cell(size(steps,1),1);

for i=1:size(steps,1)
     switch ml_function{1}   
        case 'GPR'
            f                       = @(X,y,model)ml_gpr(X,y,model,steps(i,1),steps(i,2));
            [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
         case '0' % epsilon-SVR 
            svr_options.svr_type = 0;
            svr_options.C        = steps(i,1);
            svr_options.epsilon  = steps(i,2);
            switch ml_function{2}
                case 0
                    svr_options.kernel_type = 0;
                case 1
                    svr_options.kernel_type = 1;
                    svr_options.degree      = steps(i,3);
                    svr_options.coeff       = steps(i,4);
                case 2
                    svr_options.kernel_type = 2;
                    svr_options.sigma       = steps(i,3);
            end
            f                       = @(X,y,model)svm_regressor(X,y,svr_options,model);
            [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
         case '1' %nu-SVR
            svr_options.svr_type = 1;
            svr_options.C        = steps(i,1);
            svr_options.nu       = steps(i,2);
            switch ml_function{2}
                case 0
                    svr_options.kernel_type = 0;
                case 1
                    svr_options.kernel_type = 1;
                    svr_options.degree      = steps(i,3);
                    svr_options.coeff       = steps(i,4);
                case 2
                    svr_options.kernel_type = 2;
                    svr_options.sigma       = steps(i,3);
            end
            f                       = @(X,y,model)svm_regressor(X,y,svr_options,model);
            [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
    end

    ctest{i}  = test_eval;
    ctrain{i} = train_eval;
    
end

reshapeSize = step*ones(1,nbParameters);

ctest = reshape(ctest,reshapeSize);
ctest = permute(ctest,nbParameters:-1:1);
ctrain = reshape(ctrain,reshapeSize);
ctrain = permute(ctrain,nbParameters:-1:1);

end

