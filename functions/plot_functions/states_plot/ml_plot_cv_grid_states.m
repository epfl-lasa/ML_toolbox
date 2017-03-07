function [ handle ] = ml_plot_cv_grid_states(stats,options)
%ML_PLOT_CV_GRID_STATES Plots the results of grid search K-fold Cross
% Validation
%
%   input -----------------------------------------------------------------
%
%       o stats     : struct,   multi-layer structure, see output of
%                               ml_get_cv_grid_states.m
%
%       o options   : struct,   plot options.
%   
%               options.title = 'title_figure';
%               options.param_names = ['C', 'sigma'];
%   
%   output ----------------------------------------------------------------
%
%       o handle : figure handle
%


if ~isfield(options,'title'),options.title = 'add a title in options.title'; end
if ~isfield(options,'log_grid'),options.log_grid = 0'; end

title_name = options.title;
handle = figure('Color', [1 1 1]);
hold on;

[P, N] = size(stats.train.acc.mean');

if P > 1 && N > 1
           
        colormap hot; 
        x = options.param_ranges(2,:);
        y = options.param_ranges(1,:);
        
        subplot(2, 3, 1)  
        z = stats.train.acc.mean;
        contourf(x,y,z)      
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
        title('Train Accuracy')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square

        subplot(2, 3, 2)  
        z = stats.train.fmeasure.mean;
        contourf(x,y,z)     
        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
               
        title('Train F-measure')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square
        
        subplot(2, 3, 3)  
        z = stats.train.fpr.mean;
        contourf(x,y,z)        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
        title('Train FPR (Fall-out)')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square
        
        
        subplot(2, 3, 4)  
        z = stats.train.tnr.mean;
        contourf(x,y,z)        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
        title('Train TNR (Specificity)')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square
        
        
        subplot(2, 3, 5)  
        z = stats.model.ratioSV.mean;
        contourf(x,y,z)        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
        title('% of SV/M Datapoints')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square
        
        
        subplot(2, 3, 6)  
        z = stats.model.boundSV.mean;
        contourf(x,y,z)        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
        end
        title('% of Bounded SVs / Total SVs')        
        xlabel(options.param_names(2))
        ylabel(options.param_names(1))

        colorbar
        grid off
        axis square
        
        suptitle(title_name)
        
        if isfield(stats,'test')
            
            handle2 = figure('Color', [1 1 1]);
            hold on;
            colormap hot;
            x = options.param_ranges(2,:);
            y = options.param_ranges(1,:);
            
            subplot(2, 2, 1)
            z = stats.test.acc.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
            end
            title('Test Accuracy')
            xlabel(options.param_names(2))
            ylabel(options.param_names(1))
            
            colorbar
            grid off
            axis square
            
            subplot(2, 2, 2)
            z = stats.test.fmeasure.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
            end
            
            title('Test F-measure')
            xlabel(options.param_names(2))
            ylabel(options.param_names(1))
            
            colorbar
            grid off
            axis square
            
            subplot(2, 2, 3)
            z = stats.test.fpr.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
            end
            title('Test FPR (Fall-out)')
            xlabel(options.param_names(2))
            ylabel(options.param_names(1))
            
            colorbar
            grid off
            axis square
            
            
            subplot(2, 2, 4)
            z = stats.test.tnr.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
            end
            title('Test TNR (Specificity)')
            xlabel(options.param_names(2))
            ylabel(options.param_names(1))
            
            colorbar
            grid off
            axis square          
            
            suptitle(title_name)
        end
        
               
else
    
        x_index = 1:1:length(stats.test.acc.mean);
        
        h1 = errorbar(x_index,stats.test.acc.mean,stats.test.acc.std,'-rs');
        h2 = errorbar(x_index,stats.train.acc.mean,stats.train.acc.std,'-gs');
        
        xlabel('Models','FontSize',14);
        ylabel('Evaluation metric','FontSize',14);
        hl = legend([h1,h2],'Test ACC','Train ACC');
        set(hl,'Location','SouthEast');
        title(title_name,'FontSize',16);
        box on; 
        grid on;

end


end

