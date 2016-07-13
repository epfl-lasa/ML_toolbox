function [ xp ] = DoAction( force, x )
%MountainCarDoAction: executes the action (a) into the mountain car
%environment
% a: is the force to be applied to the car
% x: is the vector containning the position and speed of the car
% xp: is the vector containing the new position and velocity of the car


position = x(1);
speed    = x(2); 

% bounds for position
bpleft=-1.5; 
bpright=0.5;

% bounds for speed
bsleft=-0.07; 
bsright=0.07;

 
speedt1= speed + (0.001*force) + (-0.0025 * cos( 3.0*position) );	 
%speedt1= speedt1 * 0.999; % thermodynamic law, for a more real system with friction.

if(speedt1<bsleft) 
    speedt1=bsleft; 
end
if(speedt1>bsright)
    speedt1=bsright; 
end

post1 = position + speedt1; 

if(post1<=bpleft)
    post1=bpleft;
    speedt1=0.0;
end

if(post1>=bpright)
    post1=bpright;
    speedt1=0.0;
end
xp=[];
xp(1) = post1;
xp(2) = speedt1;







