% Script to run all demos consecutively.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2015.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

clear
close all

% get list of test functions
fdir = fileparts(which('km_run_all_demos.m'));
files = dir(fullfile(fdir,'km_demo_*.m'));
[~,allfiles] = cellfun(@fileparts, {files.name}, 'UniformOutput',0);

t1 = tic;
fprintf('\n')
for i=1:length(allfiles)
    close all
    clear eval
    save(fullfile(tempdir,'temp.mat'),'i','allfiles','t1');
    
    % run script
    fname_demo = allfiles{i};
    fprintf('\nRunning %s\n',fname_demo);
    eval(fname_demo);
    
    load(fullfile(tempdir,'temp.mat'));
end
delete(fullfile(tempdir,'temp.mat'));
toc(t1)

close all
