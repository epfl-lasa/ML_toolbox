function bic = ml_bic(ll,num_para,num_data)
%ML_BIC  Bayesian information criterion 
%
%   input -----------------------------------------------------------------
%
%       o ll        : (1 x 1), log-likelihood.
%
%       o num_para  : (1 x 1), number of parameters.
%
%       o num_data  : (1 x 1), number of datapoints.
%
%   output ----------------------------------------------------------------
%
%       o bic       : (1 x 1)

 bic =  -2 * ll + num_para * log(num_data);


end

