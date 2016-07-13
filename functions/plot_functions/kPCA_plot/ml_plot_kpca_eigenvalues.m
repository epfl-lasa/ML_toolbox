function [ handle ] = ml_plot_kpca_eigenvalues(eigenvalues,kpars)
%ML_PLOT_KEIGENVALUES Helper function to plot the eigenvalues which came
%from running a kernel manifold method in batch mode]
%
%   input -----------------------------------------------------------------
%
%       o eigenvalues : (N x L) : N is the number of different paramters
%                                 you chose. L is the number of
%                                 eigenvalues.
%
%       o kpars        : (N x 1) : values of the parameters.
%
%   output ----------------------------------------------------------------
%
%       o handle       : figure handle
%
%




handle = figure; 
hold on;

[num_para,num_eigval] = size(eigenvalues);
colors                = flipud(jet(num_para));

for i=1:num_para
   plot(eigenvalues(i,:),'-o','Color',colors(i,:),'MarkerFaceColor',colors(i,:));
end
box on; grid on;
set(gca,'FontSize',14);
xlabel('Indices of eigenvectors');
ylabel('Eigenvalues');
legend(strread(num2str(kpars),'%s'));

end

