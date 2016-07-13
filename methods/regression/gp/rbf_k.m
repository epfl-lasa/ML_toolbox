function K = rbf_k(i,j,X,rbf_var)
%RBF_K Radial Basis function Kernel 
%
%   input -----------------------------------------------------------------
%
%       o i: (N^2 x 1) 
%
%       o j: (N^2 x 1)   
%
%       o X: (D x N)
%
%       o Var: (1 x 1)
%



N = size(X,2);

    % (1 x N^2)
    % (D x N^2) - (D x N^2))
    
% r = sqrt( sum( ( X(:,i) - X(:,j) ).^2 ,1)  );

%K = zeros(N,N);
%beta

% for i=1:N
%     x_i = X(i);
%     for j=1:N
%         x_j = X(j);
%         K(i,j) = exp(- beta .* norm(x_i - x_j)^2);
%     end
% end

%r = sqrt( sum( ( X(:,i) - X(:,j) ).^2 ,1)  );


beta =  1/(2*rbf_var);
   
K = exp(- beta .* sum( ( X(:,i) - X(:,j) ).^2 ,1)  );
K = reshape(K,N,N);



end


