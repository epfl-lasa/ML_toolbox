function [ h ] = plot_q_mountain_car(Q)
%PLOT_Q_MOUNTAIN_CAR Summary of this function goes here
%   Detailed explanation goes here

% (N x 2)
s     = BuildStateList();
[v,I] = max(Q,[],2);

vs = -v;

xs      = linspace(-1.5,0.6,100);
ys      = linspace(-0.07,0.07,100);
[xi,yi] = meshgrid(xs,ys);


% Q (N x 2)

h = figure; hold on;
subplot(2,2,1);
zi = griddata(s(:,1),s(:,2),vs,xi,yi);
surf(xi,yi,zi); shading interp;
view(2);
title('Mountain car -max_u Q(x,u)');
xlabel('Position');
ylabel('Velocity');
colorbar;
ca = caxis;
xlim([-1.5,0.6]);
ylim([-0.07,0.07]);
axis square;
box on;

subplot(2,2,2);
plot_policy_moutain_car(Q);
xlim([-1.5,0.6]);
ylim([-0.07,0.07]);


subplot(2,2,3);
zi = griddata(s(:,1),s(:,2),-Q(:,1),xi,yi);
surf(xi,yi,zi); shading interp;
view(2);
title('-Q(x,-1)');
xlabel('Position');
ylabel('Velocity');
colorbar;
caxis(ca);
xlim([-1.5,0.6]);
ylim([-0.07,0.07]);
axis square;
box on;

subplot(2,2,4);
zi = griddata(s(:,1),s(:,2),-Q(:,2),xi,yi);
surf(xi,yi,zi); shading interp;
view(2);
title('-Q(x,1)');
xlabel('Position');
ylabel('Velocity');
colorbar;
caxis(ca);
xlim([-1.5,0.6]);
ylim([-0.07,0.07]);
axis square;
box on;

end

