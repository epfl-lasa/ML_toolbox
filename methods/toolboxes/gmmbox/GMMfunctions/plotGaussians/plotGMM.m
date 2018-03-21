function plotGMM(Mu, Sigma, color, display_mode);
%
% This function plots a representation of the components (means and 
% covariance amtrices) of a Gaussian Mixture Model (GMM) or a
% Gaussian Mixture Regression (GMR).
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Mu:           D x K array representing the centers of the K GMM components.
%   o Sigma:        D x D x K array representing the covariance matrices of the 
%                   K GMM components.
%   o color:        Color used for the representation
%   o display_mode: Display mode (1 is used for a GMM, 2 is used for a GMR
%                   with a 2D representation and 3 is used for a GMR with a
%                   1D representation).

nbData = size(Mu,2);
lightcolor = color + [0.6,0.6,0.6];
lightcolor(find(lightcolor>1.0)) = 1.0;

if display_mode==1
  nbDrawingSeg = 40;
  t = linspace(-pi, pi, nbDrawingSeg)';
  for j=1:nbData
    stdev = sqrtm(3.0.*Sigma(:,:,j));
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    patch(X(:,1), X(:,2), lightcolor, 'lineWidth', 2, 'EdgeColor', color);
    plot(Mu(1,:), Mu(2,:), 'x', 'lineWidth', 2, 'color', color);
  end
elseif display_mode==2
  nbDrawingSeg = 40;
  t = linspace(-pi, pi, nbDrawingSeg)';
  for j=1:nbData
    stdev = sqrtm(3.0.*Sigma(:,:,j));
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    patch(X(:,1), X(:,2), lightcolor, 'LineStyle', 'none');
  end
  plot(Mu(1,:), Mu(2,:), '-', 'lineWidth', 3, 'color', color);
elseif display_mode==3
  for j=1:nbData
    ymax(j) = Mu(2,j) + sqrtm(3.*Sigma(1,1,j));
    ymin(j) = Mu(2,j) - sqrtm(3.*Sigma(1,1,j));
  end
  patch([Mu(1,1:end) Mu(1,end:-1:1)], [ymax(1:end) ymin(end:-1:1)], lightcolor, 'LineStyle', 'none');
  plot(Mu(1,:), Mu(2,:), '-', 'lineWidth', 3, 'color', color); 
end





