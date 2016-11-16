function [] = ml_plot_gmr_function(X, y_est, Sigma_y, options)


% Parse Plotting options
var_scale   = 2;
plot_figure = true; 
if isfield(options,'var_scale')   var_scale   = options.var_scale; end
if isfield(options,'plot_figure') plot_figure = options.plot_figure; end

[M,N] = size(X);

if plot_figure == true
    figure('Color',[1 1 1])
else
    hold on;
end

if N ==1 % Plot regressive function and variance on 1D signal
    ml_shadedErrorBar(X, y_est,[reshape(sqrt(var_scale.*Sigma_y),[1 size(y_est,2)]); reshape(sqrt(var_scale.*Sigma_y),[1 size(y_est,2)])],{'-r','LineWidth',3}, 1)

elseif N==2 % Plot regressive function and variance on 2D signal
     
        
end