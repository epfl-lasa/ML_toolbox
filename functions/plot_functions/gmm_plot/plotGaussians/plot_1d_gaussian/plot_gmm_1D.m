function [xs,ys] = plot_gmm_1D(Priors,Mu,Sigmas)
%PLOT_GMM Summary of this function goes here
%   Detailed explanation goes here

D = size(Mu,1);
K = size(Mu,2);

[Y,I] = max(Mu);
Max = Y + 4.0*sqrt(Sigmas(I));
[Y,I] = min(Mu);
Min = Y - 4.0*sqrt(Sigmas(I));
nbSamples = 401;
xs=linspace(Min,Max, nbSamples);
ys = zeros(1,nbSamples);

for k=1:K
    ys=ys+(Priors(k).*gaussPDF(xs,Mu(k),Sigmas(k)))';
end




end

