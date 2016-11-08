function h = plot_scatter3_patch( X,r,col,a )
%PLOT_SCATTER3_PATCH Summary of this function goes here
%   Detailed explanation goes here

[x, y,z] = sphere(25);

h = zeros(size(X,1),1);

for i=1:size(X,1)
    x2 = r(i)*x + X(i,1);
    y2 = r(i)*y + X(i,2);
    z2 = r(i)*z + X(i,3); 
    h(i) = surf( x2, y2, z2);
    set(h(i),'FaceColor',col,'FaceAlpha',a,'EdgeColor','none','LineStyle','none','FaceLighting','phong');

end

end

