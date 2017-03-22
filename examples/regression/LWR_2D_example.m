%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Locally Weighted Regression 2D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          1) Generate 2D Regression Datasets                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate target function to learn from and visualise
clear all; close all; clc;
f       = @(x,y)sin(x).*cos(y);
r       = @(a,b,N,M)a + (b-a).*rand(N,M);
N       = 2000;
X       = r(-5,5,N,2);
y       = f(X(:,1),X(:,2));

% Plot data
options             = [];
options.points_size = 15;
options.cmap        = y;
options.plot_labels = {'$x_1$','$x_2$','y'};
options.title       = 'Example 2D Non-linear Training Data'; 
if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data([X,y],options); hold on;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 2) "Train" LWR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train LWR
options             = [];
options.dim         = 2;
options.bUseKDT     = true;
options.D           = ones(2,1) .* ((0.2).^2);
options.K           = 100;
lwr                 = LWR(options);

% Plot Train Data and train LWR
lwr.train(X,y);

f = @lwr.f;

% Plot Estimated Function
options           = [];
options.title     = 'Estimated y=f(x) from Locally Weighted Regression';
options.surf_type = 'surf';
if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = ml_plot_value_func(X,f,[1 2],options);hold on

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           3) Test LWR Model on Query points                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Predict values on a smaller grid x_1:[-2,2] x_2:[-2,2]

[x1_test,x2_test] = meshgrid(linspace(-2,2,50),linspace(-2,2,50));
y_test     = lwr.f([x1_test(:),x2_test(:)]);
M = length(y_test);

% Plotting Options for Regressive Function
options           = [];
options.title     = 'Estimated y=f(x) from Locally Weighted Regression';
options.surf_type = 'surf';
if exist('h3','var') && isvalid(h3), delete(h3);end
h3 = ml_plot_value_func([x1_test(:),x2_test(:)],f,[1 2],options);hold on

% Plot Training Data on Top
options = [];
options.plot_figure = true;
options.points_size = 12;
options.labels = zeros(M,1);
options.plot_labels = {'$x_1$','$x_2$','y'};
ml_plot_data([x1_test(:),x2_test(:),y_test(:)],options); 
