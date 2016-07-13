function  hp = plot_round_agent(hax,position,heading,radius,color,hp)
%PLOT_AGENT plots agent as a circle with a bar for the heading
%
%
%
% input -------------------------------------------------------------------
%
%
%   o hf: handle to figure in which to plot the agent
%
%   o positions: (1 x D), caretesian position
%
%   o heading:   (1 x 2), angle offset for x-axis in radians
%
%   o radius:    (1 X 1), size of the agent
%
%   o color:    (1 x 3), RBG of the agent
%
%   o hp: handle to the first instance of the plot, usefull for plotting in
%   a for loop
%

N = 1000;
THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+position(1);
Y=Y+position(2);

% heading_x   = rot(:,1);
% heading_y = rot(:,2);

x1 = position(:);
% x2 = radius * (heading_x(:)./norm(heading_x)) + x1;
% x3 = radius * (heading_y(:)./norm(heading_y)) + x1;
x2 = radius * heading(1)  + x1(1);
x3 = radius * heading(2)  + x1(2);

h_x = [x2,x3];


if isempty(hp)
    
    if ~exist(color,'var'), color = [1,0.7294,0];end
    
    
    hp = zeros(1,2);
    hold on;
    
    axes(hax);
    hp(1) = fill(X,Y,color);
    
    axes(hax);
   hp(2) = plot([x1(1),h_x(1)],[x1(2),h_x(2)],'-k','LineWidth',3);
   %hp(3) = plot(l2(1,:),l2(2,:),'-r','LineWidth',3);
    
    hold off;
    
else
    set(hp(1),'XData',X,'YData',Y);
    set(hp(2),'XData',[x1(1),h_x(1)],'YData',[x1(2),h_x(2)]);
  %  set(hp(3),'XData',l2(1,:),'YData',l2(2,:));

end


end


