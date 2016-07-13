%% Gaussian Process Regression example from the gpml toolbox
clear all;
%% Generate some data

nbSamples   = 100;
epsilon     = 0.2;
X           = linspace(0,50,nbSamples);
y           = sin(X*0.2) + normrnd(0,0.2,1,nbSamples);

X           = X(:);
y           = y(:);

% Make hole in Data

id    = (X > 20 & X < 30);
X(id) = [];
y(id) = [];

% Plot data
options             = [];
options.points_size = 10;
options.title       = 'noisy sinusoidal data'; 

if exist('h1','var') && isvalid(h1), delete(h1);end
h1      = ml_plot_data([X(:),y(:)],options);

%% Train GP [gpml toolbox]

meanfunc = {@meanZero};
covfunc  = {@covSEiso}; 

ell      = 10;  % kernel width of RBF covariance function.
sf       = 1;   % signal variance (not measurement noise)
sn       = 0.0001; % measurement noise


hyp      = [];
hyp.cov  = log([ell; sf]);
hyp.lik  = log(sn);


% Test GP [gpml toolbox]

X_test = linspace(0,50,200)';


[m,s2] = gp(hyp, @infExact, meanfunc, covfunc, @likGauss, X, y, X_test);

if exist('h2','var') && isvalid(h2), delete(h2);end
h2 = figure;

f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)];
fill([X_test; flipdim(X_test,1)], f, [7 7 7]/8);
hold on;

options             = [];
options.no_figure   = true;
options.points_size = 10;
ml_plot_data([X(:),y(:)],options);



