function new_obj = copy_object( obj )
%COPY_OBJECT Summary of this function goes here
%   Detailed explanation goes here

if iscell(obj)
    
    new_obj = cell(size(obj,1),1);
   
    
    for i=1:size(obj,1)
        
        new_obj{i} = feval(class(obj{i}));
        
        % Copy all non-hidden properties.
        p = properties(obj{i});
        for j = 1:length(p)
            new_obj{i}.(p{j}) = obj{i}.(p{j});
        end
       
    end
    
    
else
    
    new_obj = feval(class(obj));
    
    % Copy all non-hidden properties.
    p = properties(obj);
    for i = 1:length(p)
        new_obj.(p{i}) = obj.(p{i});
    end

    
end





end

