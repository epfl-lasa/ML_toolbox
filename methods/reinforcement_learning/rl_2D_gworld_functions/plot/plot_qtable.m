function [hQ] = plot_qtable(axes,Q,X,Y,h)
%PLOT_QTABLE 
%
%   
%   input ---------------------------------------------------------------
%
%
%
%

v       = max(Q,[],2);    
[Xq,Yq] = meshgrid(linspace(0,10,50),linspace(0,10,50));
Vq      = interp2(X,Y,reshape(v,size(X)),Xq,Yq);

if ~exist('h','var')
     
    hQ = pcolor(axes,Xq,Yq,Vq); shading interp;
   % hQ = scatter(axes,X(:),Y(:),20,v,'filled');
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
    set(h,'CData',Vq);
end




end

