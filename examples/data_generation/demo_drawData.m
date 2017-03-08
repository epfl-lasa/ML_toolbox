%% Bring up Drawing GUI
clear all; close all;
limits = [0 100 0 100];
data = ml_generate_mouse_data(limits, 'labels');

%% Extract Labeled Data
X       = data(1:2,:);
labels  = data(3,:);
classes = unique(labels);

%% Visualize Recorded Data
figure('Color', [1 1 1])
colors = hsv(length(classes));
class_names = {};
for i=1:length(classes)
scatter(data(1,labels==classes(i)),data(2,labels==classes(i)),20, colors(i,:), 'Filled'); hold on;
class_names = [class_names strcat('Class ',num2str(classes(i)))];
end
legend(class_names)
xlim(limits(1:2))
ylim(limits(3:end))
grid on;
