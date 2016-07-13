% Installation file. Adds local folders to path.

fprintf('Adding KMBOX folders to Matlab path... ')

addpath(genpath(fullfile(pwd,'lib')));

fprintf('done.\n')
disp('Type "savepath" if you wish to store changes.')
% savepath;
