function [ r,f ] = GetReward( x )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
    
position = x(1);
% bound for position; the goal is to reach position = 0.5
bpright=0.5;
f=false;
r=-1;


if( position >= bpright) 
	r = 100;
    f = true;
end

    
   


    
