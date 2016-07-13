% KM_DEMO_PCA Principal component analysis on a simple two-dimensional
% data set. The first principal component is retrieved and plotted,
% together with both principal directions.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear

%% PARAMETERS

N = 500;			% number of data points
R = [-.9 .4; .1 .2];	% covariance matrix

%% PROGRAM
tic

X = randn(N,2)*R;	% correlated two-dimensional data

[E,v,Xp] = km_pca(X,1);		% obtain eigenvector matrix E, eigenvalues v and principal components Xp

toc
%% OUTPUT

figure; hold on
plot(X(:,1),X(:,2),'.')
plot(E(1,1)*Xp,E(2,1)*Xp,'.r')
plot([0 E(1,1)],[0 E(2,1)],'g','LineWidth',4)
plot([0 E(1,2)],[0 E(2,2)],'k','LineWidth',4)
axis equal
legend('data','first principal components','first principal direction','second principal direction')
title('linear PCA demo')
