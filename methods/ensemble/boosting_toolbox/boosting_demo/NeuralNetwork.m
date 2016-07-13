classdef NeuralNetwork < handle
    
    properties
        
        nn;
        options;
        
    end
    
    methods
        
        function a = NeuralNetwork(hiddenunits, lrate, inputs, activation, epochs)
          %Number of hidden units, learning rate, number of inputs,
          %activation function (linear, logistic or softmax).
            a.nn = mlp(inputs, hiddenunits, 1, activation);
            a.options = zeros(14, 1);
            a.options(1) = -1;%Supress outputs
            a.options(2) = 0.001;%x precision
            a.options(3) = 0.001;%objective function precision
            a.options(7) = 0;%Line minimisation (1 = line minimiser, 0 = learning rate)
            a.options(14) = epochs;%iterations per example
            a.options(17) = 0.5;%Momentum
            a.options(18) = lrate;%Learning rate
        end
        
        function a = train(a, inputs, outputs)
          
          [a.nn a.options] = netopt(a.nn, a.options, inputs, outputs, 'graddesc');
            
        end
        
        function outputs = test(a, inputs)
          
            outputs = ssign(mlpfwd(a.nn, inputs));
            
        end
        
    end
    
end