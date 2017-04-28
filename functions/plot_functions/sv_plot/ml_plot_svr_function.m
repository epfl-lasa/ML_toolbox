function [handle]  = ml_plot_svr_function(X, y, model, svr_options)
% ML_PLOT_SVR_FUNCTION plots the training data
%   and decision boundary, given a model produced by LIBSVM for Regression
%   input ----------------------------------------------------------------
%
%       o X            : (N x D), number of input datapoints.
%
%       o y            : (N x 1), number of output datapoints.
%
%       o model     : (1 x 1), number of classes.
%
%       o svr_options   : struct
%
%
%% Plot options and model params for title
switch svr_options.svr_type
    case 0   % epsilon-SVR     
        switch svr_options.kernel_type
            case 0
                title_string = sprintf('$\\epsilon$-SVR + linear kernel: $\\epsilon$ = %g, C =%d, SV = %d', svr_options.epsilon, svr_options.C, model.totalSV);
            case 1
                title_string = sprintf('$\\epsilon$-SVR + poly kernel: $\\epsilon$ = %g, degree = %d, coeff = %d, C =%d, SV = %d', svr_options.epsilon, svr_options.degree, svr_options.coeff, svr_options.C, model.totalSV);
            case 2
                title_string = sprintf('$\\epsilon$-SVR + RBF kernel: $\\epsilon$ = %g, $\\sigma$ = %g, C =%d, SV = %d', svr_options.epsilon, svr_options.sigma, svr_options.C, model.totalSV);
        end
    case 1 % nu-SVR
        switch svr_options.kernel_type
            case 0
                title_string = sprintf('$\\nu$-SVR + linear kernel: $\\nu$ =%g, C = %d, SV = %d, $\\epsilon$ = %g', svr_options.nu, svr_options.C, model.totalSV, svr_options.epsilon);
            case 1
                title_string = sprintf('$\\nu$-SVR + poly kernel: $\\nu$ =%g, degree = %d, coeff = %d, C = %d, SV = %d, $\\hat{\epsilon}$ = %g', svr_options.nu, svr_options.degree, svr_options.coeff, svr_options.C, model.totalSV, svr_options.epsilon);
            case 2
                title_string = sprintf('$\\nu$-SVR + RBF kernel: $\\nu$ =%g, $\\sigma$ = %g, C = %d, SV = %d, $\\epsilon_{est}$ = %g', svr_options.nu, svr_options.sigma, svr_options.C, model.totalSV, svr_options.epsilon);
        end
end

% Plot original data
options             = [];
options.labels      = [];
options.points_size = 15;
options.title       = title_string; 


handle      = ml_plot_data([X(:),y(:)],options);
hold on;

% Plot Support Vectors
plot(X(model.sv_indices),y(model.sv_indices),'ok','LineWidth',2); 

% Plot regression function f(x) and epsilon tube
nbSamples  = 500;
X_regr     = linspace(min(X),max(X),nbSamples)';
y_regr     = svmpredict(randn(length(X_regr),1), X_regr, model);

plot(X_regr,y_regr,'-r','LineWidth',3);

% Plot epsilon tube
plot(X_regr,y_regr + svr_options.epsilon ,'--r', X_regr, y_regr - svr_options.epsilon ,'--r','LineWidth',1);

% Draw legend
switch svr_options.svr_type
    case 0 
        if length(model.sv_indices)==0
            legend({'Train Points', 'f(x)', 'f(x) $\pm$ $\epsilon$', },'Interpreter','LaTex');
        else
            legend({'Train Points','Support Vectors', 'f(x)', 'f(x) $\pm$ $\epsilon$', },'Interpreter','LaTex');
        end
    case 1 
        legend({'Train Points','Support Vectors', 'f(x)', 'f(x) $\pm$ $\epsilon_{est}$', },'Interpreter','LaTex');
end

end

