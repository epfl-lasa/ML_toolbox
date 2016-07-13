close all
clear all
%% Data importation

fileName            = 'data/digits.csv'; % Here you have to specify the dataset you want to use


% Digits dataset

dataCsv                 = csvread(fileName);

%%
num_data_total          = size(dataCsv,1);


samples                 = 1700 ; % Specify the number of samples you want to use
nbOfClasses             = 5; % Specify the number of classes on which you want to perform your clustering
displayDataExample      = true; % If you want to see some examples of your data


data = zeros(samples, size(dataCsv,2));
i = 1 ;
n = 0;
while n < samples && i <= num_data_total
    if(dataCsv(i,65) < nbOfClasses)
        data(n+1,:) = dataCsv(i,:);
        n = n + 1;
    end
    i = i + 1;
end

labels = data(1:n-1,end) + 1;
data = data(1:n-1,1:end-1);
data = data./16;

for i=1:nbOfClasses
   disp(['num class(' num2str(i) '): ' num2str(sum(labels==i))]);
end
disp(['Number of samples:# ' num2str(size(data,1))]);


if(displayDataExample==true)
    if samples >=64
        nbImages = 8;
    else
        nbImages = (floor(sqrt(samples)));
    end
    for j = 1:nbImages^2
        subplot(nbImages,nbImages,j)
        im = reshape(data(j,1:64),8,8);
        im = (-(im-1))';
        imshow(im)
    end
end

%% Projection

projection = true ; % If you want to project your data
display = true; % If you want to display a 2D view of the projection

if(projection == true)
    
    projectionTechnique = 'PCA'; % Choose your projection algorithm among 'PCA', 'KPCA', 'Isomap', 'LLE'
    nbDimensions = 2; % Number of dimensions in the embedded space
    
    switch projectionTechnique
        
        case 'PCA'
            [projectedData, mapping] = compute_mapping(data, projectionTechnique, nbDimensions);
        
        case 'KPCA'
            kernel = 'gauss' ; % Choose between 'poly' and 'gauss'
            kernelParam1 = 20; % Variance for the gaussian kernel ; Offset for the polynomial kernel
            switch kernel
                case 'poly'
                    kernelParam2 = 3; % Choose the degree of the polynome
                    [projectedData, mapping] = compute_mapping(data, projectionTechnique, nbDimensions, kernel, kernelParam1, kernelParam2);
                case 'gauss'
                    [projectedData, mapping] = compute_mapping(data, projectionTechnique, nbDimensions, kernel, kernelParam1);
            end
            
        case {'Isomap', 'LLE'}
            neighbors = 50; % Choose the number of neighbors in the construction of the graph (enough big numvber to have a complete connected graph)
            [projectedData, mapping] = compute_mapping(data, projectionTechnique, nbDimensions, neighbors);
           
    end
    
    if(display == true)

        dataDisplayed = projectedData(:,1:nbDimensions);
        if exist('hp','var') && isvalid(hp), delete(hp); end
        hp = figure;
        hold on
        legendProj = cell(nbOfClasses,1);
        color = hsv(nbOfClasses);
        if nbDimensions == 2
            for i = 1:nbOfClasses
                disp = find(labels == i);
                scatter(dataDisplayed(disp,1),dataDisplayed(disp,2),36,color(i,:))
                legendProj{i} = ['Class ' num2str(i)];
            end
            xlabel 'Component 1';
            ylabel 'Component 2';
        else
            for i = 1:nbOfClasses
                disp = find(labels == i);
                scatter3(dataDisplayed(disp,1),dataDisplayed(disp,2),dataDisplayed(disp,3),36,color(i,:))
                legendProj{i} = ['Class ' num2str(i)];
            end
            xlabel 'Component 1';
            ylabel 'Component 2';
            zlabel 'Component 3';
            box on; grid on;
        end
        title 'Vizualization of the projection on the first two components'

        legend(legendProj, 'Location', 'eastoutside');
    end
    
end

%% Clustering

clustering = true ; % If you want to apply a clustering algorithm to your data
display = true ; % If you want to display a 2D view of the clustering

if(projection == true)
    dataClustering = (projectedData - min(projectedData(:)))/(max(projectedData(:)) - min(projectedData(:)));
else
    dataClustering = data;
end

if(clustering == true)
    
    clusteringTechnique = 'kernel-kmeans'; % Choose your clustering algorithm among 'kmeans', 'kernel-kmeans', 'gmm'
    
    switch clusteringTechnique
                
        case 'kmeans'
            k = 5; % Choose the number of clusters
            distance = 'sqeuclidean'; % Choose the distance measure among 'sqeuclidean', 'cityblock' (L1), 'cosine'
            
            [predictedCluster, centroids] = kmeans(dataClustering, k);
            
            
            % Detemining the accuracy of the method
            accuracy = 0;
            perm = perms(1:k);
            trueCentroids = centroids;
            predictedClusterPerm = predictedCluster;
            
            for j=1:size(perm,1)
                totalBadClassifiedSamples = 0;
                badClassifiedSamples = [];
                for i=1:length(predictedCluster)
                    predictedClusterPerm(i)=perm(j,predictedCluster(i));
                    if(predictedClusterPerm(i) ~= labels(i))
                        totalBadClassifiedSamples = totalBadClassifiedSamples + 1;
                        badClassifiedSamples = [badClassifiedSamples i];
                    end
                end
                acc = 1 - totalBadClassifiedSamples/i;
                if(acc > accuracy)
                    accuracy=acc;
                    truePredictedCluster = predictedClusterPerm;
                    for ind=1:k
                        trueCentroids(perm(j,ind),:) = centroids(ind,:);
                    end
                    trueBadClassifiedSamples = badClassifiedSamples;
                end
            end            
            
            % Display
            if(display == true)
                
                x1 = 0:0.001:1;
                x2 = 0:0.001:1;
                [x1G,x2G] = meshgrid(x1,x2);
                XGrid = [x1G(:),x2G(:)];
                region = kmeans(XGrid,k,'MaxIter',1,'Start',trueCentroids);
                
                figure;
                gscatter(XGrid(:,1),XGrid(:,2),region,hsv(k));
                hold on;
                plot(dataClustering(:,1),dataClustering(:,2),'ko','MarkerSize',5);
                plot(dataClustering(trueBadClassifiedSamples,1),dataClustering(trueBadClassifiedSamples,2),'kx','MarkerSize',5);
                plot(trueCentroids(:,1),trueCentroids(:,2),'k.','MarkerSize',50);
                title(['Clustering Vizualization (Accuracy : ' num2str(accuracy*100) ' %)']);
                xlabel 'Coordinate 1';
                ylabel 'Coordinate 2';
                legendTitles = cell(k,1);
                for i=1:k
                    legendTitles{i} = ['Class ' num2str(i)];
                end
                legendTitles{k+1} = 'Data';
                legendTitles{k+2} = 'Misclassified Samples';
                legendTitles{k+3} = 'Centroids';
                legend(legendTitles, 'Location', 'eastoutside');
                hold off;
            end
            
            
            
        case 'kernel-kmeans'
            k = 5; % Choose the number of clusters
            kernel = 'gauss'; % Choose the kernel type between 'gauss' and 'poly'
            
            switch kernel
                case 'gauss'
                    variance = 1; % Choose the variance of the kernel
                    Kn = knGauss(dataClustering',dataClustering',variance);
%                     param = {variance};
                    
                case'poly'
                    degree = 2; % Choose the degree of the polynomial kernel
                    constant = 0; % Choose the offset
                    Kn = knPoly(dataClustering',dataClustering',degree,constant);
%                     param = {degree, constant};
                    
            end
            
            [predictedCluster, eigens] = kernelkmeans(Kn, k);
            centroids=zeros(k,size(Kn,2));
            projectedClusteredData = Kn;
            for i = 1:k
                centroids(i,:)= sum(projectedClusteredData(predictedCluster==i,:),1)/size(projectedClusteredData(predictedCluster==i,:),1);
            end            
            
            % Detemining the accuracy of the method
            accuracy = 0;
            perm = perms(1:k);
            predictedClusterPerm = predictedCluster;
            trueCentroids = centroids;
            
            for j=1:size(perm,1)
                totalBadClassifiedSamples = 0;
                badClassifiedSamples = [];
                for i=1:length(predictedCluster)
                    predictedClusterPerm(i)=perm(j,predictedCluster(i));
                    if(predictedClusterPerm(i) ~= labels(i))
                        totalBadClassifiedSamples = totalBadClassifiedSamples + 1;                        
                        badClassifiedSamples = [badClassifiedSamples i];
                    end
                end
                acc = 1 - totalBadClassifiedSamples/i;
                if(acc > accuracy)
                    accuracy=acc;
                    for ind=1:k
                        trueCentroids(perm(j,ind),:) = centroids(ind,:);
                    end
                    truePredictedCluster = predictedClusterPerm;
                    trueBadClassifiedSamples = badClassifiedSamples;
                end
            end            
            
            % Display
            if(display == true)
                
                x1 = 0:0.001:1;
                x2 = 0:0.001:1;
                [x1G,x2G] = meshgrid(x1,x2);
                XGrid = [x1G(:),x2G(:)];            
                
                switch kernel
                    case 'gauss'
                        KnGrid = knGauss(XGrid',dataClustering',variance);

                    case'poly'
                        KnGrid = knPoly(XGrid',dataClustering',degree,constant);
                end

                region = kmeans(KnGrid,k,'MaxIter',1,'Start',trueCentroids);
                
                figure;
                gscatter(XGrid(:,1),XGrid(:,2),region,hsv(k));
                hold on;
                plot(dataClustering(:,1),dataClustering(:,2),'ko','MarkerSize',5);
                plot(dataClustering(trueBadClassifiedSamples,1),dataClustering(trueBadClassifiedSamples,2),'kx','MarkerSize',5);
                title(['Clustering Vizualization (Accuracy : ' num2str(accuracy*100) ' %)']);
                xlabel 'Coordinate 1';
                ylabel 'Coordinate 2';
                legendTitles = cell(k,1);
                for i=1:k
                    legendTitles{i} = ['Class ' num2str(i)];
                end
                legendTitles{k+1} = 'Data';
                legendTitles{k+2} = 'Misclassified Samples';
                legend(legendTitles, 'Location', 'eastoutside');
                hold off;
            end
            
            
            
        case 'gmm'
            nbOfClusters = 5; % Choose the number of components in your model or perform a 'aic' or 'bic' in order to find it
            
            if (isnumeric(nbOfClusters))
                k=nbOfClusters;
                GMModel = fitgmdist(dataClustering,k);
            else
                if(strcmp(nbOfClusters,'aic'))
                    AIC = zeros(1,10);
                    GMModels = cell(1,10);
                    for k = 1:10
                        GMModels{k} = fitgmdist(dataClustering,k);
                        AIC(k)= GMModels{k}.AIC;
                    end
                    figure
                    plot(AIC)
                    xlabel 'Number of components'
                    ylabel AIC
                    [minAIC,numComponents] = min(AIC);
                    GMModel = GMModels{numComponents};
                    k=numComponents;
                elseif(strcmp(nbOfClusters,'bic'))
                    BIC = zeros(1,10);
                    GMModels = cell(1,10);
                    for k = 1:10
                        GMModels{k} = fitgmdist(dataClustering,k);
                        BIC(k)= GMModels{k}.BIC;
                    end
                    figure
                    plot(BIC)
                    xlabel 'Number of components'
                    ylabel BIC
                    [minBIC,numComponents] = min(BIC);
                    GMModel = GMModels{numComponents};
                    k=numComponents;
                else
                    error('Please enter a right parameter for GMM number of cluster')
                end
            end
            
            if(display == true)
                
                clusterData = cluster(GMModel,dataClustering);
                colors = hsv(k);
                
                % Detemining the accuracy of the method
                accuracy = 0;
                perm = perms(1:k);
                predictedClusterPerm = clusterData;

                for j=1:size(perm,1)
                    totalBadClassifiedSamples = 0;
                    badClassifiedSamples = [];
                    for i=1:length(clusterData)
                        predictedClusterPerm(i)=perm(j,clusterData(i));
                        if(predictedClusterPerm(i) ~= labels(i))
                            totalBadClassifiedSamples = totalBadClassifiedSamples + 1;                        
                            badClassifiedSamples = [badClassifiedSamples i];
                        end
                    end
                    acc = 1 - totalBadClassifiedSamples/i;
                    if(acc > accuracy)
                        accuracy=acc;
                        truePredictedCluster = predictedClusterPerm;
                        trueBadClassifiedSamples = badClassifiedSamples;
                        for ind=1:k
                            S.ComponentProportion(perm(j,ind)) = GMModel.ComponentProportion(ind);
                            S.mu(perm(j,ind),:) = GMModel.mu(ind,:);
                            S.Sigma(:,:,perm(j,ind)) = GMModel.Sigma(:,:,ind);
                        end
                    end
                end
                
                x1 = 0:0.001:1;
                x2 = 0:0.001:1;
                [x1G,x2G] = meshgrid(x1,x2);
                XGrid = [x1G(:),x2G(:)];
                GMModelXgrid = fitgmdist(XGrid,k,'Start',S,'Options',statset('MaxIter',1));
                mahalDist = mahal(GMModelXgrid,XGrid);
                threshold = sqrt(chi2inv(0.99,2));
            
                figure
                hold on
                gscatter(dataClustering(:,1),dataClustering(:,2),truePredictedCluster,colors);
                plot(dataClustering(trueBadClassifiedSamples,1),dataClustering(trueBadClassifiedSamples,2),'kx','MarkerSize',5);
                plot(GMModelXgrid.mu(:,1),GMModelXgrid.mu(:,2),'k.','LineWidth',2,'MarkerSize',50);
                
                title(['Clustering Vizualization (Accuracy : ' num2str(accuracy*100) ' %)']);
                xlabel 'Coordinate 1';
                ylabel 'Coordinate 2';
                legendTitles = cell(k,1);
                for i=1:k
                    legendTitles{i} = ['Class ' num2str(i)];
                end
                legendTitles{k+1} = 'Misclassified Samples';
                legendTitles{k+2} = 'Centroids';
                legend(legendTitles, 'Location', 'eastoutside');
                
                for m = 1:k;
                    idx = mahalDist(:,m)<=threshold;
                    Color = colors(m,:)*0.75 + -0.5*(colors(m,:) - 1);
                    h = plot(XGrid(idx,1),XGrid(idx,2),'.','Color',Color,'MarkerSize',2);
                    uistack(h,'bottom');
                end
                
                
                hold off;
            end            
                                
    end
end
