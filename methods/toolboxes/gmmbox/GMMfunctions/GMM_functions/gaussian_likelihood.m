function ys = gaussian_likelihood(xs,Priors,Mu,Sigmas )
%GAUSSIAN_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here
%
%   input ----------------------------------------------------------------
%
%       xs: (D x N)
%

K = size(Priors,2);
N = size(xs,2);
D = size(xs,1);

ys = zeros(1,N);

for i=1:N
    for k=1:K
        ys(i) = ys(i) + Priors(k).*gaussPDF(xs(:,i),Mu(:,k),Sigmas(:,:,k));
    end
end

end

