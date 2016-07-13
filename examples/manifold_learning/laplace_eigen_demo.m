%% Laplacian Eigen maps and MDS
    close all; clear all;
	[X, labels] = generate_data('brokenswiss', 2000);
    
	figure, scatter3(X(:,1), X(:,2), X(:,3), 5, labels,'filled'); title('Original dataset'), drawnow
	no_dims = round(intrinsic_dim(X, 'MLE'));
	disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);

    % This does not seem to be implemented in the toolbox, -> use matlab 
    % dimensionality reduction: http://uk.mathworks.com/help/stats/dimensionality-reduction.html
   % [mappedX, mapping] = compute_mapping(X, 'MDS', 2);	
    
       disp('Computing kernel matrix...'); 
   kernel       = 'gauss';
   param1       = 0.5; % sigma
   param2       = 0; % not used
   K            = gram(X, X, kernel, param1, param2);
   dims_keep    = 8;
    
%   [mappedX, mapping] = cmdscale(K);
%	figure, scatter(mappedX(:,1), mappedX(:,2), 5); title(['Result of ' mapping.name]); drawnow

no_dims=8;
    
    [mappedX, mapping] = compute_mapping(X, 'LaplacianEigenmaps', no_dims, 8);	
	figure, hold on; 
    subplot(2,2,1); scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps y1-y2'); drawnow
    subplot(2,2,2); scatter(mappedX(:,3), mappedX(:,4), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps y3-y4'); drawnow
    subplot(2,2,3); scatter(mappedX(:,5), mappedX(:,6), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps y5-y6'); drawnow
    subplot(2,2,4); scatter(mappedX(:,7), mappedX(:,8), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps y7-y8'); drawnow

 
       [mappedX, mapping] = compute_mapping(X, 'Isomap', no_dims, 8);	
	figure, hold on; %scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Isomap'); drawnow
     subplot(2,2,1); scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Isomap y1-y2'); drawnow
    subplot(2,2,2); scatter(mappedX(:,3), mappedX(:,4), 5, labels(mapping.conn_comp)); title('Result of Isomap y3-y4'); drawnow
    subplot(2,2,3); scatter(mappedX(:,5), mappedX(:,6), 5, labels(mapping.conn_comp)); title('Result of Isomap y5-y6'); drawnow
    subplot(2,2,4); scatter(mappedX(:,7), mappedX(:,8), 5, labels(mapping.conn_comp)); title('Result of Isomap y7-y8'); drawnow


    
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
    	
    [X, labels] = generate_data('brokenswiss', 1000);
    
    % Use the euclidean distance metrix, rows of X should correspond to
    % observations
    D          = pdist(X,'euclidean');
     
    disp(['D: ' num2str(size(D,1)) ' x ' num2str(size(D,2))]);
    
    
    [mappedX,e]       = cmdscale(D);
	figure, hold on; %scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Isomap'); drawnow
     subplot(2,2,1); scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of MDS y1-y2'); drawnow
    subplot(2,2,2); scatter(mappedX(:,3), mappedX(:,4), 5, labels(mapping.conn_comp)); title('Result of MDS y3-y4'); drawnow
    subplot(2,2,3); scatter(mappedX(:,5), mappedX(:,6), 5, labels(mapping.conn_comp)); title('Result of MDS y5-y6'); drawnow
    subplot(2,2,4); scatter(mappedX(:,7), mappedX(:,8), 5, labels(mapping.conn_comp)); title('Result of MDS y7-y8'); drawnow


    
    