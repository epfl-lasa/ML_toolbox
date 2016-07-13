classdef CART < handle
  
  properties
    
    tree;
    
  end
  
  methods
    
    function a = CART()
      %Wrapper on the matlab classregtree function
      
    end
    
    function train(a, inputs, outputs)
      %Apparently log(N) is a good value for 'minparent' (Breiman says so).
      a.tree = classregtree(inputs, outputs == 1, 'minparent', floor(log(numel(outputs))));
      
    end
    
    function outputs = test(a, inputs)
      
      outputs = (str2num(cell2mat(a.tree.eval(inputs))) * 2) - 1; %#ok<ST2NM>
      
    end
    
    function margins = margins(a, inputs)
      
      [outputs nodes] = a.tree.eval(inputs);
      margins = ((str2num(cell2mat(outputs)) * 2) - 1) .* max(a.tree.classprob(nodes), [], 2); %#ok<ST2NM>
      
    end
    
  end
  
end

