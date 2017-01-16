function handles = plot3dGaussian(Priors, Mus,Sigmas )


K = size(Mus,2);
npts = 50; 

handles = zeros(K,1);

weights = rescale(Priors,min(Priors),max(Priors),0.01,0.8);

weights(isnan(weights)==1) = 0.8;

for k = 1:K    
    [x,y,z] = sphere(npts);
    ap = [x(:) y(:) z(:)]';
    [v,d]=eig(Sigmas(:,:,k));
    if any(d(:) < 0)
        fprintf('warning: negative eigenvalues\n');
        d = max(d,0);
    end
    d =  sqrt(d); % convert variance to sdwidth*sd
    bp = (v*d*ap) + repmat(Mus(:,k), 1, size(ap,2));
    xp = reshape(bp(1,:), size(x));
    yp = reshape(bp(2,:), size(y));
    zp = reshape(bp(3,:), size(z));
    handles(k) = surf(xp,yp,zp);

    
%     %[~,D] = eig(Sigmas(:,:,k));
%     %eigV = sqrt(diag(D))
%     %[x, y, z] = ellipsoid(Mus(1,k),Mus(2,k),Mus(3,k),eigV(1,1),eigV(2,1),eigV(3,1),30);

    
    scatter3(Mus(1,k),Mus(2,k),Mus(3,k),2,'filled','ko');
    sh = surfl(xp, yp, zp);
%     set(sh,'FaceColor',[0.5,0.5,0.5],'FaceAlpha',weights(k),'EdgeColor','none')
    set(sh,'FaceColor',[1,0,0],'FaceAlpha',weights(k),'EdgeColor','none')


end

end

