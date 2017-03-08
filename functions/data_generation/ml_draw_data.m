%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    DEMO SCRIPT FOR USING ML_TOOLBOX DRAWING GUI  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bring up Drawing GUI
clear all; close all;
limits = [0 100 0 100];
data = ml_generate_mouse_data(limits, 'labels');
close;

%% Extract Labeled Data
X       = data(1:2,:);
labels  = data(3,:);

%% Plot Recorded data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Drawn Dataset';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X',plot_options);