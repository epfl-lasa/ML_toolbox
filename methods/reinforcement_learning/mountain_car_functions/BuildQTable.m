function [ Q ] = BuildQTable( nstates,nactions )
%BuildQTable do exactly this
%Q: the returned initialized QTable

Q = zeros(nstates,nactions);
%Q = zeros(nstates,nactions)-1; % a variant
%Q = zeros(nstates,nactions)+1; % another variant
%Q = rand(nstates,nactions)-0.5; % a variant