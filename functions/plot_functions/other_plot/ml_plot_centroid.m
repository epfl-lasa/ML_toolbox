function ml_plot_centroid(C,colors)
%ML_PLOT_CENTROID 
%
%   input -----------------------------------------------------------------
%
%       o axes      : axes handle, gca.
%
%       o C         : (N x D), set of N centroids of dimension D = [1,2,3]
%
%       o colors    : (N x 3), set of class colors 
%
%

[N,D]   = size(C);

if ~exist('colors','var')
   colors = hsv(size(C,1)); 
end

hold on;
for n=1:N

    if D == 2
        scatter(C(n,1),C(n,2),200,colors(n,:),'filled','MarkerEdgeColor',[0 0 0]);
        scatter(C(n,1),C(n,2),50,[0 0 0],'filled','MarkerFaceColor',[0 0 0]);
    elseif D == 3
        scatter3(C(n,1),C(n,2),C(n,3),200,colors(n,:),'filled','MarkerEdgeColor',[0 0 0]);
        scatter3(C(n,1),C(n,2),C(n,3),50,[0 0 0],'filled','MarkerFaceColor',[0 0 0]);
    end        
end
hold off;

end

