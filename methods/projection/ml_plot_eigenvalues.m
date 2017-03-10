function [handle] = ml_plot_eigenvalues( L )
%PLOT_EIGENVALUES Simple plotting function to visualize eigenvalues
%   The student should convert the Eigenvalue matrix to a vector and 
%   visualize the values as a 2D plot.
%   input -----------------------------------------------------------------
%   
%       o L      : (N x N), Diagonal Matrix composed of lambda_i 
%                           

lambda = diag(L)';

handle = figure;
plot(lambda, '--b', 'LineWidth', 2)
set(gca,'XTick',[1:1:length(lambda)])
title('Eigenvalues')
ylabel('Eigenvalues')
xlabel('Eigenvector index')
grid on

end

