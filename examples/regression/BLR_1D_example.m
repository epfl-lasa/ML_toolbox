%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bayesian Linear Regression 1D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          1) Generate 1D Regression Datasets                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate some data
clear all;close all;clc;
nbSamples = 50;
X         = linspace(0,4,nbSamples);
w         = [0.5 25];
y         = X * w(1) + normrnd(0,0.2,1,nbSamples) + w(2);


options             = [];
options.points_size = 20;
options.title       = 'Training data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 2) Train BLR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train Baysian Gaussian Linear regressin
var         = 0.2;        % variance in the noise of the data
Sigma_p     = eye(2,2);
Xb          = [X];
yb          = y;
[w,invA]    = train_blr(Xb',y',var,Sigma_p);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  3) Test BLR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Prediction

x_test  = [linspace(0,4,100);ones(1,100)];
y_test  = x_test' * w;
Sigma   = x_test' * invA * x_test;


if exist('h2','var') && isvalid(h2), delete(h2);end
if exist('h3','var') && isvalid(h3), delete(h3);end


h2 = figure; 

subplot(1,2,1);
box on;
plot_gaussian_contour(gca,zeros(2,1),Sigma_p);
xlabel('b','FontSize',11);
ylabel('a','FontSize',11);
title('Prior weights','FontSize',11);
grid on;
axis square;
axis_limits = axis;

subplot(1,2,2);
box on;
plot_gaussian_contour(gca,w,invA);
xlabel('b','FontSize',11);
ylabel('a','FontSize',11);
title('Posterior weights','FontSize',11);
grid on;
axis square;

h3 = figure;
hold on;box on;
scatter(X,y,20,'filled');
hp = plot(x_test(1,:),y_test,'--r','LineWidth',2);
grid on;
axis square;
legend(hp,'regression line');
title('y = b * x + a');
