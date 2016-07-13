% KM_DEMO_KPCA_3CLUSTERS Kernel principal component analysis (KPCA) on a 3-cluster
% two-dimensional data set. 
%
% This program implements the example shown in Figure 2.5 of "Kernel
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

N_split = [20, 20, 20];		% number of data points in each cluster
m_split = [1.7,1.7; 3.2,4.2; 4.2,2.2];	% coordinates of each center
nvar = 0.3;	% noise variance

kernel.type = 'gauss';
kernel.par =  .5;
numeig = 4;	% number of eigenvalues to plot

Ntest = [50,50];	% number of test grid divisions, in each dimension
border = [0 6 0 6];	% test grid border
 
%% PROGRAM
tic

%% generate data
N = sum(N_split);
X = [];
for i=1:3,
	Xsplit = repmat(m_split(i,:),N_split(i),1) + nvar*randn(N_split(i),2);
	X = [X;Xsplit]; %#ok<AGROW>
end

%% generate test grid data
Nt1 = Ntest(1); Nt2 = Ntest(2);
Xtest = zeros(Nt1*Nt2,2);
absc = linspace(border(1),border(2),Nt1);
ordi = linspace(border(3),border(4),Nt2);
for i=1:Nt1,
	for j=1:Nt2,
		Xtest((i-1)*Nt2+j,:) = [absc(i);ordi(j)];
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
