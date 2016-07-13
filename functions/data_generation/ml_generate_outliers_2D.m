function [ outputLabels ] = ml_generate_outliers_2D(inputLabels, percentage)
%ML_GENERATE_OUTLIERS_2D Generate outliers within 2D datasets (examples of
%one class in the deep region of another class)
%  

outputLabels = inputLabels;

classes = unique(inputLabels);
nbOfClasses = length(classes);

for i = 1:nbOfClasses
    indClass = find(inputLabels==classes(i));
    nbOfOutliers = ceil(length(indClass)*percentage/100);
    selectedInd = [];
    for j = 1:nbOfOutliers
        ind = randi(length(indClass));
        while(ismember(ind,selectedInd));
            ind = randi(length(indClass));
        end
        selectedInd = [selectedInd ind];
    end
    outputLabels(indClass(selectedInd)) = classes(mod(i,nbOfClasses)+1);
end

end

