function F = ml_Fmeasure(cluster_labels, class_labels)
%ML_FMEASURE Compute the Fmeasure for clustering with external validity
%
%
%   http://www.uni-weimar.de/medien/webis/teaching/lecturenotes/machine-learning/unit-en-cluster-analysis-evaluation.pdf
%   slide number 23-26
%
%   Macro average F-measure
%
%   Fm is an N x M matrix (N number of classes, M number of clusters) where
%   Fm(i,j) is the F-measure of the jth cluster computed with respect to
%   the ith class
%
%   
%   input -----------------------------------------------------------------
%       
%       - cluster_labels : N x 1 vector of cluster labels given by the clustering algorithm
%       (N is the size of data)
%
%       - class_labels : N x 1 vector of class labels (ground truth)
%
%   output ----------------------------------------------------------------
%
%       - F = macro averaged F-measure


nbOfClusters = length(unique(cluster_labels));
nbOfClasses  = length(unique(class_labels));
sizeClasses  = zeros(nbOfClasses,1);

Fm = zeros(nbOfClasses,nbOfClusters);

unique_cluster_labels = unique(cluster_labels);
unique_class_labels   = unique(class_labels);

% for i = 1:nbOfClasses
%     for j = 1:nbOfClusters
%         N=0;
%         for k = 1:length(cluster_labels)
%             if(cluster_labels(k) == j && class_labels(k) == i)
%                 N = N+1;
%             end
%         end
%         Precision = N/length(find(cluster_labels==j));
%         Recall = N/length(find(class_labels==i));
%         Fm(i,j) = 2*Precision*Recall/(Precision+Recall);
%     end
% end


for i = 1:nbOfClasses
    for j = 1:nbOfClusters
        N=0;
        for k = 1:length(cluster_labels)
            if(cluster_labels(k) == unique_cluster_labels(j) && class_labels(k) == unique_class_labels(i))
                N = N+1;
            end
        end
        Precision = N/length(find(cluster_labels==unique_cluster_labels(j)));
        Recall = N/length(find(class_labels==unique_class_labels(i)));
        Fm(i,j) = 2*Precision*Recall/(Precision+Recall);
    end
end

for m = 1:nbOfClasses
    sizeClasses(m,:) = length(find(class_labels==unique_class_labels(m)));
end

F = sum(max(Fm,[],2).*sizeClasses)/sum(sizeClasses);

end

