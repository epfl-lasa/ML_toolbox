function [ hQ ] = plot_actions( axes,Q,X,Y,h )
%PLOT_ACTIONS Summary of this function goes here
%   Detailed explanation goes here



v = max(Q,[],2);    


if ~exist('h','var')
 
    hQ = pcolor(axes,X,Y,reshape(v,size(X)));
    %caxis([0,10]);
    colormap(jet(256));
    colorbar;
    title('Value function');
    axes = gca;
    axes.XTickLabel = [];
    axes.YTickLabel = [];
    xlim([-1,11]);
    ylim([-1,11]);
    
    
else
    set(h,'CData',reshape(v,size(X)));
end



end

