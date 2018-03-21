%% Test taking the product of two Gaussians
clear all;

a = Normal(-2,(sqrt(1.0001))^2);
b = Normal(5,(sqrt(19.99999))^2);

[Mu3,Sigma3] = product_gauss(a.Mu,a.Sigma,b.Mu,b.Sigma);
ab = Normal(Mu3,Sigma3);
ab.color = [1 0 0];
[Mu3,Sigma3] = product_gauss(b.Mu,b.Sigma,a.Mu,a.Sigma);
ba = Normal(Mu3,Sigma3);
ba.color = [0 1 0];

c = Normal([0 0]',[5 0;0 10]);
d = Normal([2 2]',[5 0;0 5]);
c.STD=3;
d.STD=3;

[Mu3,Sigma3] = product_gauss(c.Mu,c.Sigma,d.Mu,d.Sigma);
cd = Normal(Mu3,Sigma3);
cd.color = [1 0 0];
cd.STD=3;
[Mu4,Sigma4] = product_gauss(d.Mu,d.Sigma,c.Mu,c.Sigma);
dc = Normal(Mu4,Sigma4);
dc.color = [1 1 0];
dc.STD=3;


%% Graphics plot

figure;hold on;

a.draw(gca);
b.draw(gca);
haxes = ab.draw(gca);
set(haxes,'LineWidth',4);
haxes = ba.draw(gca);
set(haxes,'LineWidth',2);

hold off;

figure; hold on;
c.draw(gca);
d.draw(gca);
cd.draw(gca);
dc.draw(gca);
hold off;


%% Second test

min_eig = 1;
max_eig = 20;   
min_std = sqrt(min_eig);
max_std = sqrt(max_eig);

Mu1 = [0 0]';
Sigma1 = eye(2,2) .* ((min_std)^2 + 1);


Mu2 = [0 8]';
Sigma2 = eye(2,2) .* ((max_std)^2 - 1);


[Mu3,Sigma3] = product_gauss(Mu1,Sigma1,Mu2,Sigma2);

[Mu4,Sigma4] = product_gauss(Mu2,Sigma2,Mu1,Sigma1);


%% Graphics

figure; hold on;
axis equal; grid on;
haxes = gca();

plot_gaussian_contour(haxes,Mu1,Sigma1,[0 0 1],3,1 );
plot_gaussian_contour(haxes,Mu2,Sigma2,[0 0 1],3,1 );

plot_gaussian_contour(haxes,Mu3,Sigma3,[1 0 0],3,0.5); 
plot_gaussian_contour(haxes,Mu4,Sigma4,[0 1 0],3,1 );

hold off;



