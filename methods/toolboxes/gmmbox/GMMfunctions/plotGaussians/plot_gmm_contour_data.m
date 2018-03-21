function plot_gmm_contour_data(handle,Priors,Mu,V,D)
%PLOT_GMM_CONTOUR_DATA 

K = size(Priors,2);

if ~exist('D','var')
    
    
    [dim,Ks]= size(Mu);
    
    
    Di = zeros(dim,Ks);     % eigenvalues
    Vi = zeros(dim,dim,Ks); % eigenvector
    
    for k=1:K
        
        [Vec,Eig] = eig(V(:,:,k));
        
        Di(:,k)   = diag(Eig);
        Vi(:,:,k) = Vec;
    end
    bp = get_gmm_contour_data(Priors,Mu,Vi,Di);
 
else
    bp = get_gmm_contour_data(Priors,Mu,V,D);
end

for k=1:K
    zd = get(handle(k),'ZData');
    cd = get(handle(k),'CData');
    set(handle(k),'XData',[bp(1,:,k) NaN]','YData',[bp(2,:,k) NaN]','ZData',zd,'CData',cd);
%     if K ~= 1
%             set(handle(k,1),'Position',[Mu(1,k) Mu(2,k)]);
%     end
end


end

