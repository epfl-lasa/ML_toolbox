function [handle] = ml_plot_images(X,dims)
%ML_PLOT_IMAGES Plot images 
%
%   input -----------------------------------------------------------------
%
%       o X     : (N x D), set of N images of dimension D.
%
%       o dims  : (1 x 2), image dimensions  
%
%  
%   
%   output ----------------------------------------------------------------
%
%       o handle : handle to the image which is plotted
%
%

[N,D] = size(X);

handle = figure;

[Xs,Ys] = meshgrid(1:dims(1),1:dims(2));

if N >=64
    nbImages = 8;
else
    nbImages = (floor(sqrt(N)));
end

for j = 1:nbImages^2
    subaxis(nbImages,nbImages,j,'Spacing', 0.01, 'Padding', 0, 'Margin', 0.05);
%     pcolor(Xs,Ys,reshape(X(j,:),size(Xs)));
    imagesc(reshape(X(j,:),dims));
    shading interp;
    colormap('gray');
    axis off;
end


end

