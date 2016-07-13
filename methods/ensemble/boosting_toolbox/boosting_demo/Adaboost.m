classdef Adaboost < handle
  %Adaboost
  
  properties
    
    k_max;
    k_next;
    k_cur;
    part_trains;
    base_learner;
    learners;
    learner_weights;
    early_terminate;
    d_weights;
    d_size;
    
  end
  
  methods
    
    function a = Adaboost(k_max, base_learner, early_terminate)
      %k-max: Size of the model, integer >= 1
      %base_learner: Model constructor function, e.g. @()CART()
      %The model must be an object with methods a.train(inputs, outputs)
      %and outputs = a.test(inputs).
      %early_terminate: Optional, detemines whether to terminate if base
      %learner error is greater than 0.5 (default is to continue, and the
      %base learner receives a negative weight).
      if (nargin < 3)
        early_terminate = false;
      end
      a.k_max = k_max;
      a.part_trains = a.k_max;
      a.k_next = a.k_max;
      a.learners = cell(a.k_max, 1);
      a.learner_weights = zeros(a.k_max, 1);
      a.base_learner = base_learner;
      a.early_terminate = early_terminate;
      a.k_cur = 0;
    end
    
    function part_train(a, inputs, outputs, k_next)
      
      a.k_next = k_next;
      a.train(inputs, outputs);
      a.k_next = a.k_max;
      
    end
    
    function train(a, inputs, outputs)
      
      if (a.k_cur == 0)        
        a.d_size = size(inputs, 1);
        a.d_weights = ones(a.d_size, 1) ./ a.d_size;
      end
            
      while (a.k_cur < a.k_next)
        
        a.k_cur = a.k_cur + 1;
        %Create an NxN square of cumulatively summed weights (i.e. N
        %rows containing the weight cumsum). Create an NxN square of random
        %numbers (N columns containing the same N random numbers). Compare
        %them and sum the rows. The number of weights that are less than
        %each random number indicates the index sampled by that row.
        indices = sum(repmat(cumsum(a.d_weights)', a.d_size, 1) <= ...
          repmat(rand(a.d_size, 1), 1, a.d_size), 2) + 1;
        a.learners{a.k_cur} = a.base_learner();
        a.learners{a.k_cur}.train(inputs(indices, :), outputs(indices));
        
        predictions = a.learners{a.k_cur}.test(inputs) == outputs;
        weighted_error = sum(~predictions .* a.d_weights);
        
        if (a.early_terminate && weighted_error > 0.5)
          a.k_max = a.k_cur - 1;
          a.k_cur = a.k_cur - 1;
          a.learner_weights = a.learner_weights(1:a.k_max);
          break;
        end
        
        weighted_error = min(max(weighted_error, 0.01), 0.99);
        a.learner_weights(a.k_cur) = 0.5 * log((1 - weighted_error) / weighted_error);
        
        a.d_weights = feval(@(x)x./sum(x), a.d_weights .* ...
          exp(-a.learner_weights(a.k_cur) * ssign(predictions)));
        
      end
      
    end
    
    function outputs = test(a, inputs)
      
      outputs = ssign(a.margins(inputs));
      
    end
    
    function margins = margins(a, inputs)
     
      margins = cell2mat(arrayfun(@(x)a.learners{x}.test(inputs), 1:a.k_cur, ...
        'UniformOutput', false)) * (a.learner_weights(1:a.k_cur) ./ sum(abs(a.learner_weights(1:a.k_cur))));
      
    end
    
  end
  
end

