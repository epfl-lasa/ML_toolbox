function v = ml_get_isolines(xtest,xtrain,alpha,kernel,kpar)
%ML_GET_ISOLINES: Plot the isolines of a kernel method.
%
%   input ---------------------------------------------------------------
%
%       o xtest       : (N x P), dataset of N samples of dimension P
%   
%       o xtrain      : (M x P), original training data points
%
%       o alpha       : (M x 1), eigenvector of dimension M
%
%       o kernel      : string, the type of kernel
%                               [gauss,diag-gauss,poly,linear].
%
%       o kpar        : sig = kpar(1);  % variance for the gauss kernels.
%                       p   = kpar(1);	% polynome order
%                       c   = kpar(2);	% additive constant
%   
%   output ----------------------------------------------------------------
%
%       o v           : value when projected onto the eigenvetors alpha
%
%   comment ---------------------------------------------------------------
%
%       Each data point of xtest is projected onto every alpha eigenvector.
%       Usually xtest will be (N x 2) since we are using this function for 
%       plotting. The dim input is for the dimensions of the xtrain we want
%       to use in conjunction with xtest points. Basically both xtest 
%       and xtrain should be of the same dimension.
%   

N = size(xtest,1);
v = zeros(N,1);

if(strcmp(kernel,'poly') == true)
   kpar_ = [kpar(2) kpar(1)];
   kpar  = kpar_;
end

for i=1:N    
    % Compute gramm matrix between test point i and all train points
    K_i  = km_kernel(xtest(i,:),xtrain,kernel,kpar);
    v(i) = alpha(:,1)' * K_i(:);
    
end


end

