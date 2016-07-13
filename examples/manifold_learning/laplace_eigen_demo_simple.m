%% Laplacian Eigen maps and MDS
    close all; clear all;
	%[X, labels] = generate_data('swiss', 2000);
   
    % 1st group of points
    X1=[1 1
        1 0.5
        1 1.5
        0.5 1
        1.5 1
        ]
    [N1,r]=size(X1);
    labels([1:N1])=1;  % Labels of the class - 3 classes here
    
    % 2nd group of points
    X2=[-1 -1
        -1 -0.8
        -1 -1.2
        -0.8 -1
        -1.2 -1
        ]
     [N2,r]=size(X2);
       labels([N1+1:N1+N2])=2;

    
    % 3rd group of points (overlap with one and two)
%         X3=[-0.9 -1
%         -0.2 -0.8
%         -0.5 -0.5
%          0.5 0.8
%          0.2 0.0
%          0.1 -0.1
%          0.2 -0.2
% %         ]
        X3=X1;
     [N3,r]=size(X3);
   labels([N1+N2+1:N1+N2+N3])=3;

 figure; hold on;
 plot(X1(:,1),X1(:,2),'b*');
 plot(X2(:,1),X2(:,2),'r*');
 plot(X3(:,1),X3(:,2),'k*');
 legend('Class 1', 'Class 2', 'Class 3');
axis([-2 2 -2 2]);

X=[X1' X2' X3']';  %% Construct the entire matrix made of the 3 subgroups of points

[L,r]=size(X);
for i=1:L
 if labels(i)==1 c(i,:)=[0 0 1];
 elseif labels(i)==2; c(i,:)=[1 0 0];
 else c(i,:)=[0 0 0];
 end;
end;
%%
figure; hold on;

%% Perform MDS
   % [mappedX, mapping] = compute_mapping(X, 'MDS', 3);	
    
   disp('Computing kernel matrix...'); 
   kernel       = 'gauss';
   param1       = 1; % sigma
   param2       = 0; % not used
   K            = gram(X, X, kernel, param1, param2);
   dims_keep    = 2;
    
   [mappedX, mapping] = cmdscale(K,dims_keep);
   
   subplot(2,2,1), scatter(mappedX(:,1), mappedX(:,2), 25, c, 'filled'); title(['Result of MDS']); drawnow
    
%% Perform PCA
    [mappedX, mapping] = compute_mapping(X, 'PCA', 2);	
	subplot(2,2,2), scatter(mappedX(:,1), mappedX(:,2), 25, c, 'filled'); title(['Result of ' mapping.name]); drawnow
    

    %% Perform Laplacian
    [mappedX, mapping] = compute_mapping(X, 'Laplacian', 4);	
	subplot(2,2,3), scatter(mappedX(:,1), mappedX(:,2), 25, c, 'filled'); title(['Result of ' mapping.name]); drawnow
    %% Isomap
    [mappedX, mapping] = compute_mapping(X, 'Isomap', 2);	
	subplot(2,2,4), scatter(mappedX(:,1), mappedX(:,2), 25, c, 'filled'); title(['Result of ' mapping.name]); drawnow
return; 

    
	figure, scatter3(X(:,1), X(:,2), X(:,3), 5, labels); title('Original dataset'), drawnow
	no_dims = round(intrinsic_dim(X, 'MLE'));
	disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);

    % This does not seem to be implemented in the toolbox, -> use matlab 
    % dimensionality reduction: http://uk.mathworks.com/help/stats/dimensionality-reduction.html
    [mappedX, mapping] = compute_mapping(X, 'MDS', 2);	
	figure, scatter(mappedX(:,1), mappedX(:,2), 5); title(['Result of ' mapping.name]); drawnow

    [mappedX, mapping] = compute_mapping(X, 'LaplacianEigenmaps', no_dims, 7);	
	figure, scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps'); drawnow    
    
    %% Multi-dimensional scaling from matlab
    
    % Generate some points in 4-D space, but close to 3-D space, then reduce them to distances only.
    X = [normrnd(0,1,10,3) normrnd(0,.1,10,1)];
    D = pdist(X,'euclidean');
    
    [Y,e] = cmdscale(D);
    
    % Four, but fourth one small
    dim = sum(e > eps^(3/4));
    
    % Poor reconstruction
    maxerr2 = max(abs(pdist(X)-pdist(Y(:,1:2))))

    % Good reconstruction
    maxerr3 = max(abs(pdist(X)-pdist(Y(:,1:3)))) 

    % Exact reconstruction
    maxerr4 = max(abs(pdist(X)-pdist(Y)))
    
    %% Try matlab MDS with Swiss role data set
    	
    [X, labels] = generate_data('swiss', 1000);
    
    % Use the euclidean distance metrix, rows of X should correspond to
    % observations
    D          = pdist(X,'euclidean');
     
    disp(['D: ' num2str(size(D,1)) ' x ' num2str(size(D,2))]);
    
    
    [Y,e]       = cmdscale(D);
  	figure, scatter(Y(:,1), Y(:,2), 5,labels); title(['Result of Matlab MDS']); drawnow
  
    
    