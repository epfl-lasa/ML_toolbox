classdef DataGen
  %DATAGEN Various artificial data generation methods.
  
  methods (Static=true)
    
    function [input output] = gaussian_single(means, stds, label)
      input = normrnd(means, stds);
      output = label;
    end
    
    function [inputs outputs] = gaussians(varargin)
      %GAUSSIANS Creates any number of multi-dimensional gaussian clusters,
      %and labels each cluster from 1 to K.
      %
      % GAUSSIANS(examples, mean1, std1, mean2, std2,...)
      %   Examples is the number of examples to generate (the number of
      %   classes must divide this exactly). The number of classes is
      %   implied by the number of following arguments. Each mean argument
      %   is a 1xM array of means, and each std argument is a 1xM array of
      %   standard deviations. The data is sampled using normrnd, and
      %   returned as an NxM matrix of inputs and an Nx1 vector of labels
      %   (labels are processed by DATAGEN/TIDYCLASSES)
      %
      % See also DATAGEN

      examples = varargin{1};
      classes = (nargin - 1) / 2;
      if (mod(examples, classes) ~= 0)
        disp('Error, examples must be a multiple of classes');
      end
      features = numel(varargin{2});
      examples_per_class = floor(examples / classes);

      inputs = reshape(permute(reshape(cell2mat(arrayfun(@(x)normrnd(repmat(varargin{x * 2}, examples_per_class, 1), ...
        repmat(varargin{(x * 2) + 1}, examples_per_class, 1), ...
        examples_per_class, features), 1:classes, 'UniformOutput', false)), ...
        examples_per_class, features, classes), [3 1 2]), examples, features);
      outputs = repmat((1:classes)', examples_per_class, 1);
      
      outputs = DataGen.tidy_classes(outputs);
      
    end
    
    function [inputs outputs] = checkerboard(count, box_width, tile_width, rotation)
      %A rotated checkerboard dataset
      
      inputs = reshape(arrayfun(@(x)(rand * box_width) - (box_width/2), 1:(count * 2)), count, 2);
      rot_mat = [cos(rotation) -sin(rotation); sin(rotation) cos(rotation)];
      outputs = ssign(double(feval(@(x)x(:, 1) == x(:, 2), mod(floor((rot_mat * inputs')' ./ tile_width), 2))));
      
    end
    
    function [inputs outputs] = circle(count, radius, class_prop)
      %A circle dataset
      
      rots = rand(count, 1) * 2 * pi;
      inputs = repmat(sqrt(rand(count, 1)) .* radius, 1, 2) .* [cos(rots) sin(rots)];
      outputs = ssign((inputs(:, 1).^2 + inputs(:, 2).^2) < class_prop*radius.^2);
      
    end
    
    function outputs = tidy_classes(outputs)
      %Class labels should be sequential natural numbers, or (for 2-class)
      %1 and -1.
      
      if (numel(unique(outputs)) == 2)
        outputs(outputs == min(outputs)) = -1;
        outputs(outputs ~= -1) = 1;
      end
      
    end
    
    function inputs = normalize(inputs)
      %Make the input data be 0-mean with a standard deviation of 1.
      
      inputs = inputs - repmat(mean(inputs), size(inputs, 1), 1);
      inputs = inputs ./ repmat(std(inputs), size(inputs, 1), 1);
      
    end
    
  end
  
end

