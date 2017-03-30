function [X,labels] = ml_circles_data(num_samples,dim,num_classes, varargin)
% ML_CIRCLES_DATA Generates data which is in the patter of circles
%
%   input ----------------------------------------------------------------
%
%       o num_samples : (1 x 1), number of data points to generate.
%
%       o dim         : (1 x 1), dimension of the data. [2 or 3]
%
%       o num_classes : (1 x 1), number of classes.
%
%       o options     : struct
%
%
%   output ----------------------------------------------------------------
%
%       o X          : (num_samples x D), number of samples.
%
%       o labels     : (num_samples x 1), class lables of the data.
%
%
%% Hyperparameters

X       = [];
labels  = [];


if length(varargin)>0
    if strcmp(varargin{1},'svm')
        width   = 2.5;
        spacing = 0.5;
        noise_r = 0.25; % variance of noise for the radius
    else
        width   = 2;
        spacing = 0.15;
        noise_r = 0.01; % variance of noise for the radius
    end
else
    width   = 0.75;
    spacing = 2;
    noise_r = 0.5; % variance of noise for the radius
end


% number of data points per class
nb_data_class = floor(num_samples/num_classes);

%% Generate circles
if dim == 2
    r = 0;
    for c=1:num_classes
        if c == 1            
%             r   = mvnrnd(0,0.01,nb_data_class);  
            r   = (0.1 * width) + c * spacing + r + mvnrnd(0,noise_r,nb_data_class);      
        else
            r   = (0.5 * width) + c * spacing + r + mvnrnd(0,noise_r,nb_data_class);      
        end
        phi     = 2 * pi * rand(nb_data_class,1);
        X       = [X;[r .* cos(phi), r .* sin(phi)]];
        labels  = [labels;ones(nb_data_class,1) .* c];
    end
    
elseif dim == 3
    r = 0; 
    for c=1:num_classes
        %r       =  (0.5 * width) + c*spacing + r;

        if c == 1
            r   = 0.1 .* spacing + r;               
        else
            r   =  (0.5 * width) + c*spacing + r;    
        end
        
        phi     =  2 .* pi * rand(nb_data_class,1); %[0; 2pi]
        z       =  rand_r(-r,r,nb_data_class);
        X       =  [X; [ sqrt(r.^2 - z.^2) .* cos(phi), sqrt(r.^2 - z.^2) .* sin(phi), z ]];
        labels  = [labels;ones(nb_data_class,1) .* c];
    end
    
else
    
    warning(['Only dim 2 and 3 supported, you chose [' num2str(dim) ']']);
    % Should implement hypersphere.
    
end


end

function x = rand_r(a,b,num_samples)
    x = a + (b-a) * rand(num_samples,1);
end