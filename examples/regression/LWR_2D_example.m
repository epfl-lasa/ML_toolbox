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
options.D           = ones(2,1) .* ((2).^2);
options.K           = 50;
lwr                 = LWR(options);

%% Plot Train Data and train LWR

lwr.train(xy,z);

%% Predict values on 

[X,Y] = meshgrid(linspace(-5,5,100),linspace(-5,5,100));
Z     = lwr.f([X(:),Y(:)]);

%% Plot predicted values

if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = figure; hold on; box on;
surf(X,Y,reshape(Z,size(X))); shading interp;
title('Predicted values (LWR)');
axis square;
colorbar;






