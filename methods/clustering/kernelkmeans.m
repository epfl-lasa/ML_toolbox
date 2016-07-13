function [predictedCluster,centroids,eigens] = kernelkmeans(Kn, k)

    [H, ~] = eigs(Kn, k);
    H_normalized = H ./ repmat(sqrt(sum(H.^2, 2)), 1, k);
    predictedCluster = kmeans(H_normalized, k);
    
    eigens = H;
    centroids = zeros(k,k);
    
    for i = 1:k
        centroids(i,:) = sum(H_normalized(predictedCluster==i,:),1)/size(H_normalized(predictedCluster==i,:),1);
    end
end
