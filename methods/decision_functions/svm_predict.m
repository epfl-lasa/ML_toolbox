function [predict_label, accuracy, dec_values] = svm_predict(data, labels, model)
% SVM_CLASSIFIER_PREDICTS % Predicts labels and computes accuracy for new
% data with a learnt SVM model
%   input ----------------------------------------------------------------
%
%       o data             : (N x D), N data points of D dimensionality.
%
%       o labels           : (N x 1), Either 1, -1 for binary
%
%       o model            : struct
%
%
%   output ----------------------------------------------------------------
%
%       o predict_label   : (N x 1), predicted labels
%
%       o accuracy        : (3 x 1), classification accuracy (1,1)
%
%       o dec_values      : (N x 1), values from the decision function f(x)
%
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

%% Predict labels given model and data

if isempty(labels)
    labels = ones(length(data),1);
end

% [predict_label, accuracy, dec_values] = svmpredict(labels, sparse(data), model);

% Need to use evalc here to suppress LIBSVM accuracy printouts
[T,predict_label, accuracy, dec_values] = evalc('svmpredict(labels, sparse(data), model)');

end