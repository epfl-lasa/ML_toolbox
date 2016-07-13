function MountainCarPlot( x,a,steps )
subplot(2,1,2);

xplot =-1.6:0.05:0.6;
yplot =sin(3*xplot);
%Mountain
h = area(xplot,yplot,-1.1);   
set(h,'FaceColor',[.1 .7 .1])
hold on
% Car  [1 .7 .1]
plot(x(1),sin(3*x(1))+0.1,'ok','markersize',12,'MarkerFaceColor',[1 .7 .1]);
%Goal
plot(0.45,sin(3*0.5)+0.1,'-pk','markersize',15,'MarkerFaceColor',[1 .7 .1]);
% direction of the force
if (a<0)
      plot(x(1)-0.08,sin(3*x(1))+0.1,'<k','MarkerFaceColor','g','markersize',10);
elseif (a>0)
      plot(x(1)+0.08,sin(3*x(1))+0.1,'>k','MarkerFaceColor','g','markersize',10);
end

title(strcat ('Step: ',int2str(steps)));
%-----------------------
axis([-1.6 0.6 -1.1 1.5]);
drawnow
hold off