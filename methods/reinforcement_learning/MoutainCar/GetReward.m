function [ r,f ] = GetReward( x )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
    
position = x(1);
% bound for position; the goal is to reach position = 0.45
%bpright=0.45;
bpright=0.5;
r = -1;
f = false;
% 0 in case of success, -1 for all other moves
if( position >= bpright) 
	r = 100;
    f = true;
end

if (position <= -1.5)
   r = -100; 
end

end


