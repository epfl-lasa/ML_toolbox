classdef LinearRegression < handle
  %LINEARREGRESSION Performs linear regression for regression or (via an
  % indicator matrix) classification problems.
  %
  % a = LINEARREGRESSION creates a linear regression learner which will
  % adaptively select the type of solution based on two factors: If the
  % number of target values in the training data exceeds 10 or any of the
  % target values are non-integer, then regression learning will be used,
  % otherwise classification will be.
  %
  % a = LINEARREGRESSION('PARAM1', val1,...) creates a linear regression
  % learner will various parameters set.
  %
  %   'output_type':    One of 'any', 'classification', 'regression'. For
  %                     'any', the default behaviour occurs. For
  %                     'classification' and 'regression', the learner acts
  %                     in classification and regression modes
  %                     respectively.
  %
  % See also LINEARREGRESSION/TRAIN LINEARREGRESSION/TEST
    
  properties
    
    B_hat;
    output_type;
    output_map;
    
  end
  
  methods
    
    function a = LinearRegression(varargin)
      p = inputParser;
      p.addOptional('output_type', 'any', ...
        @(x)any(strcmpi(x, {'any','classification','regression'})));
      
      p.parse(varargin{:});
      a.output_type = p.Results.output_type;
      
    end
    
    function train(a, inputs, outputs, output_map)
      %TRAIN trains the learner using the supplied input/output training
      %data.
      %
      % a = TRAIN(inputs, outputs) Accepts two parameters - an NxM input matrix
      % containing N examples, each with M features, and an Nx1 output
      % vector with labels that correspond to each input example.
      %
      % For regression problems, the coefficient matrix B_hat is computed
      % simply using (X'X) \ (X'Y), where X and Y are inputs and outputs
      % respectively. X is first augmented with a leading feature of all
      % 1s, thus making B_hat an (M+1)x1 vector.
      %
      % For classification problems, the outputs are converted into an NxK
      % matrix where K is the number of classes, and each row contains a
      % single 1 when the index of the column corresponds to the class
      % (Classes are translated to a 1-base linear index vector
      % output_map).
      %
      % The output is the trained linear regression learner.
      %
      % See also LINEARREGRESSION LINEARREGRESSION/TEST
      
      if (strcmpi(a.output_type, 'any'))
        if (numel(unique(outputs)) > 10 || sum(mod(outputs, 1)) ~= 0)
          a.output_type = 'regression';
        else
          a.output_type = 'classification';
        end
      end
      
      if (strcmpi(a.output_type, 'classification'))
        if (nargin < 4)
          a.output_map = unique(outputs);
        else
          a.output_map = output_map;
        end
        %To translate a single label into a 1xK indicator array, extend the
        %Nx1 labels into an NxK matrix and test for equality with an extended
        %1xK output map, containing the duplicated output value of each column
        %in every row.
        outputs = repmat(outputs, 1, numel(a.output_map)) == ...
          repmat(a.output_map', numel(outputs), 1);
      end
      
      %The input matrix is prepended with a column of 1s to provide a bias
      %value. This makes the hat matrix N+1x1 or N+1xK, i.e. it represents
      %a hyperplane in one more than the number of dimensions in the
      %input space.
      inputs = [ones(size(inputs, 1), 1) inputs];
      %The hat matrix is derived from the derivative of the residual sum of
      %squares: RSS(B) = sum(y_i - x_i'B)^2
      %In matrix notation RSS(B) = (y - XB)'(y - XB)
      %With the derivative X'(y - XB) = 0 at the stationary points.
      %Rearrange for B: B = (X'X) \ X'y, and B can be used to produce
      %predictions of y from X: Y_hat = XB
      a.B_hat = (inputs' * inputs) \ (inputs' * outputs);
      
    end
    
    function outputs = test(a, inputs)
      %TEST predicts the output values of some data using the trained
      % coefficient matrix.
      %
      % outputs = TEST(inputs) prepends the NxM inputs matrix with an Nx1
      % vector of 1s, and multiplies by the coefficient matrix to make an
      % Nx1 prediction on the output values (or in the case of
      % classification learning, an NxK prediction). For classification
      % learning, this is converted into the original output alphabet prior
      % to returning.
      %
      % See also LINEARREGRESSION LINEARREGRESSION/TRAIN
      
      outputs = [ones(size(inputs, 1), 1) inputs] * a.B_hat;
      
      if (strcmpi(a.output_type, 'classification'))
        [v i] = max(outputs, [], 2);
        outputs = a.output_map(i);
      end
      
    end
    
    function margins = margins(a, inputs)
      
      outputs = [ones(size(inputs, 1), 1) inputs] * a.B_hat;
      margins = abs(outputs(:, 1) - outputs(:, 2));
      
    end
    
  end
  
end

