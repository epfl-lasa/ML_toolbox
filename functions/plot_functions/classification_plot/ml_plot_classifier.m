function handle = ml_plot_classifier(f,X,labels,options,plot_data_options)
%ML_PLOT_CLASSIFIER Plots a classifier function.
%   
%   plots the following:
%   (1) decision boundary.
%   (2) original data.
%   (3) misclassified points (depicted by black cross).
%
%   input -----------------------------------------------------------------
%
%       o f         : function handle, classifier, f.
%                       - y = f(X);  y is a class label.
%
%       o X         : (N x D), dataset of N samples of dimension D.
%
%
%       o labels    : (N x 1), N labels.
%
%
%       o options   : struct, contains various plot options.
%
%               options.title : string, name for title of figure.
%
%
%% Input processing

options.no_figure             = true;
show_misclass                 = true;
plot_data_options.plot_figure = true;
plot_data_options.labels      = labels;


title_name                  = 'No title set, options.title = []';

if isfield(options,'title'),          title_name    = options.title; end
if isfield(options,'show_misclass'),  show_misclass = options.show_misclass; end


%% Ploting

handle = figure; hold on;

%% Plot boundary

% if  dimensions are swaped
ml_plot_class_boundary_2(X,f,options);


%% Plot original data

ml_plot_data(X,plot_data_options);

%% Plot Misclassified points (with cross)
if show_misclass   
    misclassified = ml_get_misclassified(X,labels,f,[]);
    idx           = misclassified.idx;

    hold on;
    plot(X(idx,1),X(idx,2),'kx');
end

%% Figure aspects (Title, etc..)

title(title_name);




end

