% DATASET GENERATION
%
% This file generates different 3D datasets (the code name is specified inside the brackets) :
%  - spheric (sphere)
%  - spheric with hole (sphere_hole)
%  - swiss roll (swissroll)
%  - swiss roll with hole (swissroll_hole)
%  - broken swiss roll (swissroll_broken)
%  - S curve (scurve)
%  - S curve with hole (scurve_hole)
%  - S curve with mixed density (scurve_mixed_density)
%  
% Usage: [dataset, labels, updated_N, cmap] = generate_dataset(dataset_options)
%   Input Parameters:
%       Mandatory: dataset_options.name             = name of the dataset
%       Mandatory: dataset_options.numberOfPoints   = number of points of the dataset chosen (the holes remove some points)
%       Optional:  dataset_options.classes          = number of desired classes. If number of classes is not passed 1 is assumed
%       Optional:  dataset_options.plot             = specifies if plot will be shown. Can be true or false
%       Optional:  dataset_options.labels           = specifies if automatic labels will be added to the dataset, acoording to number of classes
%
%   Specific parameters for Swissroll with hole
%       dataset_options.x_hole_start = the starting x of the hole
%       dataset_options.x_hole_end = the final x of the hole
%       dataset_options.y_hole_start = the starting y of the hole
%       dataset_options.y_hole_end = the final y of the hole
%       dataset_options.z_hole_start = the starting z of the hole
%       dataset_options.z_hole_end = the final z of the hole
%       Note: if a hole parameter is missing it will not be checked. If all the parameters are missing, no hole will be generated
%
%   Output:
%       dataset = 3D array of points
%       labels  = array of labels for each points, according to the number of classes
%       updated_N = updated number of points
%       cmap = colormap used for the dataset, useful to compare plots after executing a dimensionality reduction algorithm
%
% Authors: 
% Alberto Arrighi   (alberto.arrighi@epfl.ch)
% Ilaria Lauzana    (ilaria.lauzana@epfl.ch)
% Ludovico Novelli  (ludovico.novelli@epfl.ch)
%
% From Spring Semester Advanced Machine Learning Mini-Project
% Ecole Polytechnique Federale de Lausanne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dataset, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options)


    if ~isfield(dataset_options,'name')
        error('Missing dataset name!');
    end

    if ~isfield(dataset_options,'numberOfPoints')
        error('Missing dataset numberOfPoints!');
    end

    if ~isfield(dataset_options,'classes')
        disp('Number of classes missing, 1 class only is assumed')
        dataset_options.classes = 1;
    end

    if ~isfield(dataset_options,'plot')
        disp('Plot parameter missing, plot will not be generated')
        dataset_options.plot = false;
    end
    
    if ~isfield(dataset_options,'labels')
        disp('Labels missing, will be automatically generated')
        dataset_options.labels = false;
    end

    name = dataset_options.name;
    N = dataset_options.numberOfPoints;

    switch name

        case 'sphere'
            
            num_samples = N;
            dim_samples = 3;
            num_classes = 1;
            cmap = jet(num_samples);

            [dataset,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);

            dataset = sortrows(dataset,3);
        
        case 'sphere_hole'
            
            num_samples = N;
            dim_samples = 3;
            num_classes = 1;

            [dataset,labels]  = ml_circles_data(num_samples,dim_samples,num_classes);

            counter = 0;
            for i=N:-1:1
               if (dataset(i,3)>0.01)
                   dataset(i,:) = [];
                   counter = counter+1;
               end
            end
            
            N = N-counter;
            cmap = jet(N);
            dataset = sortrows(dataset,3);

        case 'swissroll'
            t = rand(1,N);
            t = sort(4*pi*sqrt(t))'; 
            %t = t([1:2000, 2100:end]);

            %t = sort(generateRVFromRand(2^11,@(x)1/32/pi^2*x,@(x)4*pi*sqrt(x)))';
            z = 8*pi*rand(N,1); % random heights
            x = (t+.1).*cos(t);
            y = (t+.1).*sin(t);
            dataset = [x,flip(z),y]; % data of interest is in the form of a n-by-3 matrix

        case 'swissroll_hole'
            
            %dataset_options.x_hole_start               = 5;
            dataset_options.x_hole_end                 = -4.5;
            dataset_options.y_hole_start               = -10;
            dataset_options.y_hole_end                 = 10;
            dataset_options.z_hole_start               = 8.5;
            dataset_options.z_hole_end                 = 16.5;
            
            t = rand(1,N);
            t = sort(4*pi*sqrt(t))'; 
            %t = t([1:2000, 2100:end]);

            %t = sort(generateRVFromRand(2^11,@(x)1/32/pi^2*x,@(x)4*pi*sqrt(x)))';
            z = 8*pi*rand(N,1); % random heights
            x = (t+.1).*cos(t);
            y = (t+.1).*sin(t);

            if isfield(dataset_options,'x_hole_start') && isfield(dataset_options,'x_hole_end')
                x_hole = (x>dataset_options.x_hole_start) & (x<dataset_options.x_hole_end);
            elseif isfield(dataset_options,'x_hole_start')
                x_hole = x>dataset_options.x_hole_start;
            elseif isfield(dataset_options,'x_hole_end')
                x_hole = x<dataset_options.x_hole_end;
            else
                x_hole = zeros(N, 1);
            end

            if isfield(dataset_options,'y_hole_start') && isfield(dataset_options,'y_hole_end')
                y_hole = (y>dataset_options.y_hole_start) & (y<dataset_options.y_hole_end);
            elseif isfield(dataset_options,'y_hole_start')
                y_hole = y>dataset_options.y_hole_start;
            elseif isfield(dataset_options,'y_hole_end')
                y_hole = y<dataset_options.y_hole_end;
            else
                y_hole = zeros(N, 1);
            end

            if isfield(dataset_options,'z_hole_start') && isfield(dataset_options,'z_hole_end')
                z_hole = (z>dataset_options.z_hole_start) & (z<dataset_options.z_hole_end);
            elseif isfield(dataset_options,'z_hole_start')
                z_hole = z>dataset_options.z_hole_start;
            elseif isfield(dataset_options,'z_hole_end')
                z_hole = z<dataset_options.z_hole_end;
            else
                z_hole = zeros(N, 1);
            end

            holes = ~(x_hole.*y_hole.*z_hole);
            x = x .* holes; x=x(x~=0);
            y = y .* holes; y=y(y~=0);
            z = z .* holes; z=z(z~=0);
            N = sum(holes);
            dataset = [x,z,y]; % data of interest is in the form of a n-by-3 matrix

        case 'swissroll_broken'
            if ~exist('ml_brokenswiss_example.mat', 'file')
                error('File <ml_brokenswiss_example.mat> doesn not exist!');
            end
            load('ml_brokenswiss_example.mat');
            N = size(X, 1);
            dataset_options.labels=labels;
            %dataset = [X(1:250,1), sort(X(1:250,2)), X(1:250,3)];
            %dataset = [dataset; X(251:500,1), sort(X(251:500,2)), X(251:500,3)];
            dataset = X;

        case 'scurve'  
            angle = pi*(1.5*rand(1,N/2)-1); height = 5*rand(1,N);
            angle = sort(angle);
            angle_lr = fliplr(angle);
            dataset = [[cos(angle), -cos(angle_lr)]; height;[ sin(angle), 2-sin(angle_lr)]]';

        case 'scurve_hole'
            angle = pi*(1.5*rand(1,N/2)-1);
            height = 5*rand(1,N);
            x = [cos(angle), -cos(angle)]';
            y = [sin(angle), 2-sin(angle)]';
            z = height';

            if isfield(dataset_options,'x_hole_start') && isfield(dataset_options,'x_hole_end')
                x_hole = (x>dataset_options.x_hole_start) & (x<dataset_options.x_hole_end);
            elseif isfield(dataset_options,'x_hole_start')
                x_hole = x>dataset_options.x_hole_start;
            elseif isfield(dataset_options,'x_hole_end')
                x_hole = x<dataset_options.x_hole_end;
            else
                x_hole = zeros(N, 1);
            end

            if isfield(dataset_options,'y_hole_start') && isfield(dataset_options,'y_hole_end')
                y_hole = (y>dataset_options.y_hole_start) & (y<dataset_options.y_hole_end);
            elseif isfield(dataset_options,'y_hole_start')
                y_hole = y>dataset_options.y_hole_start;
            elseif isfield(dataset_options,'y_hole_end')
                y_hole = y<dataset_options.y_hole_end;
            else
                y_hole = zeros(N, 1);
            end

            if isfield(dataset_options,'z_hole_start') && isfield(dataset_options,'z_hole_end')
                z_hole = (z>dataset_options.z_hole_start) & (z<dataset_options.z_hole_end);
            elseif isfield(dataset_options,'z_hole_start')
                z_hole = z>dataset_options.z_hole_start;
            elseif isfield(dataset_options,'z_hole_end')
                z_hole = z<dataset_options.z_hole_end;
            else
                z_hole = zeros(N, 1);
            end

            holes = ~(x_hole.*y_hole.*z_hole);
            x = x .* holes; x=x(x~=0);
            y = y .* holes; y=y(y~=0);
            z = z .* holes; z=z(z~=0);
            N = sum(holes);
            dataset = [x,y,z]; % data of interest is in the form of a n-by-3 matrix

        case 'scurve_mixed_density'

            % Create first part of S-curve at lower density
            N1 = ceil(N/4)*2;
            angle = pi*(1.5*rand(1,N1/2)-1); height = 5*rand(1,N1);
            angle = sort(angle);
            angle_lr = fliplr(angle);
            X1 = [[cos(angle), -cos(angle_lr)]; height;[ sin(angle), 2-sin(angle_lr)]];
            X1 = X1(:,1:(N1/2));
            N1 = size(X1,2);

            % Create second part of S-curve at higher density
            N2 = floor(N/4*3) * 2;
            angle = pi*(1.5*rand(1,N2/2)-1); height = 5*rand(1,N2);
            angle = sort(angle);
            angle_lr = fliplr(angle);
            X2 = [[cos(angle), -cos(angle_lr)]; height;[ sin(angle), 2-sin(angle_lr)]];
            X2 = X2(:,(N2/2)+1:end);
            N2 = size(X2,2);

            % Join two parts
            N = N1 + N2;
            dataset = [X1 X2]';

        otherwise
            error('The Dataset specified is unknown');
    end
    
    updated_N = N;
    cmap = jet(N);

    % assign labels
    if dataset_options.labels == false
        labels = zeros(N, 1);
        for i = 1:N
            labels(i)=ceil(i*dataset_options.classes/N);
        end
    
        % plot if asked
        if exist('dataset', 'var') && dataset_options.plot == true
            figure
            scatter3(dataset(:,1), dataset(:,2), dataset(:,3), 12, cmap);
            xlabel('x','FontSize',14)
            ylabel('y','FontSize',14)
            zlabel('z','FontSize',14)
            colormap(jet);
            colorbar;
        end
    else
        if exist('dataset', 'var') && dataset_options.plot == true
            figure
            for i=1:(size(labels,1)/2)
                cmap(i,:) = cmap(1,:);
                cmap(i+N/2,:) = cmap(size(cmap,1),:);
            end
            scatter3(dataset(:,1), dataset(:,2), dataset(:,3), 12, cmap);
            xlabel('x','FontSize',14)
            ylabel('y','FontSize',14)
            zlabel('z','FontSize',14)
        end
    end

end


