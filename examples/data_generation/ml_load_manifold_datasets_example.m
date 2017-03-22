%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Loading 3D Datasets for Manifold Learning  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: 
% Alberto Arrighi   (alberto.arrighi@epfl.ch)
% Ilaria Lauzana    (ilaria.lauzana@epfl.ch)
% Ludovico Novelli  (ludovico.novelli@epfl.ch)
%
% From Spring Semester Advanced Machine Learning Mini-Project
% Ecole Polytechnique Federale de Lausanne

%% GENERATE DIFFERENT DATASETS FOR MANIFOLD LEARNING EXAMPLES
%% 1) Swissroll

% Options
dataset_options                    = [];
dataset_options.numberOfPoints     = 2000;
dataset_options.name               = 'swissroll';
dataset_options.plot               = false;

% Generate dataset
[X, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options);

% Plot original data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.points_size = 30;
plot_options.cmap       = cmap;
plot_options.title      = 'Swiss Roll';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
axis equal

%% 2) Swissroll with hole

% Options
dataset_options                    = [];
dataset_options.numberOfPoints     = 2000;
dataset_options.name               = 'swissroll_hole';
dataset_options.plot               = false;

% Generate dataset
[X, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options);

% Plot original data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.points_size = 30;
plot_options.cmap       = cmap;
plot_options.title      = 'Swiss Roll w/Hole';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
axis equal

%% 3) S-curve

% Options
dataset_options                    = [];
dataset_options.numberOfPoints     = 2000;
dataset_options.name               = 'scurve';
dataset_options.plot               = false;

% Generate dataset
[X, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options);


% Plot original data
plot_options            = [];
plot_options.is_eig     = false;
plot_options.points_size = 30;
plot_options.cmap       = cmap;
plot_options.title      = 'S-Curve';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);


%% 4) S-curve non-homogeneous density

% Options
dataset_options                    = [];
dataset_options.numberOfPoints     = 2000;
dataset_options.name               = 'scurve_mixed_density';
dataset_options.plot               = false;

% Generate dataset
[X, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options);


% Plot original data
plot_options             = [];
plot_options.is_eig      = false;
plot_options.points_size = 30;
plot_options.cmap        = cmap;
plot_options.title       = 'S-Curve Mixed';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% 5) Half sphere

% Options
dataset_options                    = [];
dataset_options.numberOfPoints     = 2000;
dataset_options.name               = 'sphere_hole';
dataset_options.plot               = false;

% Generate dataset
[X, labels, updated_N, cmap] = ml_generate_manifold_dataset(dataset_options);

% Plot original data
plot_options             = [];
plot_options.is_eig      = false;
plot_options.points_size = 30;
plot_options.cmap        = cmap;
plot_options.title       = 'Half-Sphere';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);

%% 6) Broken Swissroll

% Options
options                 = [];
options.numberOfPoints  = 500;
options.name            = 'swissroll_broken';
options.plot            = false;

% Generate dataset
[X,labels,updated_N,cmap] = ml_generate_manifold_dataset(options);

% Plot original data
plot_options             = [];
plot_options.is_eig      = false;
plot_options.points_size = 30;
plot_options.labels      = labels;
plot_options.title       = 'Sphere w/Hole';

if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X,plot_options);
