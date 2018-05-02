function [model] = svm_train(data, labels, options)
% SVM_TRAIN Trains an SVM Model using LIBSVM
%
%   input ----------------------------------------------------------------
%
%       o data        : (N x D), N data points of D dimensionality.
%
%       o labels      : (N x 1), Either 1, -1 for binary
%
%       o options     : struct
%
%
%   output ----------------------------------------------------------------
%
%       o model       : struct.
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
svm_type    = options.svm_type;
if isfield(options,'kernel_type')
    kernel_type = options.kernel_type;
else
    kernel_type = 0;
end
C = 0; nu = 0; sigma = 0; d = 1; coeff = 0;

switch kernel_type 
    case 0 % gauss
        gamma = 1 / (2*options.sigma^2);
    case 1 % poly
        degree = options.degree;
        coeff  = options.coeff;
end

switch svm_type
    case 0        
        C     = options.C;    
        
        switch kernel_type  
            case 0  % gauss              
                options = strcat({'-s 0 -t 2 -g '}, {''}, {num2str(gamma)},{' -h 0 -c '}, {''}, {num2str(C)});        
            case 1  % poly
                options = strcat({'-s 0 -t 1 -d '}, {''}, {num2str(degree)},{' -h 0 -r '}, {''}, {num2str(coeff)}, {' -c '}, {''},{num2str(C)})        ;
        end
        
    case 1        
        nu     = options.nu;                
        switch kernel_type 
            case 0  % gauss              
                options = strcat({'-s 1 -t 2 -g '}, {''}, {num2str(gamma)},{' -h 0 -n '}, {''}, {num2str(nu)});     
            case 1  % poly
                options = strcat({'-s 1 -t 1 -d '}, {''}, {num2str(degree)},{' -h 0 -r '}, {''}, {num2str(coeff)}, {' -n '},{''}, {num2str(nu)}) ;       
        end
        
end
options = options{1};

%% Train SVM Model
model = libsvmtrain(labels, sparse(data), options);

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