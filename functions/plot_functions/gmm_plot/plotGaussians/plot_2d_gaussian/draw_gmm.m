function handle = draw_gmm(haxes,Priors,Mu,Sigma )
%DRAW_GMM Summary of this function goes here
%   Detailed explanation goes here


K = size(Priors,2);
STD=3;

for k=1:K
    l = max(Priors);
    for i=3:(-1):STD
        w = Priors(k)/l;
        handle = plot_gaussian_ellipsoid(Mu(:,k),Sigma(:,:,k),i,100,haxes,w,[0 0 1]);
        set(handle,'LineWidth',2);
      %  obj.text_handle = [obj.text_handle text(obj.Mu(1,k),obj.Mu(2,k),num2str(k),'FontWeight','bold','FontSize',24,'Color',obj.color,'VerticalAlignment','middle','HorizontalAlignment','center')];
    end
end


end

