function [model] = svr_train(y, X, svr_options)
% SVM_TRAIN Trains an SVM Model using LIBSVM
%
%   input ----------------------------------------------------------------
%
%       o y               : (N x 1), number of output datapoints.
%
%       o X               : (N x D), number of input datapoints.
%
%       o svr_options     : struct
%
%
%   output ----------------------------------------------------------------
%
%       o model           : struct.
%
%

%% LIBSVM OPTIONS
% options:
% -s svm_type : set type of SVM (default 0)
% 	0 -- C-SVC
% 	1 -- nu-SVC
% 	2 -- one-class SVM
% 	3 -- epsilon-SVR
% 	4 -- nu-SVR
% -t kernel_type : set type of kernel function (default 2)
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% -d degree : set degree in kernel function (default 3)
% -g gamma : set gamma in kernel function (default 1/num_features)
% -r coef0 : set coef0 in kernel function (default 0)
% -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
% -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
% -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
% -m cachesize : set cache memory size in MB (default 100)
% -e epsilon : set tolerance of termination criterion (default 0.001)
% -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
% -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
% -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
%
%% Parse SVM Options
% Parsing Parameter Options for SVM variants
switch svr_options.svr_type
    
    case 0 % epsilon-SVR

        switch svr_options.kernel_type
            case 0 % linear
                options = strcat({'-s 3 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -c '}, {''}, {num2str(svr_options.C)},{' -h 0 -p '}, {''}, {num2str(svr_options.epsilon)});
            case 1 % poly
                options = strcat({'-s 3 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -d '}, {''}, {num2str(svr_options.degree)},{' -r '}, {''}, {num2str(svr_options.coeff)}, {' -c '}, {''},{num2str(svr_options.C)},{' -h 0 -g 1 -p '}, {''}, {num2str(svr_options.epsilon)});
            case 2 % gauss
                svr_options.gamma = 1 / (2*svr_options.sigma^2);
                options = strcat({'-s 3 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -c '}, {''}, {num2str(svr_options.C)},{' -g '}, {''}, {num2str(svr_options.gamma)},{' -h 0 -p '}, {''}, {num2str(svr_options.epsilon)});
        end
        
    case 1 % nu-SVR
   
        switch svr_options.kernel_type
            case 0 % linear
                options = strcat({'-s 4 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -n '}, {''}, {num2str(svr_options.nu)},{' -h 0 -c '}, {''}, {num2str(svr_options.C)});
            case 1 % gauss
                options = strcat({'-s 4 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -d '}, {''}, {num2str(svr_options.degree)},{' -r '}, {''}, {num2str(svr_options.coeff)}, {' -n '}, {''},{num2str(svr_options.nu)},{' -h 0 -g 1 -c '}, {''}, {num2str(svr_options.C)});
            case 2 % poly
                svr_options.gamma = 1 / (2*svr_options.sigma^2);
                options = strcat({'-s 4 '}, {'-t '}, {''}, {num2str(svr_options.kernel_type)},{' -n '}, {''}, {num2str(svr_options.nu)},{' -g '}, {''}, {num2str(svr_options.gamma)},{' -h 0 -c '}, {''}, {num2str(svr_options.C)});
        end
end
        
options = options{1};


%% Train SVM Model
model = svmtrain(y, X, options);

%% The LIBSVM Model struct will contain the following parameters
% -Parameters: parameters
% -nr_class: number of classes; = 2 for regression/one-class svm
% -totalSV: total #SV
% -rho: -b of the decision function(s) wx+b
% -Label: label of each class; empty for regression/one-class SVM
% -sv_indices: values in [1,...,num_traning_data] to indicate SVs in the training set
% -ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
% -ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
% -nSV: number of SVs for each class; empty for regression/one-class SVM
% -sv_coef: coefficients for SVs in decision functions
% -SVs: support vectors

end