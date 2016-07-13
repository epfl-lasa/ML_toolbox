classdef SVM < handle
  
  properties
    
    svm;
    
  end
  
  methods
    
    function a = SVM()
      %Wrapper on libsvm.
      
    end
    
    function train(a, inputs, outputs)
      
      a.svm = svmtrain(outputs, inputs);
      
    end
    
    function outputs = test(a, inputs)
      
      outputs = svmpredict(ones(size(inputs, 1), 1), inputs, a.svm);
      
    end
    
    function margins = margins(a, inputs)
      
      [guess acc margins] = svmpredict(ones(size(inputs, 1), 1), inputs, a.svm);
      
    end
    
    function [weights theta] = weights(a)
        weights = (a.svm.sv_coef' * full(a.svm.SVs));
        theta = a.svm.rho;
    end
    
  end
  
end

