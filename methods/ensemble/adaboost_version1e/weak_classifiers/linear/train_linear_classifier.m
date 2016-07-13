function [B_hat,mapping] = train_linear_classifier(X,labels,w)
%TRAIN_LINEAR_CLASSIFIER 

 [B_hat,mapping] = linear_classifier('train',X,labels,w,'classification',[]);

end

