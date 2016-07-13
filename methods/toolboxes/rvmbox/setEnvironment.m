% SETENVIRONMENT	Set value of "global" variable
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function setEnvironment(varargin)

switch nargin
  %
 case 0,
  % Initialise
  VA.Version = 0.2;
  set(0,'UserData',VA);
  %
 case 2,
  variable	= varargin{1};
  value		= varargin{2};
  % Get the current structure from root
  VA = get(0,'UserData');
  % Create/edit the field
  VA.(variable) = value;
  % Store it again
  set(0,'UserData',VA)
  %
 case 3,
  variable	= varargin{1};
  subvariable	= varargin{2};
  value		= varargin{3};
  % Get the current structure from root
  VA = get(0,'UserData');
  % Create/edit the field
  VA.(variable).(subvariable) = value;
  % Store it again
  set(0,'UserData',VA)
  %
end



