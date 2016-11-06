%% 2D LWR test
clear all;
%% Generate target function to learn from and visualise

f       = @(x,y)sin(x).*cos(y);
r       = @(a,b,N,M)a + (b-a).*rand(N,M);
N       = 2000;
xy      = r(-5,5,N,2);
z       = f(xy(:,1),xy(:,2));

close all;
figure; hold on; box on;
scatter(xy(:,1),xy(:,2),10,z,'filled');
title('Training Data');
axis square;
colorbar;

%% LWR
 
options             = [];
options.dim         = 2;
options.bUseKDT     = true;
% options.D           = ones(2,1) .* ((2).^2);
options.D           = ones(2,1) .* ((0.2).^2);
options.K           = 100;
lwr                 = LWR(options);

% Plot Train Data and train LWR
lwr.train(X',y');

f = @lwr.f;

% Plot Estimated Function
options           = [];
options.title     = 'Estimated y=f(x) from Locally Weighted Regression';
options.surf_type = 'surf';
ml_plot_value_func(X,f,[1 2],options);hold on

%% Predict values on 

[X,Y] = meshgrid(linspace(-2,2,50),linspace(-2,2,50));
Z     = lwr.f([X(:),Y(:)]);

% Plot predicted values
if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = figure; hold on; box on;
surf(X,Y,reshape(Z,size(X))); 
xlabel('x_1');ylabel('x_2');zlabel('y');
title('Predicted values (LWR)');
axis square;
colormap hot




