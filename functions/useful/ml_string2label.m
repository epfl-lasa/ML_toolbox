function [labels,classes] = ml_string2label(strings)
%ML_STRING2LABEL Converts a cell array of strings to a num array of labels.
%
%   input -----------------------------------------------------------------
%
%       o strings : cell(N x 1), cell array of string labels
%
%   output ----------------------------------------------------------------
%
%       o labels :  (N x 1), numerical array of class labels
%   
%       o classes: cell(num_classes x 1), array of unique class names 
%


classes = unique(strings);
labels  = zeros(size(strings,1),1);

for i=1:size(classes,1)
   
  idx    = ismember(strings,classes{i});  
  labels(idx) = ones(sum(idx(:)),1) .* i;
 
end


end

