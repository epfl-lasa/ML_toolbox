function [ MuOut,SigOut ] = getGaussianSlice(Mus,Sigmas,dims)



K = size(Mus,2);
D = size(dims,2);
MuOut = zeros(D,K);
SigOut = zeros(D,D,K);


for k = 1:K
    MuOut(:,k) = Mus(dims,k);
    SigOut(:,:,k) = Sigmas(dims,dims,k);
    
end


end

