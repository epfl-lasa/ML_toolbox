function plot_policy_moutain_car(Q)
%PLOT_POLICY_MOUTAIN_CAR Summary of this function goes here
%   Detailed explanation goes here

s     = BuildStateList();
[v,I] = max(Q,[],2);

U = zeros(size(v,1),1);

U(find(Q(:,1) > Q(:,2))) = -1;
U(find(Q(:,1) < Q(:,2))) =  1;

xs      = linspace(-1.5,0.6,100);
ys      = linspace(-0.07,0.07,100);
[xi,yi] = meshgrid(xs,ys);
zi = griddata(s(:,1),s(:,2),U,xi,yi);
zi(zi>0) = 1;
zi(zi<0) = -1;
pcolor(xi,yi,zi); shading interp;
title('Policy action: -1 or 1');
xlabel('Position');
ylabel('Velocity');
colorbar;
caxis([-1,1]);
axis square;




end

