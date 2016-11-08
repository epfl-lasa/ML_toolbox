function h = plot_circle(center_x,center_y,r, npts,lineWidth,alphaChannel,color)
%PLOT_CIRCLE 
%
%   input -----------------------------------------------------------------
%
%
%       center_x: (1x1)
%
%


if ~exist('npts', 'var'), npts = 50; end
if isempty(npts), npts = 50; end
if ~exist('lineWidth','var'),lineWidth=1; end
if isempty(lineWidth), lineWidth = 1; end
if ~exist('alphaChannel', 'var'), alphaChannel = 1; end
if ~exist('color', 'var'), color = [0 0 1]; end

ang = linspace(0,2*pi,npts);
x=r*cos(ang) + center_x;
y=r*sin(ang) + center_y;

h = patchline(x(1,:),y(1,:),'linestyle','-','LineWidth',lineWidth,'edgealpha',alphaChannel,'edgecolor',color,'LineSmoothing','on');


end

