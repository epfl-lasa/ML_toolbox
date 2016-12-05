function  [bp,W] = get_gmm_contour_data(Priors,Mu,V,D)
%PLOT_GMM_CONTOUR Summary of this function goes here
%   Detailed explanation goes here

K = size(Priors,2);


npts = 50;
sdwidth=3;


if K == 1
     W=0;
    tt=linspace(0,2*pi,npts)';
    x = cos(tt); y=sin(tt);
    ap = [x(:) y(:)]';
    D = sdwidth * sqrt(D); % convert variance to sdwidth*sd
    bp = (V*diag(D)*ap) + repmat(Mu, 1, size(ap,2));

    
else
    bp = zeros(2,npts,K);
    W = zeros(1,K);
    
    for k=1:K
        l = max(Priors);
        W(k) = Priors(k)/l;
        tt=linspace(0,2*pi,npts)';
        x = cos(tt); y=sin(tt);
        ap = [x(:) y(:)]';
        D(:,k) = sdwidth * sqrt(D(:,k)); % convert variance to sdwidth*sd
        bp(:,:,k) = (V(:,:,k)*diag(D(:,k))*ap) + repmat(Mu(:,k), 1, size(ap,2));
        
    end
    
end

end

