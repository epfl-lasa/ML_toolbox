function data = ml_generate_mouse_data(limits, varargin)
% GENERATE_MOUSE_DATA(NTH_ORDER, N_DOWNSAMPLE) request the user to give
% demonstrations of a trajectories in a 2D workspace using the mouse cursor
% The data is stored in an [x ; dx/dt] structure  
% The data isdownsampled by N_DOWNSAMPLE samples

%   # Authors: Klas Kronander, Wissam Bejjani and Jose Medina
%   # EPFL, LASA laboratory
%   # Email: jrmout@gmail.com

%
struct_output = 0;
if nargin>1
    struct_output = 1;
    disp('Draw some data (w/labels) with the mouse on the figure.')
else
    disp('Draw some data (for regression) with the mouse on the figure.')
end

%% Drawing plot
fig = figure();
view([0 90]);
hold on;

axis(limits);
delete_trace = 0;
start_dem = 1;

% to store the data
X = [];
% flag for signaling that the demonstration has ended
demonstration_index = 0;
demonstration_index_monitor = 0;
% Colors for labels
colors = hsv(10);
% Labels
label_id = 1;
cleared_data = 0;

% select our figure as gcf
figure(fig);
hold on
% disable any figure modes
zoom off
rotate3d off
pan off
brush off
datacursormode off

set(fig,'WindowButtonDownFcn',@(h,e)button_clicked(h,e));
set(fig,'WindowButtonUpFcn',[]);
set(fig,'WindowButtonMotionFcn',[]);
set(fig,'Pointer','circle');
hp = gobjects(0);

% Stop button
stop_btn = uicontrol('style','pushbutton','String', 'Store Data','Callback',@stop_recording, ...
          'position',[0 0 110 25], ...
          'UserData', 1);

% Label button
label_btn = uicontrol('style','pushbutton','String', 'Change Label','Callback',@change_label, ...
          'position',[150 0 210 25], ...
          'UserData', 1);            

% Clear button
uicontrol('style','pushbutton','String', 'Clear','Callback',@clear_data, ...
          'position',[400 0 110 25], ...
'UserData', 1);      
        
% wait until demonstration is finished
while( (get(stop_btn, 'UserData') == 1))
    pause(0.01);
    if demonstration_index ~= demonstration_index_monitor
        x_obs{demonstration_index} = X;
        labels{demonstration_index} = label_id * ones(1, size(X, 2)); % DONNOT USE LENGTH
        X = [];
        demonstration_index_monitor = demonstration_index;
        set(fig,'WindowButtonDownFcn',@(h,e)button_clicked(h,e));
        set(fig,'WindowButtonUpFcn',[]);
        set(fig,'WindowButtonMotionFcn',[]);
        set(fig,'Pointer','circle');
    end
end
n_demonstrations = demonstration_index_monitor;

%% Savitzky-Golay filter and derivatives
%   x :             input data size (time, dimension)
%   dt :            sample time
%   nth_order :     max order of the derivatives 
%   n_polynomial :  Order of polynomial fit
%   window_size :   Window length for the filter
data = [];
start_dem = 1 + cleared_data;
for dem = start_dem:n_demonstrations         
    x_obs_dem = x_obs{dem}(1:2,:)';
    if (struct_output)
        data = [data  [x_obs{dem}(1:2,:); labels{dem}] ];
    else
        dt = mean(diff(x_obs{dem}(3,:)')); % Average sample time (Third dimension contains time)
        dx_nth = sgolay_time_derivatives(x_obs_dem, dt, 2, 3, 21);
        data = [data [dx_nth(:,:,1),dx_nth(:,:,2)]'];
    end
end
return

%% Functions for data capture
% Clear data button function
function clear_data(ObjectS, ~)
    data = [];
    X = [];
    label_id = 1;
    cleared_data = demonstration_index;
    set(ObjectS, 'UserData', 0); % unclick button
    delete(hp);
end
    
    
function stop_recording(ObjectS, ~)
    set(ObjectS, 'UserData', 0);
end

function change_label(ObjectS, ~)
    label_id = label_id + 1;
end

function ret = button_clicked(~,~)
    if(strcmp(get(gcf,'SelectionType'),'normal'))
        start_demonstration();
    end
end

function ret = start_demonstration()
    disp('Started demonstration');
    tic;
    %------------------------------------------------------------------
    % Print current point when mouse button pressed.
    % For printing when releasing mouse button released, place these
    % lines at the beginning of stop_demonstration function)
    x = get(gca,'Currentpoint');
    x = x(1,1:2)';
    x = [x;toc];
    X = [X, x];
    hp = [hp, plot(x(1),x(2), '.' ,'markersize',20, 'Color', colors(label_id,:))];
    %------------------------------------------------------------------
    set(gcf,'WindowButtonMotionFcn',@record_current_point);
    set(gcf,'WindowButtonUpFcn',@stop_demonstration);
    ret = 1;
end

function ret = stop_demonstration(~,~)
    disp('Stopped demonstration. Press stop recording in the figure if you have enough demonstrations.');
    set(gcf,'WindowButtonMotionFcn',[]);
    set(gcf,'WindowButtonUpFcn',[]);
    set(gcf,'WindowButtonDownFcn',[]);
    if(delete_trace)
        delete(hp);
    end
    demonstration_index = demonstration_index + 1;
end

function ret = record_current_point(~,~)
    x = get(gca,'Currentpoint');
    x = x(1,1:2)';
    x = [x;toc];
    X = [X, x];
    hp = [hp, plot(x(1),x(2), '.' ,'markersize',20, 'Color', colors(label_id,:))];
end
end


