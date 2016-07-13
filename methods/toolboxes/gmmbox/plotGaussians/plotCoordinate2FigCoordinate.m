function [ x_coor,y_coor ] = plotCoordinate2FigCoordinate(haxes,x,y)
%PLOTCOORDINATE2FIGCOORDINATE Summary of this function goes here
%   Detailed explanation goes here
axPos = get(haxes,'Position');
xMinMax = xlim;
yMinMax = ylim;
x_coor = axPos(1) + ((x - xMinMax(1))/(xMinMax(2)-xMinMax(1))) * axPos(3);
y_coor = axPos(2) + ((y - yMinMax(1))/(yMinMax(2)-yMinMax(1))) * axPos(4);

end

