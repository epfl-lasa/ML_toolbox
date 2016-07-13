function [ X ] = ml_scholkopf_data( num_samples )
%ML_SCHOLKOPF_DATA 
%
%   Nonlinear Component Analysis as a Kernel Eigenvalue problem
%   Data from Figure 2
%
%   input -----------------------------------------------------------------
%
%       o num_samples : (1 x 1), the number of samples to be generated.
%
%   output-----------------------------------------------------------------
%
%       o X           : (num_samples x 2), data
%
%
%   Comment --------------------------------------------------------------
%
%       x values have a uniform distribution in [-1,1]
%       y values from y = x.^2 + \epsilon  , where epsilon gaussion 0 mean
%       with standard deviation 0.2
%
%

X(:,1) = rand_r(-1,1,num_samples);
X(:,2) = X(:,1).^2 + mvnrnd(0,0.2*0.2,num_samples);

end


function x = rand_r(a,b,num_samples)
    x = a + (b-a) * rand(num_samples,1);
end
