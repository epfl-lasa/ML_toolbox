function [ d ] = edist( x , y )
%edist euclidean distance between two vectors

d = sqrt( sum( (x-y).^2,2 ) );
