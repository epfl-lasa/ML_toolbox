classdef Stump < handle
  
  properties
    
    feature;
    split;
    sig;
    probs;
    
  end
  
  methods
    
    function a = Stump()
      %A decision stump that maximises information gain or something.
    end
    
    function train(a, inputs, outputs)
      
      one_count = sum(outputs == 1);
      outputs(outputs == 1) = numel(outputs) ./ (2 * one_count);
      outputs(outputs == -1) = numel(outputs) ./ (-2 * (numel(outputs) - one_count));
      [sorted ind] = sort(inputs);
      gains = cumsum(feval(@(x)x(ind), repmat(outputs, 1, size(inputs, 2))));
      [gain ind2] = max(abs(gains));
      [gain a.feature] = max(gain);
      col_ind = ind(:, a.feature);
      first_ind = ind2(a.feature);
      next_ind = min(first_ind+1, size(sorted, 1));
      a.split= mean(sorted(first_ind:next_ind, a.feature));
      a.sig = ssign(gains(first_ind, 1));
      a.probs = [a.sig * sum(outputs(col_ind(1:first_ind)) * a.sig > 0) ./ first_ind ...
        -a.sig * sum(outputs(col_ind(next_ind:end)) * -a.sig > 0) ./ (numel(col_ind) - first_ind)];
      a.probs(isnan(a.probs)) = 0;
      
    end
    
    function outputs = test(a, inputs)
      
      outputs = ssign(inputs(:, a.feature) < a.split) .* a.sig;
      
    end
    
    function margins = margins(a, inputs)
      
      margins = a.probs((inputs(:, a.feature) > a.split) + 1)';
      
    end    
    
  end
  
end

