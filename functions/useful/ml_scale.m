function [ x_scaled ] = ml_scale(x,a,b )
%ML_SCALE Summary of this function goes here
%   Detailed explanation goes here

x_scaled = (x-min(x))*(b-a)/(max(x)-min(x)) + a;
end

