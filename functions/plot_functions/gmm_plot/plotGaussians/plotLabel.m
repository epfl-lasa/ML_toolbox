function h = plotLabel(ax,Mu,Std,color,label)
%PLOTLABEL Summary of this function goes here
%   Detailed explanation goes here

X = [Mu,0;
     Mu,normpdf(Mu,Mu,Std)];

h = plot(ax,X(:,1),X(:,2),'--','color',color);

if ~isempty(label)
   text(X(2,1),X(2,2),label,'HorizontalAlignment','left') 
end



end

