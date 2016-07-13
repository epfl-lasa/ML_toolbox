function [ Y,model ] = ml_gradient_boosting(X,y,nbOfWeakLearners )
%ML_GRADIENT_BOOSTING Perform Gradient Boosting for regression

% Train Gradient Boosting Model
model = fitensemble(X,y,'LSBoost',options.nbWeakLearners,'Tree');

% Compute prediction

Y = predict(model,X);

end

