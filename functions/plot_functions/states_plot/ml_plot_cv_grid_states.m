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
if ~isfield(options,'svm_metrics'),options.svm_metrics = 0'; end

title_name = options.title;


[P, N] = size(stats.train.acc.mean');

if P > 1 && N > 1
        handle = figure('Color', [1 1 1],  'Position', [0, 1000, 1295, 455]);
        hold on;
        colormap hot; 
        x = options.param_ranges(2,:);
        y = options.param_ranges(1,:);
       
        if (options.svm_metrics == 1)
            subplot(2, 3, 1)
        else
            subplot(1, 2, 1)
        end
        z = stats.train.acc.mean;
        contourf(x,y,z)      
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
            x_range = options.param_ranges(2,:);
            y_range = options.param_ranges(1,:);
            set(gca, 'XTick', options.param_ranges(2,:))
            set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
            set(gca, 'YTick', options.param_ranges(1,:))
            set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
        end
        title('Train Accuracy (Mean)','FontSize',14, 'FontWeight','Normal')                
        xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
        ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')

        colorbar
        grid off
        axis square

        if (options.svm_metrics == 1)
            subplot(2, 3, 2)
        else
            subplot(1, 2, 2)
        end
        z = stats.train.fmeasure.mean;
        contourf(x,y,z)     
        
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            set(gca,'yscale','log')
            x_range = options.param_ranges(2,:);
            y_range = options.param_ranges(1,:);
            set(gca, 'XTick', options.param_ranges(2,:))
            set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
            set(gca, 'YTick', options.param_ranges(1,:))
            set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
        end
               
        title('Train F-measure (Mean)','FontSize',14, 'FontWeight','Normal')        
        xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
        ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')

        colorbar
        grid off
        axis square
        
        if (options.svm_metrics == 1)
            subplot(2, 3, 3)
            z = stats.train.fpr.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
                x_range = options.param_ranges(2,:);
                y_range = options.param_ranges(1,:);
                set(gca, 'XTick', options.param_ranges(2,:))
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                set(gca, 'YTick', options.param_ranges(1,:))
                set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
            end
            title('Mean Train FPR (Fall-out)', 'FontSize',14, 'FontWeight','Normal')
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
            colorbar
            grid off
            axis square
                        
            subplot(2, 3, 4)
            z = stats.train.tnr.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
                x_range = options.param_ranges(2,:);
                y_range = options.param_ranges(1,:);
                set(gca, 'XTick', options.param_ranges(2,:))
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                set(gca, 'YTick', options.param_ranges(1,:))
                set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
            end
            title('Mean Train TNR (Specificity)', 'FontSize',14, 'FontWeight','Normal')
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
            colorbar
            grid off
            axis square
            
            
            subplot(2, 3, 5)
            z = stats.model.ratioSV.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
                x_range = options.param_ranges(2,:);
                y_range = options.param_ranges(1,:);
                set(gca, 'XTick', options.param_ranges(2,:))
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                set(gca, 'YTick', options.param_ranges(1,:))
                set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
            end
            title('% of SV/M Datapoints', 'FontSize',14, 'FontWeight','Normal')
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
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
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
            colorbar
            grid off
            axis square
        end
        
        if isfield(stats,'test')
            
            handle2 =  figure('Color', [1 1 1],  'Position', [0, 125,  1295, 455]);
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
                x_range = options.param_ranges(2,:);
                y_range = options.param_ranges(1,:);
                set(gca, 'XTick', options.param_ranges(2,:))
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                set(gca, 'YTick', options.param_ranges(1,:))
                set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
            end
            title('Test Accuracy (Mean)' , 'FontSize',14, 'FontWeight','Normal')
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
            colorbar
            grid off
            axis square
            

            subplot(2, 2, 2)
            z = stats.test.fmeasure.mean;
            contourf(x,y,z)
            if (options.log_grid ==1)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
                x_range = options.param_ranges(2,:);
                y_range = options.param_ranges(1,:);
                set(gca, 'XTick', options.param_ranges(2,:))
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                set(gca, 'YTick', options.param_ranges(1,:))
                set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
            end
            
            title('Test F-measure (Mean)', 'FontSize',14, 'FontWeight','Normal')
            xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
            ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
            
            colorbar
            grid off
            axis square
            

                subplot(2, 2, 3)
                z = stats.test.fpr.mean;
                contourf(x,y,z)
                if (options.log_grid ==1)
                    set(gca,'xscale','log')
                    set(gca,'yscale','log')
                    x_range = options.param_ranges(2,:);
                    y_range = options.param_ranges(1,:);
                    set(gca, 'XTick', options.param_ranges(2,:))
                    set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                    set(gca, 'YTick', options.param_ranges(1,:))
                    set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))                 
                end
                title('Test FPR (Fall-out)', 'FontSize',14, 'FontWeight','Normal')
                xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
                ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
                
                colorbar
                grid off
               axis square
                
                
                subplot(2, 2, 4)
                z = stats.test.tnr.mean;
                contourf(x,y,z)
                if (options.log_grid ==1)
                    set(gca,'xscale','log')
                    set(gca,'yscale','log')
                    x_range = options.param_ranges(2,:);
                    y_range = options.param_ranges(1,:);
                    set(gca, 'XTick', options.param_ranges(2,:))
                    set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
                    set(gca, 'YTick', options.param_ranges(1,:))
                    set(gca,'YTickLabel', cellstr(num2str(y_range(:), '%4.2f')))
                end
                title('Test TNR (Specificity)', 'FontSize',14, 'FontWeight','Normal')
                xlabel(options.param_names(2), 'FontSize',14, 'FontWeight','Normal')
                ylabel(options.param_names(1), 'FontSize',14, 'FontWeight','Normal')
                
                colorbar
                grid off
                axis square
        end
        
               
else
        handle = figure('Color', [1 1 1]);
   
        x_index = options.param_ranges;
        subplot(1,2,1)        
        errorbar(x_index,stats.test.acc.mean,stats.test.acc.std,'-rs'); hold on;
        errorbar(x_index,stats.train.acc.mean,stats.train.acc.std,'-gs');
        
        xlabel(options.param_names, 'FontSize',14, 'FontWeight','Normal');
        ylabel('Accuracy','FontSize',14);
        xlim([x_index(1) x_index(end)])
        
        if (options.log_grid ==1)
                set(gca,'xscale','log')
                x_range = options.param_ranges;
                set(gca, 'XTick', options.param_ranges)
                set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
        end
        
        
        ylim([min(stats.test.acc.mean)*3/4 max(stats.train.acc.mean)*1.1])
        legend({'Test','Train'},'FontSize',14);       
        title(title_name,'FontSize',14, 'FontWeight','Normal');
        axis square
        box on; 
        grid on;
        
        
        subplot(1,2,2)
        
        errorbar(x_index,stats.test.fmeasure.mean,stats.test.fmeasure.std,'-rs'); hold on;
        errorbar(x_index,stats.train.fmeasure.mean,stats.train.fmeasure.std,'-gs');
        
        xlabel(options.param_names, 'FontSize',14, 'FontWeight','Normal');
        ylabel('F-Measure','FontSize',14);
        xlim([x_index(1) x_index(end)])
        if (options.log_grid ==1)
            set(gca,'xscale','log')
            x_range = options.param_ranges;
            set(gca, 'XTick', options.param_ranges)
            set(gca,'XTickLabel', cellstr(num2str(x_range(:), '%4.2f')))
        end
        
        ylim([min(stats.test.fmeasure.mean)*3/4 max(stats.train.fmeasure.mean)*1.1])
        legend({'Test','Train'},'FontSize',14);       
        title(title_name,'FontSize',14, 'FontWeight','Normal');
        axis square
        box on; 
        grid on;


end


end

