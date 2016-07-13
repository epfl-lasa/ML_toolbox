function [ x ] = Initialise_pos_vel(N,sr,ar)
%INITIALISE_POS_VEL Summary of this function goes here
%   Detailed explanation goes here
a    = sr(1);
b    = sr(2);
x(:,1) = a + (b-a).*rand(N,1);

a    = ar(1);
b    = ar(2);
x(:,2) = a + (b-a).*rand(N,1);


end

