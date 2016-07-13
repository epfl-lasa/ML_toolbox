function [X,labels] = ml_checkerboard_data(n)
% ML_CHECKERBOARD_DATA Generates a checkerboard pattern within a circle
%
%   input ----------------------------------------------------------------
%
%       o n          : (1 x 1), number of samples per quadrant.
%
%
%   output ----------------------------------------------------------------
%
%       o X          : (num_samples x D), number of samples.
%
%       o labels     : (num_samples x 1), class lables of the data.
%
%
%% Hyperparameters

X       = [];
labels  = [];

%% Generate checkerboard circle

r1 = sqrt(rand(2*n,1));                     % Random radii
t1 = [pi/2*rand(n,1); (pi/2*rand(n,1)+pi)]; % Random angles for Q1 and Q3
X1 = [r1.*cos(t1) r1.*sin(t1)];             % Polar-to-Cartesian conversion

r2 = sqrt(rand(2*n,1));
t2 = [pi/2*rand(n,1)+pi/2; (pi/2*rand(n,1)-pi/2)]; % Random angles for Q2 and Q4
X2 = [r2.*cos(t2) r2.*sin(t2)];

X = [X1; X2];        % Predictors
labels = ones(4*n,1);
labels(2*n + 1:end) = -1; % Labels