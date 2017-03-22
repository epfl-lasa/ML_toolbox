function [label, model, energy] = knKmeans(X, init, kn, s, c)
% Perform kernel kmeans clustering.
% Input:
%   K: n x n kernel matrix
%   init: either number of clusters (k) or initial label (1xn)
% Output:
%   label: 1 x n clustering result label
%   energy: optimization target value
%   model: trained model structure
% Reference: Kernel Methods for Pattern Analysis
% by John Shawe-Taylor, Nello Cristianini
% Written by Mo Chen (sth4nth@gmail.com).
n = size(X,2);
if numel(init)==1
    k = init;
    label = ceil(k*rand(1,n));
elseif numel(init)==n
    label = init;
    k = length(unique(label));
end
if nargin == 4
    kn = @knGauss;
    K = kn(X,X,s);
elseif nargin == 5
    kn = @knPoly;
    K = kn(X,X,s,c);    
end

last = zeros(1,n);
while any(label ~= last)
    [~,~,last(:)] = unique(label);   % remove empty clusters
    E = sparse(last,1:n,1);
    E = E./repmat(full(sum(E,2)),1,length(E));
    T = E*K;
    C = repmat(full(dot(T,E,2))/2,1,length(E));
    [val, label] = max(T-C,[],1);
end
energy = trace(K)-2*sum(val); 

% Compute Eigenvectors
[H, L] = eigs(K, k);

% Compute Centroids
H_normalized = H ./ repmat(sqrt(sum(H.^2, 2)), 1, k);
centroids = zeros(k,k);
for i = 1:k
    centroids(i,:) = sum(H_normalized(label==i,:),1)/size(H_normalized(label==i,:),1);
end

if nargout == 3
    model.X = X;
    model.label     = label;
    model.kn        = kn;
    model.eigens    = H;
    model.centroids = centroids';
    model.lambda    = L;
end
