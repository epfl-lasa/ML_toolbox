function [X,labels] = ml_load_digits_64(filename,classes)
%ML_LOAD_DIGITS_64 Loads digit dataset from file digits.csv. This data set
%is compused of numbers from 0-9 and each image is 8 x 8, giving you a 64
%dimensional data point.
%
%  dataset : (1797 x 65), the last column is the class label.
%
%   input -----------------------------------------------------------------
%
%       o filename    : string with path to digits.csv
%
%       o num_classes : (1 x M), array containing the indices of the classes
%                                you want to load.
%
%                       num_classes = [0 1 3 7] : load images with numbers
%                                                  
%   output ----------------------------------------------------------------
%
%        o X          : (N x 64), dataset, one row is one image
%
%        o labels     :  (N x 1), dataset of labels.
%
%

% Digits dataset
fprintf('\nimport digits 8 x 8\n');
data                    = csvread(filename);
X                       = [];
labels                  = [];

for i=1:length(classes)
    x       = data(data(:,end) == classes(i),1:end-1);
    X       = [X; x];
    labels  = [labels;ones(size(x,1),1) .* classes(i)];
    disp( [ '	class '   num2str(classes(i)) ': ' num2str(size(x,1)) ' samples' ]);
end
labels = labels + 1;
X      = double(X);
X       = rescale(X,min(X(:)),max(X(:)),0,1);

end
