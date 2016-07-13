function [ states ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the mountain car problem
xdiv  = (0.55-(-1.5))   / 50.0;
xpdiv = (0.07-(-0.07)) / 50.0;

x = -1.5:xdiv:0.5;
xp= -0.07:xpdiv:0.07;

N=size(x,2);
M=size(xp,2);

states=[];
index=1;
for i=1:N    
    for j=1:M
        states(index,1)=x(i);
        states(index,2)=xp(j);
        index=index+1;
    end
end