function h1 = blr_plot_weights(X,y,blr_model)
%BLR_PLOT_WEIGHTS 
%
%% Process input

f_blr   = @(X)ml_blr(X,[],blr_model);
invA    = pinv(blr_model.A);
w       = blr_model.w;
Sigma_p = blr_model.Sigma_p;

%%

h1 = figure('Color',[1 1 1]); 
set(0,'defaulttextinterpreter','LaTex')

%% (1) Plot Prior weights p(w)
subtightplot(2,2,1,[0.1,0.1],0.1,0.1);
box on;
plot_gaussian_contour(gca,zeros(2,1),Sigma_p);
title('$p(\mathbf{w})$','FontSize',16);
grid on;
axis equal;


%% (4) Plot Posterior weights p(w|X,y)

ax4 = subtightplot(2,2,4,[0.1,0.1],0.1,0.1);
box on;
plot_gaussian_contour(gca,w,invA);
hold on;
plot(w(1),w(2),'+r');


xlabel('$\mathbf{w}_1$: slope','FontSize',16,'Interpreter','LaTex');
ylabel('$\mathbf{w}_2$: intercept','FontSize',16,'Interpreter','LaTex');

wd = floor(100 * w) /100;

title(['$p(\mathbf{w} | X,y)$ w: ' num2str(wd(1)) ' ' num2str(wd(2))],'FontSize',16);
grid on;
axis equal;


%% (3) Plot likelihood p(y|X,w)
subtightplot(2,2,3,[0.1,0.1],0.1,0.1);

[W1,W2]  = meshgrid(linspace(ax4.XLim(1),ax4.XLim(2),100),linspace(ax4.YLim(1),ax4.YLim(2),100));
W        = [W1(:),W2(:)];
lik      = zeros(size(W,1),1);
e_var    = 1;

for i = 1:size(W,1)
    lik(i) = ml_gauss_lik(y,X,W(i,:),e_var);
end
contour(W1,W2, reshape(lik,size(W1)) ) ;

hold on;
[~,max_id] = max(lik);
w_max      = W(max_id,:);
plot(w_max(1),w_max(2),'+r');

wd = floor(100 * w_max) /100;

xlabel('$\mathbf{w}_1$: slope','FontSize',16,'Interpreter','LaTex');
ylabel('$\mathbf{w}_2$: intercept','FontSize',16,'Interpreter','LaTex');
title(['$p(\mathbf{y}|X,\mathbf{w})$ w: ' num2str(wd(1)) ' ' num2str(wd(2))],'FontSize',16);


%% (2) Plot Linear Regressor
subtightplot(2,2,2,[0.1,0.1],0.1,0.1);
options              = [];
options.points_size  = 10;
options.plot_figure  = true; 
ml_plot_data([X(:),y(:)],options);

blr_options          = [];
blr_options.bFigure  = false;
blr_options.color    = [1 0 0];

blr_plot(X,f_blr,blr_options);

title(['$y = \mathbf{w}^{T} * x$; $\sigma^2$:',num2str(blr_model.e_var)],'FontSize',16);

% [~,ls_model] = ml_ls(X,y,[]);
% f_ls         = @(X)ml_ls(X,[],ls_model);
%  
% ls_options          = [];
% ls_options.bFigure  = false;
% ls_options.color    = [0 1 0];
% ml_plot_regression(X,f_ls,ls_options);
% 




end

