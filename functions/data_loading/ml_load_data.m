function [X,labels,class_names] = ml_load_data(filename,format,label_j)
%ML_LOAD_DATA Loads a data set in which the rows are samples and the
%columns are features/dimensions. The last column should contain the class
%label. If not specified 
%
%
%
%   input -----------------------------------------------------------------
%
%       o filename : string,   path to file
%
%       o formate  : string,  [.txt,.csv,...]
%
%       o label_j  : (1 x 1), column index which containts the class labels
%
%   output ----------------------------------------------------------------
%
%       o X         : (N x D), dataset of N samples of dimension D
%
%       o labels    : (N x 1), N labels 
%

data = [];
if ~exist('label_j','var'), label_j = []; end

if strcmp(format,'csv') == true

   data = readtable(filename);

elseif strcmp(format,'txt') == true
   
    data = load(filename);
else
   warning(['No such format: ' froamt ' implemented!']); 
end
    
if isempty(label_j)
   X = data;
else
    
    
    
   X            = table2array(data(:,1:end-1));
   labels       = table2array(data(:,end));
   class_names  = unique(labels);
   
   
   % if data is string convert to numbers
   if iscellstr(X) == true
      x_unique   = unique(X);
      cellfind   = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
      X_tmp      = zeros(size(X));
   %   bUnknown   = false;
      
   %   if sum(cellfun(cellfind('?'),x_unique)) == true, bUnknown=true;end
      
      v = 0;
      for i=1:length(x_unique)
          
          
           idx = cellfun(cellfind(x_unique{i}),X);        
          
           if strcmp(x_unique{i},'?') == true
               X_tmp(idx) = -1;
           else
               X_tmp(idx) = v;
               v          = v + 1;
           end          
      end
      
        X = X_tmp;
   end
   
   
   % if labels are strings convert them to numbers
   if iscellstr(class_names) == true
       labels_tmp = zeros(size(labels,1),1);
       cellfind   = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
       
       for i=1:size(class_names,1)
           idx              = cellfun(cellfind(class_names{i}),labels);            
           labels_tmp(idx)  = i;
       end
       
       labels = labels_tmp;
       
   end
   
   
end

end




