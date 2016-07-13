function [ s ] = DiscretizeState( x, statelist )
%DiscretizeState check which entry in the state list is more close to x and
%return the index of that entry.


[d  s] = min(dist(statelist,x'));

