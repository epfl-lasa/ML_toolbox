% Example for adaboost.m
%
% Type "edit adaboost.m" to see the code



% Make training data of two classes "red" and "blue"
 % with 2 features for each sample (the position  x and y).
  angle=rand(200,1)*2*pi; l=rand(200,1)*40+30; blue=[sin(angle).*l cos(angle).*l];
  angle=rand(200,1)*2*pi; l=rand(200,1)*40;    red=[sin(angle).*l cos(angle).*l];

 % All the training data
  datafeatures=[blue;red];
  dataclass(1:200)=-1; dataclass(201:400)=1;

 % Show the data
  figure; hold on; axis equal;
  plot(blue(:,1),blue(:,2),'b.'); plot(red(:,1),red(:,2),'r.');
  title('Training Data');
  axis equal;
%% Use Adaboost to make a classifier
  
[classestimate,model]=adaboost('train',datafeatures,dataclass,[],200);

%%

blue=datafeatures(classestimate==-1,:); red=datafeatures(classestimate==1,:);

Zs      = ml_plot_ada_model(model);
[Xs,Ys] = meshgrid(linspace(-80,80,161),linspace(-80,80,161));

close all;
figure;
%imshow(I,[]); 
pcolor(Xs,Ys,Zs); shading interp;
colorbar; axis xy;
colormap('jet'), hold on
plot(blue(:,1),blue(:,2),'bo');
plot(red(:,1),red(:,2),'ro');
title('Training Data classified with adaboost model');

 %%
 
 % Show the error verus number of weak classifiers
 error=zeros(1,length(model)); for i=1:length(model), error(i)=model(i).error; end 
 subplot(2,2,3), plot(error); title('Classification error versus number of weak classifiers');

 % Make some test data
  angle=rand(200,1)*2*pi; l=rand(200,1)*70; testdata=[sin(angle).*l cos(angle).*l];

 % Classify the testdata with the trained model
  testclass=adaboost('apply',testdata,model);

 % Show result
  blue=testdata(testclass==-1,:); red=testdata(testclass==1,:);

 % Show the data
  subplot(2,2,4), hold on
  plot(blue(:,1),blue(:,2),'b*');
  plot(red(:,1),red(:,2),'r*');
  axis equal;
  title('Test Data classified with adaboost model');
