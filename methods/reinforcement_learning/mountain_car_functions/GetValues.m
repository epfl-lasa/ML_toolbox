function [ V ] = GetValues( Q , knn , p )
%GETVALUE Summary of this function goes here
%   Detailed explanation goes here

V = Q(knn,:)' * p ;

end


