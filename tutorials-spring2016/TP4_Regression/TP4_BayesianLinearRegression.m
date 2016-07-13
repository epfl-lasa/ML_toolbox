%% TP4 Regression [Bayesian Linear Regression]

%% Bayesian Linear Regression Example
%% (1) Generate noise line data 

nbSamples = 200;
e_noise   = 0.1;
X         = linspace(0,4,nbSamples)';
w         = [0.5;1];
y         = w' * [X,ones(nbSamples,1)]';
y         = y(:)  + normrnd(0,e_noise,nbSamples,1);

%% (2) Generate a few points

X = [-5, 2, 5]';
y = [-5.5,0.5,4.8]';

%% (3) Generate a few sample points

nbSamples = 4;
e_noise   = 0.5;
X         = linspace(0,4,nbSamples)';
w         = [0.5;1];
y         = w' * [X,ones(nbSamples,1)]';
y         = y(:)  + normrnd(0,e_noise,nbSamples,1);
w_original = w;

%% Plot Training Data
options             = [];
options.points_size = 20;
options.title       = 'Training data'; 
options.labels      = [];

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options);

%% Train Baysian Gaussian Linear regressin

blr_model.e_var             = 1;         % noise variance
blr_model.Sigma_p           = [0.1 0;0 1]; % prior weight variance
[hy,blr_model,Sigma_h]      = ml_blr(X,y,blr_model);
f_blr                       = @(X)ml_blr(X,[],blr_model);

%% Plot Trained BLR

if exist('h2','var') && isvalid(h2), delete(h2); end

h2 = blr_plot_weights(X,y,blr_model);



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %                     
%       Bayesian Linear Regression Vs Least-Squares Regression     %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BLR vs LS (Qualitative) 

% Generate some data points

nbSamples = 2;
e_noise   = 0.5;
X         = linspace(0,4,nbSamples)';
w         = [3;10];
y         = w' * [X,ones(nbSamples,1)]';
y         = y(:)  + normrnd(0,e_noise,nbSamples,1);
w_original = w;

%%
% Compute BLR estimate
blr_model.e_var             = 5;        % noise variance
Sigma_scale                 = 0.001;
blr_model.Sigma_p           = Sigma_scale .* [1 0;0 1]; % prior weight variance


[hy,blr_model,Sigma_h]      = ml_blr(X,y,blr_model);
f_blr      = @(X)ml_blr(X,[],blr_model);

% Compute OLS estimate
[~,ls_model] = ml_ls(X,y,[]);
f_ls         = @(X)ml_ls(X,[],ls_model);


options             = [];
options.points_size = 40;
options.title       = ['BLR vs LS \hspace{0.2cm} $\sigma^2:$ ' num2str(blr_model.e_var ) '\hspace{0.2cm}   $\Sigma_p =$ ' num2str(Sigma_scale) '$\cdot I$'];
if exist('h2','var') && isvalid(h2), delete(h2);end
set(0,'defaulttextinterpreter','latex');
h2      = ml_plot_data([X(:),y(:)],options);

% Plot original function
hold on;
xs = [linspace(0,4,100)',ones(100,1)];
ys = w_original' * xs';
ho = plot(xs(:,1),ys,'-k','LineWidth',2);

% Plot Least-Squares

ls_options = [];
ls_options.bFigure = false;
ls_options.color = [0 0 1];
h_ls = ml_plot_regression(X,f_ls,ls_options);

% Plot BLR

blr_options = [];
blr_options.bFigure = false;
ls_options.color    = [0 1 0];
h_blr = blr_plot(X,f_blr,options);

legend([ho,h_blr.r_line,h_ls.r_line],'Original','BLR','OLS','Location','NorthWest');


%% BLR vs LS Quantitative

%% Effect number of samples have

e_noise             = 0.5; % variance of noise in the signal

blr_model           = [];
blr_model.e_var     = 10;         % noise variance
Sigma_scale         = 100;
blr_model.Sigma_p   = Sigma_scale .* [1 0;0 1]; % prior weight variance


    
max_samples         = 1000;

w_blr               = zeros(2,max_samples-1);
w_ols               = zeros(2,max_samples-1);

for i=2:max_samples

    nbSamples = i;
    X         = linspace(0,4,nbSamples)';
    w         = [3;10];
    y         = w' * [X,ones(nbSamples,1)]';
    y         = y(:)  + normrnd(0,e_noise,nbSamples,1);
    w_original = w;
    
    % learn BLR parameters
    [~,blr_model]      = ml_blr(X,y,blr_model);
    w_blr(:,i-1)         = blr_model.w;
    
    % learn OLS parameters
    [~,ls_model]  = ml_ls(X,y,[]);
    w_ols(:,i-1)    = ls_model.w; 
    
    
end

if exist('h3','var') && isvalid(h3), delete(h3);end
h3 = figure; 
subtightplot(1,2,1,[0.1,0.1]);
hold on; box on; grid on;
plot(ones(max_samples-1,1) .* w_original(1),'-k');
ho = plot(w_blr(1,:),'-r');
hb = plot(w_ols(1,:),'-b');
xlabel('\# data points');
axis square;
title(['$\mathbf{w}_{\mathrm{slope}} = ' num2str(w(1)) '$'],'fontsize',12);
legend([ho,hb],'OLS','BLR');

subtightplot(1,2,2,[0.1,0.1]);
hold on; box on; grid on;
plot(ones(max_samples-1,1) .* w_original(2),'-k');
ho = plot(w_blr(2,:),'-r');
hb = plot(w_ols(2,:),'-b');
xlabel('\# data points');
axis square;
title(['$\mathbf{w}_{\mathrm{intercept}} = ' num2str(w(2)) '$'],'fontsize',12);
legend([ho,hb],'OLS','BLR','Location','SouthEast');


ha = annotation('textbox',[0.35 0.1 0.6 0.2],'String', ['$\epsilon_{\sigma^2} = ' num2str(blr_model.e_var) '\hspace{0.1cm} \Sigma_p = ' num2str(Sigma_scale) '$'],'FitBoxToText','on','Interpreter','latex','FontSize',12);
ha.BackgroundColor = [1 1 1];


 
