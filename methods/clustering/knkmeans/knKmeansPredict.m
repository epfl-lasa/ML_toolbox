function [label, energy] = knKmeansPredict(Xt, X, t, kn, s, c)
% Prediction for kernel kmeans clusterng
% Input:
%   model: trained model structure
%   Xt: d x n testing data
% Ouput:
%   label: 1 x n predict label
%   engery: optimization target value
% Written by Mo Chen (sth4nth@gmail.com).

n = size(X,2);
k = max(t);
E = sparse(t,1:n,1,k,n,n);
E = bsxfun(@times,E,1./sum(E,2));

if nargin == 5
    Z = bsxfun(@minus,E*kn(X,Xt,s),diag(E*kn(X,X,s)*E')/2);
elseif nargin == 6
    Z = bsxfun(@minus,E*kn(X,Xt,s,c),diag(E*kn(X,X,s,c)*E')/2);
end

[val, label] = max(Z,[],1);
energy = sum(kn(Xt))-2*sum(val);
