% SB1_DIAGNOSTIC	Output neat diagnostic info with verbosity control
%
%
% Copyright 2009 :: Michael E. Tipping
%
% This file is part of the SPARSEBAYES baseline implementation (V1.10)
%
% Contact the author: m a i l [at] m i k e t i p p i n g . c o m
%
function SB1_Diagnostic(level, message_, varargin)

Diagnostic = getEnvironment('Diagnostic');

INDENT	= '  ';
if level<=Diagnostic.verbosity
  tab_	= repmat(INDENT, 1, level);
  s_	= sprintf(message_,varargin{:});
  fprintf(Diagnostic.fid,'%s%s', tab_, s_);
end
