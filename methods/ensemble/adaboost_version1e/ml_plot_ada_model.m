function handle = ml_plot_ada_model(X,labels,model,options)
%ML_PLOT_ADA_MODEL: Plots the weak decision functions 
%
%   input -----------------------------------------------------------------
%       
%       o X         : (N x D), original data
%
%       o labels    : (N x 1), class labels {-1,+1}
%
%       o model     : returned by adaboots.m
%
%% Handle Input
dims            = [1,2];
plot_figure     = true; % if false plots a new figure
handle          = [];

if isfield(options,'dims'),             dims          = options.dims;                       end
if isfield(options,'no_figure'),        plot_figure   = ~options.no_figure;                  end

%% Plot 

if plot_figure,  handle = figure; end

%% Plot value C(x)

    
[Xs,Ys]     = ml_get_grid(X,dims,100);
Zs          = ml_adaboost_value([Xs(:),Ys(:)],model);

pcolor(Xs,Ys,reshape(Zs,size(Xs))); shading interp;
colormap('hot');

%% Plot Original data X
hold on;
options_plot_data.plot_figure = true;
options_plot_data.labels      = labels;

ml_plot_data(X(:,dims),options_plot_data);


%% Title, etc..


if plot_figure == true
   colorbar;
   set(0,'defaulttextinterpreter','latex');
   title(['$C(\mathbf{x})$  with  '  num2str(length(model)) ' $\phi(\mathbf{x})$'],'FontSize',16); 
   xlabel(['$x_' num2str(dims(1)) '$'],'FontSize',22);
   ylabel(['$x_' num2str(dims(2)) '$'],'FontSize',22); 
end



end
