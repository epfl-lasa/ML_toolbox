function [estimateclass,err,h] = WeightedThresholdClassifier( datafeatures,dataclass,dataweight )
%DECISION_STUMP
%
% This is an example of an "Weak Classifier", it caculates the optimal
% threshold for all data feature dimensions.
% It then selects the dimension and  treshold which divides the 
% data into two class with the smallest error.
%
%   input -----------------------------------------------------------------
%
%
%
%   output ----------------------------------------------------------------
%
%       estimateclass : , estimated class label.
%
%       err


% Number of treshold steps
ntre=2e5;

% Split the data in two classes 1 and -1
r1=datafeatures(dataclass<0,:); w1=dataweight(dataclass<0);
r2=datafeatures(dataclass>0,:); w2=dataweight(dataclass>0);

% Calculate the min and max for every dimensions
minr=min(datafeatures,[],1)-1e-10; maxr=max(datafeatures,[],1)+1e-10;

% Make a weighted histogram of the two classes
p2c= ceil((bsxfun(@rdivide,bsxfun(@minus,r2,minr),(maxr-minr)))*(ntre-1)+1+1e-9);   p2c(p2c>ntre)=ntre;
p1f=floor((bsxfun(@rdivide,bsxfun(@minus,r1,minr),(maxr-minr)))*(ntre-1)+1-1e-9);  p1f(p1f<1)=1;
ndims=size(datafeatures,2);
i1=repmat(1:ndims,size(p1f,1),1);  i2=repmat(1:ndims,size(p2c,1),1);
h1f=accumarray([p1f(:) i1(:)],repmat(w1(:),ndims,1),[ntre ndims],[],0);
h2c=accumarray([p2c(:) i2(:)],repmat(w2(:),ndims,1),[ntre ndims],[],0);

% This function calculates the error for every all possible treshold value
% and dimension
h2ic=cumsum(h2c,1);
h1rf=cumsum(h1f(end:-1:1,:),1); h1rf=h1rf(end:-1:1,:);
e1a=h1rf+h2ic;
e2a=sum(dataweight)-e1a;

% We want the treshold value and dimension with the minimum error
[err1a,ind1a]=min(e1a,[],1);  dim1a=(1:ndims); dir1a=ones(1,ndims);
[err2a,ind2a]=min(e2a,[],1);  dim2a=(1:ndims); dir2a=-ones(1,ndims);
A=[err1a(:),dim1a(:),dir1a(:),ind1a(:);err2a(:),dim2a(:),dir2a(:),ind2a(:)];
[err,i]=min(A(:,1)); dim=A(i,2); dir=A(i,3); ind=A(i,4);
thresholds = linspace(minr(dim),maxr(dim),ntre);
thr=thresholds(ind);

% Apply the new treshold
h.dimension = dim; 
h.threshold = thr; 
h.direction = dir;
estimateclass=ApplyClassTreshold(h,datafeatures);

