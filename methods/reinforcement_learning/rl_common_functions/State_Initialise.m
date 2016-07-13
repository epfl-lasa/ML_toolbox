function [ x ] = State_Initialise( start_type )
%STATE_INITIALISE Summary of this function goes here
%   Detailed explanation goes here

if strcmp(start_type,'random') == true
  x    =  init_state([-1,0.4],[-0.07,0.07]); %[x,xp]'
elseif strcmp(start_type,'semi-random') == true
  x    =  init_state([-1,0],[-0.007,0.007]); %[x,xp]'
else
    initial_position = -0.5;
    initial_speed    =  0.0;
    x     = [initial_position,initial_speed];
end

end


function x = init_state(sr,ar)

x(1) = sr(1) + (sr(2)-sr(1)).*rand(1,1);


x(2) = ar(1) + (ar(2)-ar(1)).*rand(1,1);

end

