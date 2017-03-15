%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Locally Weighted Regression 1D Example  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          1) Generate 1D Regression Datasets                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate Example Data
clear all; close all; clc;
nbSamples = 120;
X         = linspace(0,100,nbSamples)';
y         = sin(X*0.05) + normrnd(0,0.1,1,nbSamples)';


options             = [];
options.points_size = 10;
options.title       = 'noisy sinusoidal data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 2) "Train" LWR Model                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train LWR
lwr_options         = [];
lwr_options.dim     = 1;
lwr_options.D       = 0.1;
lwr_options.K       = 100;
lwr                 = LWR(options);
lwr.train(X,y);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           3) Test LWR Model on Train points                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Test (Prediction) & Plot test result
options             = [];
options.points_size = 10;
options.title       = 'Locally Weighted Regression';

% Plot original data
if exist('h2','var') && isvalid(h2), delete(h2);end
ml_plot_data([X(:),y(:)],options);

% Plot regression function on top
hold on;
Xtest = X(1:1:end,:);
ytest = lwr.f(Xtest);
plot(Xtest,ytest,'-k','LineWidth',2);

%% Plot the value of LWR and linear function at a few chosen samples
nbSamples = 10;
Xtest     = linspace(10,90,nbSamples)';
ytest     = lwr.f(Xtest);

hold on;
points = 3;
for i=1:nbSamples

    [ytest,W,B]     = lwr.f(Xtest(i));
    
    xs = (Xtest(i)-points):0.1:(Xtest(i)+points);
    ys = B' * [xs;ones(1,length(xs))];

    plot(Xtest(i),ytest,'or','MarkerFaceColor',[1 0 0]);
    plot(xs,ys,'-r','LineWidth',2);

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           4) Grid Search for LWR with RBF Kernel           %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% K-fold cross validation 
Kfold = 20;

disp('Parameter grid search LWR');

rbf_vars = [0.01,0.1,1,2,5,10,20,40,50,100];

test  = cell(length(rbf_vars),1);
train = cell(length(rbf_vars),1);

lwr_options         = [];
lwr_options.dim     = 1;
lwr_options.K       = 100;

for i=1:length(rbf_vars)
    disp(['[' num2str(i) '/' num2str(length(rbf_vars)) ']']);
    
    lwr_options.D           = rbf_vars(i);
    
    f                       = @(X,y,model)ml_lwr(X,y,model,lwr_options);
    [test_eval,train_eval]  = ml_kcv(X,y,Kfold,f,'regression');
    
    
    test{i}                 = test_eval;
    train{i}                = train_eval;
    disp(' ');
end

%% Get Statistics
[ stats ] = ml_get_cv_grid_states_regression(test,train);

%% Plot Statistics
options             = [];
options.title       = 'LWR k-CV';
options.metrics     = {'nrmse'};     % <- you can add many other metrics, see list in next cell box
options.para_name   = 'variance rbf';

if exist('handle','var'), delete(handle); end
[handle,handle_test,handle_train] = ml_plot_cv_grid_states_regression(stats,rbf_vars,options);


%% Full list of evaluation metrics for regression methods
options.metric = {'mse','nmse','rmse','nrmse','mae','mare','r','d','e','me','mre'};

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



