function gmm_12 = product_gmm(gmm_1,gmm_2,mrf)
%PRODUCT_GMM takes the product between two GMMs

K1 = size(gmm_1.Priors,2);

k = 1;

for i=1:K1
    
    I = find(mrf.A(i,:));
    
    if ~isempty(I)
        
        jl = [mrf.Aj_index(i,I,1)' mrf.Aj_index(i,I,2)'];
        
        for j=1:size(jl,1)
            
                [Mu,Sigma] = product_gauss(gmm_1.Mu(:,i),gmm_1.Sigma(:,:,i),gmm_2.Mu(:,jl(2)),gmm_2.Sigma(:,:,jl(2)));
                gmm_12.Mu(:,k) = Mu;
                gmm_12.Sigma(:,:,k) = Sigma;
                k = k + 1;
        end
        
    end
end

K = size(gmm_12.Mu,2);
gmm_12.Priors = ones(1,K)./K;


end

