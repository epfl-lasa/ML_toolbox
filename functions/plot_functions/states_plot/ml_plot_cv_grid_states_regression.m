function [ handle,handle_test,handle_train] = ml_plot_cv_grid_states_regression(stats,parameterse,options)
%ML_PLOT_CV_GRID_STATES_REGRESSION Plots the results of grid search 
% K-fold Cross Validation on regression functions
%
%   input -----------------------------------------------------------------
%
%       o stats     : struct,   multi-layer structure, see output of
%                               ml_get_cv_grid_states_regression.m
%
%       o options   : struct,   plot options.
%   
%               options.title = 'title_figure';
%               options.metrics = cell array of metrics to plot.
%
%                   - options.metrics = {'mse','nmse'};
%   
%   output ----------------------------------------------------------------
%
%       o handle : figure handle
%
%   Documentation --------------------------------------------------------.
%
%   These are the list of metrics provided by stats and can be added to the options.metrics list:
%
%   '1'  - mean squared error                               (mse)
%   '2'  - normalised mean squared error                    (nmse)
%   '3'  - root mean squared error                          (rmse)
%   '4'  - normalised root mean squared error               (nrmse)
%   '5'  - mean absolute error                              (mae)
%   '6'  - mean  absolute relative error                    (mare)
%   '7'  - coefficient of correlation                       (r)
%   '8'  - coefficient of determination                     (d)
%   '9'  - coefficient of efficiency                        (e)
%  '10'  - maximum absolute error                           (me)
%  '11'  - maximum absolute relative error                  (mre)
%
%
%% Input processing

title_name  = 'add a title in options.title';
metrics     = {};
num_metrics = 0;
para_name   = 'parameters';

if isfield(options,'title'),        title_name      = options.title;        end
if isfield(options,'metrics'),      metrics         = options.metrics;      end
if isfield(options,'para_name'),    para_name       = options.para_name;    end




%% Check input

if isempty(metrics)
    error('options.metrics = {} is empty, you should provide at least one metric to plot; ex: mse');
end

num_metrics = length(metrics);


%% Plot

handle = figure('Color', [1 1 1]);
hold on; box on; grid on;

handle_test  = zeros(1,num_metrics);
handle_train = zeros(1,num_metrics);

% 1 Parameter to do grid search on
if size(parameterse,1) == 1
    x_index      = 1:1:length(parameterse);


    for i=1:num_metrics

        metric_name      = metrics{i};

        [h_train,h_test] = plot_metric(x_index,stats,metric_name,num_metrics);

        handle_train(i)  = h_train;
        handle_test(i)   = h_test;

    end
    
    if num_metrics > 1
        legend(handle_test,metrics);
    else
        legend([h_train,h_test],'Train','Test');
    end
    
    title(title_name);

    ax            = gca;
    ax.XTick      = x_index;
    ax.XTickLabel = parameterse;
    xlabel(para_name);

    ylabel(metric_name);

% 2 Parameters to do grid search on
elseif size(parameterse,1) == 2
    for i=1:num_metrics
        colormap hot; 
        x = parameterse(1,:);
        y = parameterse(2,:);

        h1 = subplot(1, 2, 1);  
        z = stats.train.(metrics{i}).mean;
        contourf(x,y,z)        
        title(h1,'Train Mean Accuracy')
        set(h1,'XTick',1:length(parameterse(1,:)));
        set(h1,'XTickLabel', parameterse(1,:));
        xlabel(h1,options.para_names{1});
        set(h1,'YTick',1:length(parameterse(2,:)));
        set(h1,'YTickLabel',parameterse(2,:));
        ylabel(h1,options.para_names{2});
        colorbar
        grid off
        axis square

        h2 = subplot(1, 2, 2);          
        z = stats.test.(metrics{i}).mean;
        contourf(x,y,z)        
        title(h2,'Test Mean Accuracy')        
        set(h2,'XTick',1:length(parameterse(1,:)));
        set(h2,'XTickLabel', parameterse(1,:));
        xlabel(h2,options.para_names{1});
        set(h2,'YTick',1:length(parameterse(2,:)));
        set(h2,'YTickLabel',parameterse(2,:));
        ylabel(options.para_names{2});
        ylabel(h2,options.para_names{2});
        colorbar
        grid off
        axis square
        suptitle([title_name ' : ' metrics{i}])
    end
    
% 3 Parameters to do grid search on
elseif size(parameterse,1) == 3
    for i=1:num_metrics
        colormap hot; 
        x = parameterse(3,:);
        y = parameterse(2,:);
        z = parameterse(1,:);
        [X, Y, Z] = meshgrid(x, y, z);   
        V = stats.train.(metrics{i}).mean;
        
        h1 = subplot(1, 2, 1);  
        slice(X, Y, Z, V, [], y, []);hold on;
        contourslice(X, Y, Z, V, [], y, []);
        shading interp
        set(gcf,'renderer', 'zbuffer');
        xlabel(options.para_names{3})
        ylabel(options.para_names{2})
        zlabel(options.para_names{1})
        title(strcat(title_name,'Train NMSE'),'Interpreter','Latex')
        cb1 = colorbar('southoutside');      
        alpha(0.95) 
        view(-56, 17)
        axis square

       
        h2 = subplot(1, 2, 2);          
        V = stats.test.(metrics{i}).mean;

        slice(X, Y, Z, V, [], y, []);hold on;
        contourslice(X, Y, Z, V, [], y, []);
        shading interp
        set(gcf,'renderer', 'zbuffer');
        xlabel(options.para_names{3})
        ylabel(options.para_names{2})
        zlabel(options.para_names{1})
        title(strcat(title_name,'Test NMSE'),'Interpreter','Latex')
        cb2 = colorbar('southoutside'); 
        alpha(0.95) 
        view(-56, 17)
        axis square
        
    end

    
    
end


end

function [h_train,h_test] = plot_metric(x_index,stats,metric_name,num_metrics)

if strcmp(metric_name,'mse')
    train_means = stats.train.mse.mean;
    train_stds  = stats.train.mse.std;
    test_means  = stats.test.mse.mean;
    test_stds   = stats.test.mse.std;
    
elseif strcmp(metric_name,'nmse')
    
    train_means = stats.train.nmse.mean;
    train_stds  = stats.train.nmse.std;
    test_means  = stats.test.nmse.mean;
    test_stds   = stats.test.nmse.std;
    
elseif strcmp(metric_name,'rmse')
    
    train_means = stats.train.rmse.mean;
    train_stds  = stats.train.rmse.std;
    test_means  = stats.test.rmse.mean;
    test_stds   = stats.test.rmse.std;
    
elseif strcmp(metric_name,'nrmse')
    
    train_means = stats.train.nrmse.mean;
    train_stds  = stats.train.nrmse.std;
    test_means  = stats.test.nrmse.mean;
    test_stds   = stats.test.nrmse.std;
    
elseif strcmp(metric_name,'mae')
    
    train_means = stats.train.mae.mean;
    train_stds  = stats.train.mae.std;
    test_means  = stats.test.mae.mean;
    test_stds   = stats.test.mae.std;
    
elseif strcmp(metric_name,'mare')
    
    train_means = stats.train.mare.mean;
    train_stds  = stats.train.mare.std;
    test_means  = stats.test.mare.mean;
    test_stds   = stats.test.mare.std;
    
elseif strcmp(metric_name,'r')
    
    train_means = stats.train.r.mean;
    train_stds  = stats.train.r.std;
    test_means  = stats.test.r.mean;
    test_stds   = stats.test.r.std;
    
elseif strcmp(metric_name,'d')
    
    train_means = stats.train.d.mean;
    train_stds  = stats.train.d.std;
    test_means  = stats.test.d.mean;
    test_stds   = stats.test.d.std;
    
elseif strcmp(metric_name,'e')
    
    train_means = stats.train.e.mean;
    train_stds  = stats.train.e.std;
    test_means  = stats.test.e.mean;
    test_stds   = stats.test.e.std;
    
elseif strcmp(metric_name,'me')
    
    train_means = stats.train.me.mean;
    train_stds  = stats.train.me.std;
    test_means  = stats.test.me.mean;
    test_stds   = stats.test.me.std;
        
elseif strcmp(metric_name,'mre')
    
    train_means = stats.train.mre.mean;
    train_stds  = stats.train.mre.std;
    test_means  = stats.test.mre.mean;
    test_stds   = stats.test.mre.std;
    
else
    error(['no such metric: ' metric_name]);
end

    [h_train,h_test] = plot_statisics(x_index,train_means,train_stds,test_means,test_stds,num_metrics);

end


function [h_train,h_test] = plot_statisics(x_index,train_means,train_stds,test_means,test_stds,num_metrics)
%
%   input -----------------------------------------------------------------
%
%       o x_index       : x values for x-y plot
%
%       o train_means   : (1 x N), set of means of k-CV
%       o train_stds    : (1 x N), set of standard deviations associated with
%                                  means.
%
%       o test_means    : same as train
%       o test_stds     : same as train
%
%       o color_train   : (1 x 3), RGB color of train plot
%       o color_test    : (1 x 3), RGB color of test plot
%
%       o num_metrics   : (1 x 1), number of metrics being plotted
%
%       o metric_name   : string, metrics name.
%




if num_metrics > 1
    
    h_train           = errorbar(x_index,train_means,train_stds,'--s');
    h_test            = errorbar(x_index,test_means,test_stds,'-s','Color',h_train.Color);
else
    h_train           = errorbar(x_index,train_means,train_stds,'-gs','Color', [0 1 0]);
    h_test            = errorbar(x_index,test_means,test_stds,'-rs','Color', [1 0 0]);   
end

end



