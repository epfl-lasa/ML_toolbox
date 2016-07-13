% GETENVIRONMENT	Read value of "global" variable
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function value = getEnvironment(variable)

VA = get(0,'UserData');
if isfield(VA,variable)
  value = VA.(variable);
else
  value	= [];
end
