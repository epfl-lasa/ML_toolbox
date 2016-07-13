classdef OnlineNaiveBayes < handle
  
  properties
    
    means;
    s_temp;
    std2s;
    counts;
    forward_bias;
    first;
    normpdf = @(x, mu, sigma)exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
    
  end
  
  methods
    
    function a = OnlineNaiveBayes(forward_bias)
      %Naive Bayes with a forward bias for online learning.
      %forward_bias = 0 (default) is standard naive bayes.
      
      if (nargin < 1)
        forward_bias = 0;
      end
      a.forward_bias = forward_bias;
      a.counts = ones(1, 3) * 2;
      a.first = true;
      
    end
    
    function train(a, inputs, outputs)
      
      arrayfun(@(x)a.online_train(inputs(x, :), outputs(x)), 1:size(inputs, 1));
      
    end
    
    function online_train(a, input, output)
      
      if (a.first)
        features = size(input, 2);
        a.means = zeros(3, features);
        a.s_temp = ones(3, features);
        a.std2s = ones(3, features);
        a.first = false;
      end
      output = (output + 3) / 2;
      indices = [output; 3];
      input = repmat(input, 2, 1);
      a.counts(indices) = a.counts(indices) + 1;
      r_counts = repmat(a.counts(indices), size(input, 2), 1)';
      new_means = a.means(indices, :) + ...
        (1 + (a.forward_bias * (a.counts(3) > 5))) .* ...
        (input - a.means(indices, :)) ./ r_counts;
      a.s_temp(indices, :) = a.s_temp(indices, :) + abs((input - a.means(indices, :)) .* (input - new_means));
      a.std2s(indices, :) = sqrt(a.s_temp(indices, :) ./ (r_counts - 1));
      a.means(indices, :) = new_means;
      
    end
    
    function outputs = test(a, inputs)
      
      probs = cell2mat(arrayfun(@(x)prod(a.normpdf(inputs, ...
        repmat(a.means(x, :), size(inputs, 1), 1), ...
        repmat(a.std2s(x, :), size(inputs, 1), 1)), 2) ...
        * (a.counts(x) / a.counts(3)), 1:2, 'UniformOutput', false));
      [v i] = max(probs(:, 1:2), [], 2);
      outputs = (i * 2) - 3;
      
    end
    
    function margins = margins(a, inputs)
      
      probs = cell2mat(arrayfun(@(x)prod(a.normpdf(inputs, ...
        repmat(a.means(x, :), size(inputs, 1), 1), ...
        repmat(a.std2s(x, :), size(inputs, 1), 1)), 2) ...
        * (a.counts(x) / a.counts(3)), 1:2, 'UniformOutput', false));
      [v i] = max(probs(:, 1:2), [], 2);
      margins = ((i * 2) - 3) .* (v ./ sum(probs(:, 1:2), 2));
      
    end
    
    function inputs = generate(a, outputs)
      
      index = (outputs == -1) + 1;
      mean = a.means(index, :);
      std = a.std2s(index, :);
      inputs = normrnd(mean, std);
      
    end
    
  end
  
end

