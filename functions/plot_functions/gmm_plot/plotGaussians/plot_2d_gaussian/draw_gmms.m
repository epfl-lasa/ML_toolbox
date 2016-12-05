function [X,Y,I] = draw_gmms(GMMs,colormaps,x_range,y_range,spacing )
%   DRAW_GMMS Draws the scales likelihood of a set of GMMs with different
%   colormaps
%   
%   input ----------------------------------------------------------------
%
%
%

nbGMMs = size(GMMs,1);
disp(['number of GMMs: ' num2str(nbGMMs)]);

xs=linspace(x_range(1),x_range(2),spacing);
ys=linspace(y_range(1),y_range(2),spacing);
            
[X, Y]=meshgrid(xs,ys);
x=X(:);
y=Y(:);
vtests2=[x y]';
pdraw=zeros(1,spacing^2);

nspacing_2 = 1000;

Is = zeros([nspacing_2 nspacing_2 3 nbGMMs]);
fractions = zeros([(nspacing_2 * nspacing_2) nbGMMs]);
I = zeros([nspacing_2 nspacing_2 3]);


for i=1:nbGMMs
    
    gmm = GMMs(i);
    cmap = colormaps{i};
    CData = compute_CData(gmm,size(cmap,1),pdraw,X,Y,vtests2,nspacing_2,spacing);
    Is(:,:,:,i) = reshape( cmap(CData(:),:),[nspacing_2 nspacing_2 3]);
    fractions(:,i) = reshape(CData ./ max(CData(:)),[nspacing_2*nspacing_2 1]);
end

fractions = fractions./repmat(sum(fractions,2),1,nbGMMs);

for i=1:nbGMMs
    I = I + repmat(reshape(fractions(:,i),nspacing_2,nspacing_2),[1 1 3]) .* Is(:,:,:,i);
    %I = I + repmat(fractions(:,i),nspacing_2,nspacing_2),[1 1 3]) .* Is(:,:,:,i);
end

end


function CData =compute_CData(gmm,m,pdraw,X,Y,vtests2,nspacing_2,spacing)

for k=1:size(gmm.Priors,2)
    pdraw=pdraw+gmm.Priors(k).*gaussPDF(vtests2,gmm.Mu(:,k),gmm.Sigma(:,:,k));
end

ppdraw=reshape(pdraw,spacing,spacing);
% F = griddedInterpolant(X', Y', ppdraw', 'cubic');
% 
% xqgv = linspace(min(X(:)),max(X(:)),nspacing_2);
% yqgv = linspace(min(Y(:)),max(Y(:)),nspacing_2);
% [Xq,Yq] = ndgrid(xqgv,yqgv);
% Vq = F(Xq, Yq);

cmin = min(ppdraw(:));
cmax = max(ppdraw(:));
CData = min(m,round((m-1)*(ppdraw-cmin)/(cmax-cmin))+1); 

end

