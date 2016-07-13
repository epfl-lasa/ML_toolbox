function [ h1 ] = plot_sample_trajectories( xurxps )
%PLOT_SAMPLE_TRAJECTORIES Summary of this function goes here
%   Detailed explanation goes here

h1 = figure;

subplot(1,2,1);
hold on; grid on;
for n=1:size(xurxps,1)
    
    xurxp = xurxps{n};
    
    x  = xurxp(:,1:2);
    u  = xurxp(:,3);
    r  = xurxp(:,4);
    xp = xurxp(:,5:6);
    
    % plot start
    scatter(x(1,1),x(1,2),15,[0 0 0],'filled');
    scatter(x(end,1),x(end,2),15,[1 0 0],'filled');
    scatter(x(:,1),x(:,2),2,r,'filled');
    plot(x(:,1),x(:,2));
end
title('recorded (x,r)');
xlabel('position');
ylabel('velocity');

subplot(1,2,2);
hold on; grid on;
for n=1:size(xurxps,1)
    
    xurxp = xurxps{n};
    
    r  = xurxp(:,4);
    xp = xurxp(:,5:6);
    
    
    scatter(xp(:,1),xp(:,2),5,r,'filled');
end
title('recorded (xp,r)');
xlabel('position');
ylabel('velocity');

end

