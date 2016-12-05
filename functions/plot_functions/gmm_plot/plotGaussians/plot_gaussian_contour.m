function handle = plot_gaussian_contour(haxes,Mu,Sigma,color,STD,alpha )
%PLOT_GAUSSIAN_CONTOUR Summary of this function goes here
%   Detailed explanation goes here


if ~exist('STD','var'), STD=1;end
if ~exist('color','var'), color=[0 0 1];end
if ~exist('alpha','var'), alpha=1;end

for i=3:(-1):STD
    handle = plot_gaussian_ellipsoid(Mu,Sigma,i,100,haxes,alpha,color);
    set(handle,'LineWidth',2);
end


end

