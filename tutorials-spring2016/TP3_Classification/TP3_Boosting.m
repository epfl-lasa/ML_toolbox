%% TP3 Boosting (AdaBoost)

clear all; close all;

%% Generate Circle Data

num_samples     = 100;
dim_samples     = 2;
num_classes     = 2;
[X,labels]      = ml_circles_data(num_samples,dim_samples,num_classes);
labels          = ml_2binary(labels);

angle=rand(200,1)*2*pi; l=rand(200,1)*40+30; blue=[sin(angle).*l cos(angle).*l];
angle=rand(200,1)*2*pi; l=rand(200,1)*40;    red=[sin(angle).*l cos(angle).*l];

 % All the training data
X=[blue;red];
labels(1:200)=-1; 
labels(201:400)=1;

%% Plot Data

plot_options            = [];
plot_options.is_eig     = false;
plot_options.labels     = labels;
plot_options.title      = 'Original Data';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% Ada-boost One iteration

[classestimate,model,D]= adaboost_classifier(X,labels,50,[]);
f                      = @(X)adaboost_classifier(X,[],[],model);

%% Plot strong classifier sign[C(x)]

c_options         = [];
plot_data_options = [];

c_options.title   = ['AdaBoost  ' num2str(length(model)) ' models'];
plot_data_options.weights = ml_scale(D,1,50);

if exist('hc','var') && isvalid(hc), delete(hc);end
hc = ml_plot_classifier(f,X,labels,c_options,plot_data_options);
axis tight

%% Plot non-signed value of strong classifier C(x)

options = [];
options.dim = [1,2];
if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_ada_model(X,labels,model,options);


%% Grid search AdaBoost with CV

% range of number of weak classifiers (decision stumps) 
range_weak_c = [1,10,20,30,40,50,60,70,80,90,100];

% K-fold CV parameter
K = 10;

% Store results
ctest  = cell(K,1);
ctrain = cell(K,1);

disp('Grid search AdaBoost');
disp('...');
num_para = length(range_weak_c);
for i=1:num_para
    disp([num2str(i) '/' num2str(num_para)]);
    
    f = @(X,labels,model)adaboost_classifier(X,labels,range_weak_c(i),model);
    [test_eval,train_eval] = ml_kcv(X,labels,K,f);
    
    ctest{i}  = test_eval;
    ctrain{i} = train_eval;
    
end

%% Get CV statistics

stats = ml_get_cv_grid_states(ctest,ctrain);

%% Plot CV statistics

cv_plot_options        = [];
cv_plot_options.title   = [num2str(K) '-fold CV'];

if exist('hcv','var') && isvalid(hcv), delete(hcv);end
hcv = ml_plot_cv_grid_states(stats,cv_plot_options);

hAllAxes            = findobj(gcf,'type','axes');
hAllAxes.XTick      = 1:11;
hAllAxes.XTickLabel = strread(num2str(range_weak_c),'%s');



