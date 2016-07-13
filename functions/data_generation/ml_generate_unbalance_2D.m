function [outputData, outputLabels] = ml_generate_unbalance_2D(inputData, inputLabels, percentage)
%ML_GENERATE_UNBALANCE_2D Generate unbalanced dataset (removing a
%percentage of data in one of the class)
%  

outputLabels = inputLabels;
outputData = inputData;

classes = unique(inputLabels);
nbOfClasses = length(classes);

class = randi(nbOfClasses);

indClass = find(inputLabels==classes(class));
nbOfRemovedData = ceil(length(indClass)*percentage/100);
selectedInd = [];
for j = 1:nbOfRemovedData
    ind = randi(length(indClass));
    while(ismember(ind,selectedInd));
        ind = randi(length(indClass));
    end
    selectedInd = [selectedInd ind];
end

outputLabels(indClass(selectedInd)) = [];
outputData(indClass(selectedInd),:) = [];


end

