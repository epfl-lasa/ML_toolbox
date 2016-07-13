function v = kernel_isolines(Xtest,X,alpha,ktype,kpar)
%KERNEL_ISOLINES Summary of this function goes here
%
%
%   input -----------------------------------------------------------------
%
%       o  Xtest : (N x D), N test points of dimension D
%
%       o      X : (M x D), M parameters of dimension D
%
%       o  alpha : (M x 1), M dimensional eigenvector
%
%       o  ktype : string , ['gauss', 'gauss-diag', 'poly','linear']
%
%   output ----------------------------------------------------------------
%
%       o v       : (M x 1), values of projecting points onto eigenvector 
%                            alpha
%



N = size(Xtest,1);
v = zeros(N,1);

for i=1:N
    % (1 x M)
    K_i  = km_kernel(Xtest(i,:),X,ktype,kpar);
    v(i) = alpha' * K_i(:);
end


end
