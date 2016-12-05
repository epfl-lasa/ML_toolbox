function plot2dGaussian(Priors,Mus,Sigmas)
%PLOT2DGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

disp('in plot2dGaussians');

GMM=struct('Priors',Priors,'Mus',Mus,'Sigmas',Sigmas,'K',size(Mus,2));

spacing=1000;
xGMM=marginalizeGMM(GMM,1);
xs=linspace(min(xGMM.Mus'-2*sqrt(squeeze(xGMM.Sigmas))),max(xGMM.Mus'+2*sqrt(squeeze(xGMM.Sigmas))),spacing);
yGMM=marginalizeGMM(GMM,2);
ys=linspace(min(yGMM.Mus'-2*sqrt(squeeze(yGMM.Sigmas))),max(yGMM.Mus'+2*sqrt(squeeze(yGMM.Sigmas))),spacing);
pdraw=zeros(1,spacing^2);
[X Y]=meshgrid(xs,ys);
x=X(:);
y=Y(:);
vtests2=[x y]';
GMM.K
for k=1:GMM.K
    pdraw=pdraw+GMM.Priors(k).*gaussPDF(vtests2,GMM.Mus(:,k),GMM.Sigmas(:,:,k))';
end

ppdraw=reshape(pdraw,spacing,spacing);

contourf(xs,ys,ppdraw);
%pcolor(xs,ys,ppdraw);
%shading interp;


set(gca,'YDir','normal');

end

