function [ X, y_true, y ] = ml_load_regression_datasets( dataset_type, varargin )

if length(varargin) > 0
    plot_fig = false;
else
    plot_fig = true;
end

switch dataset_type
    case '1d-linear'
        nbSamples = 100;
        epsilon   = 5;
        x_limits  = [0, 100];

        % Generate True function and data
        X         = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true    = -0.5*X;
        y         = y_true + normrnd(0,epsilon,1,nbSamples);

        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';

        % Plot Datapoints
        if plot_fig==1
            options             = [];
            options.points_size = 20;
            options.labels      = zeros(nbSamples,1);
            options.title       = 'Example 1D Linear Data';
            if exist('h0','var') && isvalid(h0), delete(h0);end
            h0 = ml_plot_data([X(:),y(:)],options); hold on;
            
            % Plot True function
            plot(X,y_true,'-k','LineWidth',2);
            legend({'data','y = f(x)'})
        end
    case '1d-sine'
        
        nbSamples = 75;
        epsilon   = 0.15;
        x_limits  = [0, 100];
        
        % Generate True function and data
        X         = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true    = sin(X*0.05);
        y         = y_true + normrnd(0,epsilon,1,nbSamples);
        
        
        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';
        
        % Plot Datapoints
        if plot_fig==1
            options             = [];
            options.labels      = [];
            options.points_size = 15;
            options.labels      = zeros(nbSamples,1);
            options.title       = 'Example 1D Sine Data';
            if exist('h1','var') && isvalid(h1), delete(h1);end
            h1 = ml_plot_data([X(:),y(:)],options); hold on;
            
            % Plot True function
            plot(X,y_true,'-k','LineWidth',2);
            legend({'data','y = f(x)'})
        end
        
    case '1d-sinc'
        
        % Set parameters for sinc function data
        nbSamples = 200;
        epsilon   = 0.075;
        x_limits  = [-5, 5];
        
        % Generate True function and data
        X = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true = sinc(X);
        y = y_true + normrnd(0,epsilon,1,nbSamples);
        
        
        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';
        
        % Plot Datapoints
        if plot_fig==1
            options             = [];
            options.labels      = [];
            options.points_size = 15;
            options.labels      = zeros(nbSamples,1);
            options.title       = 'Example 1D Sinc Data';
            if exist('h2','var') && isvalid(h2), delete(h2);end
            h2 = ml_plot_data([X(:),y(:)],options); hold on;
            
            % Plot True function
            plot(X,y_true,'-k','LineWidth',2);
            legend({'data','y = f(x)'})
        end
    case '2d-cossine'
        
        % Generate a target function to learn from and visualise
        f       = @(X)sin(X(:,1)).*cos(X(:,2));   % Original Function
        r       = @(a,b,M,N)a + (b-a).*rand(M,N); % Range of Inputs
        M       = 1000;                           % Number of Points
%         X       = r(-4,2,M,2);                    % Input Data
        
        X(:,2)  = r(-4,1,M,1);                    % Input Data
        X(:,1)  = r(-3,3,M,1);                    % Input Data
        
        % Generate Noisy Data from true function
        noise   = 0.15;
        y_true  = f(X);
        y       = y_true + normrnd(0,noise,M,1);
        
        
        % Plot True Function      
        if plot_fig==1
            options           = [];
            options.title = 'Example 2D Non-Linear Training Data';
            options.surf_type = 'surf';
            
            if exist('h1','var') && isvalid(h1), delete(h1);end
            h1 = ml_plot_value_func(X,f,[1 2],options);hold on
            % Plot Noisy Data from Function
            options = [];
            options.plot_figure = true;
            options.points_size = 10;
            options.labels = zeros(M,1);
            options.plot_labels = {'$x_1$','$x_2$','y'};
            
            ml_plot_data([X y],options);
        end

end

