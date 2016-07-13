function [ outputData ] = ml_generate_noise_2D(inputData, labels, percentage)
%ML_GENERATE_NOISE_2D Generate noise within 2D datasets (noise in the
%attributes of % of examples in each class)
%  

outputData = inputData;

classes = unique(labels);
nbOfClasses = length(classes);

for i = 1:nbOfClasses
    indClass = find(labels==classes(i));
    nbOfNoisyExamples = ceil(length(indClass)*percentage/100);
    selectedInd = [];
    for j = 1:nbOfNoisyExamples
        ind = randi(length(indClass));
        while(ismember(ind,selectedInd));
            ind = randi(length(indClass));
        end
        selectedInd = [selectedInd ind];
    end
    for j = 1:size(inputData,2)
        outputData(indClass(selectedInd),j) = (max(inputData(:,j))-min(inputData(:,j)))*rand(nbOfNoisyExamples,1) + min(inputData(:,j));
    end
end

end

