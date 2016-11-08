function pb = plot_scatter_patch(X,r,col,a)
%PLOT_SCATTER_PATCH Summary of this function goes here
%   Detailed explanation goes here

   
t= 0:pi/100:2*pi;

pb = zeros(size(X,1),1);

for i=1:size(X,1)
    pb(i)=patch( (r(i)*sin(t)+ X(i,1)) , (r(i)*cos(t)+X(i,2)) ,col,'MarkerEdgeColor','none');
    alpha(pb(i),a);
end


end

