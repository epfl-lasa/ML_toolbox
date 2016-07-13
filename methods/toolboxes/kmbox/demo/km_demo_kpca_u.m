% KM_DEMO_KPCA_U Kernel principal component analysis (KPCA) on a U-shaped
% two-dimensional data set. 
%
% This program implements the example shown in Figure 2.4 of "Kernel
% Methods for Nonlinear Identification, Equalization and Separation of
% Signals", Ph.D. dissertation by S. Van Vaerenbergh.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear

%% PARAMETERS

N_split = [30, 30, 60];		% number of data points in 2 straight parts and curve of "U"
corners = [3 4 2 4];	% corners: x1 x2 y1 y2
nvar = 0.05;	% noise variance

kernel.type = 'gauss';
kernel.par =  .5;
numeig = 4;	% number of eigenvalues to plot

Ntest = [50,50];	% number of test grid divisions, in each dimension
border = [0 6 0 6];	% test grid border
 
%% PROGRAM
tic

%% generate data
N = sum(N_split);
N1 = N_split(1); N2 = N_split(2); N3 = N_split(3);

X1 = [linspace(corners(1),corners(2),N1)' repmat(corners(3),N1,1)];	% lower straight part
X2 = [linspace(corners(1),corners(2),N2)' repmat(corners(4),N2,1)];	% upper straight part

angles = linspace(pi/2,3*pi/2,N3)';
rad = (corners(4)-corners(3))/2;
m3 = [corners(1) corners(3)+rad];
X3 = repmat(m3,N3,1) + rad*[cos(angles) sin(angles)];

n = nvar*randn(N,2);
X = [X1; X2; X3] + n;

%% generate test grid data
Nt1 = Ntest(1); Nt2 = Ntest(2);
Xtest = zeros(Nt1*Nt2,2);
absc = linspace(border(1),border(2),Nt1);
ordi = linspace(border(3),border(4),Nt2);
for i=1:Nt1,
	for j=1:Nt2,
		Xtest((i-1)*Nt2+j,:) = [absc(i) ordi(j)];
	end
end

%% calculate kernel principal components and projections of Xtest
[E,v] = km_kpca(X,numeig,kernel.type,kernel.par);

Kt = km_kernel(X,Xtest,kernel.type,kernel.par);	% kernels of test data set
Xtestp = E'*Kt;	 % projections of test data set on the principal directions

Y = cell(numeig,1);
for i=1:numeig,
 	Y{i} = reshape(Xtestp(i,:),Nt2,Nt1);	% shape into 2D grid
end

toc
%% OUTPUT

figure;
plot(X(:,1),X(:,2),'.')
axis(border)

% fireworks!
for i=1:numeig,
	figure; hold on
	[C,h] = contourf(-interp2(Y{i},2),25);
	plot(X(:,1)/border(2)*(Nt1*4-1)+1,X(:,2)/border(4)*(Nt2*4-1)+1,'o',...
		'MarkerFaceColor','White','MarkerEdgeColor','Black')
	set(gca, 'XTick', [])
	set(gca, 'YTick', [])
end
