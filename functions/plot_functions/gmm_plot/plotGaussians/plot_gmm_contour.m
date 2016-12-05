function handle = plot_gmm_contour(haxes,Priors,Mu,Sigma,color,STD,handle)
%PLOT_GMM_CONTOUR Summary of this function goes here
%   Detailed explanation goes here

K = size(Priors,2);
M = size(Mu,1);

if ~exist('STD','var'), STD=1;end
if ~exist('color','var'), color=repmat([0 0 1],K,1);end

if size(color,1) ~= K
   color = repmat(color,K,1); 
end

npts = 100;

if ~exist('handle','var')
    if M == 2
    handle = zeros(1,K);
        for k=1:K
            l = max(Priors);
            for i=3:(-1):STD
                w = Priors(k)/l;
                handle(k) = plot_gaussian_ellipsoid(Mu(:,k),Sigma(:,:,k),i,npts,haxes,w,color(k,:));
                %set(handle(k),'LineWidth',2);
                %  text(Mu(1,k),Mu(2,k),num2str(k),'FontWeight','bold','FontSize',24,'Color',color,'VerticalAlignment','middle','HorizontalAlignment','center');
            end
        end 
    elseif M==3
        for k=1:K
            [V1,D1] = eig(Sigma(:,:,k));
            [x_,y_,z_] = create3DgaussianEllipsoid(Mu(:,k),V1,STD*D1^1/2);
            mesh(x_,y_,z_,'EdgeColor',color(k,:),'Edgealpha',0.1);
            hidden off
            hold on;
        end        
    end
else
    
    for k=1:size(handle,2)
        l = max(Priors);
        %for i=3:(-1):STD
             w = Priors(k)/l;
            bp = get_elipsoid_data(Mu(:,k),Sigma(:,:,k),3,npts);
            
            zd = get(handle(k),'ZData');
            cd = get(handle(k),'CData');
            set(handle(k),'XData',[bp(1,:) NaN]','YData',[bp(2,:) NaN]','ZData',zd,'CData',cd);
       % end
    end
    
end

end

function bp = get_elipsoid_data(means, C, sdwidth, npts)
    if isempty(npts), npts=50; end
    % plot the gaussian fits
    tt   = linspace(0,2*pi,npts)'; 
    x    = cos(tt); y=sin(tt);
    ap   = [x(:) y(:)]';
    [v,d]= eig(C);
    d    = sdwidth * sqrt(d); % convert variance to sdwidth*sd
    bp   = (v*d*ap) + repmat(means, 1, size(ap,2));

end

