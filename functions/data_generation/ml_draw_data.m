%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    DEMO SCRIPT FOR USING ML_TOOLBOX DRAWING GUI  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, labels] = ml_draw_data()
%% Bring up Drawing GUI
clear all; close all;
limits = [-50 50 -50 50];
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

h1 = ml_plot_data(X',plot_options);
xlim(limits(1:2)); ylim(limits(3:4))
end