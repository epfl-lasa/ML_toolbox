function [ h ] = ml_plot_rss_aic_bic(mus,stds,Ks, varargin)
%ML_PLOT_RSS_AIC_BIC 
%
%   input -----------------------------------------------------------------
%
%       o mus   : (3 x |Ks|),   mean values of rss, aic and bic
% 
%       o stds  : (3 x |Ks|),   standard deviation of rss, aic and bic
%
%       o Ks    : (1 x M),      set of clusters to try
%
%   output ----------------------------------------------------------------
%
%       o h     : handle,      figure handle
%

plot_type = 'together';

if length(varargin)>0
    options = varargin{1};
    plot_type = options.plot_type;
end


h = figure; hold on;
if strcmp(plot_type,'seperate')
    subplot(1,2,1)
    errorbar(Ks,mus(1,:),stds(1,:),'--s');
    legend('rss');
    set(gca,'xtick',Ks);
    xlim([Ks(1),Ks(end)]);
    grid on;
    box on;
    set(gca,'FontSize',14);
    title('Clustering metrics', 'Interpreter','Latex');
    xlabel('K');
    
    
    subplot(1,2,2)
    errorbar(Ks,mus(2,:),stds(2,:),'--s'); hold on;
    errorbar(Ks,mus(3,:),stds(3,:),'--s');
    legend('aic','bic');
else
    errorbar(Ks,mus(1,:),stds(1,:),'--s');
    errorbar(Ks,mus(2,:),stds(2,:),'--s');
    errorbar(Ks,mus(3,:),stds(3,:),'--s');
    legend('rss','aic','bic');
end
set(gca,'xtick',Ks);
xlim([Ks(1),Ks(end)]);
grid on;
box on;
set(gca,'FontSize',14);
title('Clustering metrics', 'Interpreter','Latex');
xlabel('K');


end

