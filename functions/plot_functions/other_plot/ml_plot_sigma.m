function ml_plot_sigma(gmm, colors, scale)
%ML_PLOT_SIGMA 
%
%   input -----------------------------------------------------------------
%
%       o axes      : axes handle, gca.
%
%       o gmm       : (D x D x N), set of N centroids of dimension D = [2]
%
%       o colors    : (N x 3), set of class colors 
%
%       o scale     : scaling for sigmas
%

[D,K]   = size(gmm.Mu);

if ~exist('colors','var')
   colors = hsv(size(C,1)); 
end

hold on;
for k=1:K

    if D == 2
            h = plot_gaussian_ellipsoid(gmm.Mu(:,k), gmm.Sigma(:,:,k)*scale);
            set(h,'EdgeColor',colors(k,:));     
            hold on;
    elseif D == 3
        % TODO
    end        
end
hold off;

end

