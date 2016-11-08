function handle = plot2dNormal(haxes,Mu,Sigma,color,STD)
%PLOT2DNORMAL Summary of this function goes here

if nargin == 3
   color = [1 0 0];
   STD=3;
end
if nargin == 4
   STD=3; 
end

for i=3:(-1):STD
    handle = plot_gaussian_ellipsoid(Mu,Sigma,i,50,haxes,color);
    set(handle,'color',color,'LineWidth',2);
end


end

