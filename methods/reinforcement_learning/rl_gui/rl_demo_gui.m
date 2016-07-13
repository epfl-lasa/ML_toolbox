function varargout = rl_demo_gui(varargin)
% RL_DEMO_GUI MATLAB code for rl_demo_gui.fig
%      RL_DEMO_GUI, by itself, creates a new RL_DEMO_GUI or raises the existing
%      singleton*.
%
%      H = RL_DEMO_GUI returns the handle to a new RL_DEMO_GUI or the handle to
%      the existing singleton*.
%
%      RL_DEMO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RL_DEMO_GUI.M with the given input arguments.
%
%      RL_DEMO_GUI('Property','Value',...) creates a new RL_DEMO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rl_demo_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rl_demo_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rl_demo_gui

% Last Modified by GUIDE v2.5 11-May-2016 09:31:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rl_demo_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rl_demo_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before rl_demo_gui is made visible.
function rl_demo_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rl_demo_gui (see VARARGIN)

% Choose default command line output for rl_demo_gui
handles.output{1} = hObject;

%%%

grid_world = varargin{1};
Reward     = varargin{2};
agent_pos  = varargin{3};
reward_f   = varargin{4};

actions    = [1 0; -1 0;  0 1;  0 -1];


%% initialise agent

[agent_pos,s]   = grid_world.discretise_state(agent_pos);
agent_orient    = [0 1];
agent_radius    = 0.3;

%% initialise Qtable

alpha   = 0.1;
gamma   = 0.9;
qtable  = Qtable(grid_world.num_states,4,alpha,gamma);


%% First plot

axes(handles.axes1);
grid_world.plot_grid();
h_a             = plot_round_agent(handles.axes1,agent_pos,agent_orient,agent_radius,[],[]);  hold on;
rl_plot_policy  = @(Q,h)rl_2D_plot_policy(grid_world.X(:),grid_world.Y(:),Q,actions,grid_world.delta(1),grid_world.delta(2),h);
h_policy        = rl_plot_policy(qtable.Q,[]);

Reward.plot_goal_state();
Reward.plot_firpit();

axes(handles.axes2);
h_Q = plot_qtable(handles.axes2,qtable.Q,grid_world.X,grid_world.Y);

axes(handles.axes3);
p_h = plot_accum_reward(1,0);

%% Store parameters 

% RL parameters
rl_parameters             = [];
rl_parameters.alpha       = alpha;
rl_parameters.gamma       = gamma;
rl_parameters.qtable      = qtable;
rl_parameters.maxiter     = 1000;
rl_parameters.reward      = reward_f;
rl_parameters.method      = 'SARSA';
rl_parameters.qinit       = 'random';

% Agent parameters

agent_param              = [];
agent_param.agent_pos    = agent_pos;
agent_param.agent_orient = agent_orient;
agent_param.agent_radius = agent_radius;

% Plot parameters
plot_parameters                 = [];
plot_parameters.h_a             = h_a;
plot_parameters.h_Q             = h_Q;
plot_parameters.p_h             = p_h;
plot_parameters.h_policy        = h_policy;
plot_parameters.rl_plot_policy   = rl_plot_policy;

global bPlot_RL;
global bStop_loop;

handles.grid_world       = grid_world;
handles.Reward           = Reward;
handles.rl_parameters    = rl_parameters;
handles.agent_param      = agent_param;
handles.plot_parameterse = plot_parameters;
handles.actions          = actions;
handles.qtable           = qtable;

handles.output{2}        = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rl_demo_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rl_demo_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rl_parameters               = handles.rl_parameters;
agent_param                 = handles.agent_param ;
plot_parameters             = handles.plot_parameterse;
rl_parameters.num_episodes  = handles.num_episodes;
rl_parameters.p_noise       = handles.p_noise;
rl_parameters.qinit         = handles.qinit;

if strcmp(rl_parameters.method,'Value-Iteration')
    
    
   p_noise   = handles.p_noise;

    gamma    = rl_parameters.gamma;
    actions  = handles.actions;
    reward   = rl_parameters.reward;
    h_policy = plot_parameters.h_policy;
    h_Q      = plot_parameters.h_Q;
    
   [P,N,R]   = rl_create_PR_models(handles.grid_world,actions,reward,p_noise);

    
    V        = zeros(handles.grid_world.num_states,1);
    [V,U]    = rl_value_iteration(V,actions,P,reward,N,gamma,0.000000000001);
       
    % Plot policy
    axes(handles.axes1);
    rl_2D_plot_policy_uw(0.5 .* U,handles.grid_world.X,handles.grid_world.Y,h_policy);
    
    
    % Plot value function
    axes(handles.axes2);
    plot_qtable(handles.axes2,V,handles.grid_world.X,handles.grid_world.Y,h_Q);

else
    
    rl_run_loop(rl_parameters,agent_param,plot_parameters,handles);

end






function edit_learning_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_learning_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rl_parameters.alpha = str2double(get(hObject,'String')); 
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_learning_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_learning_rate as a double


% --- Executes during object creation, after setting all properties.
function edit_learning_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_learning_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_discount_factor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_discount_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rl_parameters.gamma = str2double(get(hObject,'String')); 
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_discount_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_discount_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_exploration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global epsilon;
epsilon = str2double(get(hObject,'String')); 

% --- Executes during object creation, after setting all properties.
function edit_exploration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global epsilon;
epsilon    = str2double(get(hObject,'String'));



function edit_episodes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_episodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rl_parameters.episodes = str2double(get(hObject,'String')); 
guidata(hObject,handles);


function edit_episodes_CreateFcn(hObject, eventdata, handles)
handles.num_episodes    = str2double(get(hObject,'String'));
guidata(hObject,handles);

function edit_maxiter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rl_parameters.maxiter = str2double(get(hObject,'String')); 
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit_maxiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_visualise.
function radiobutton_visualise_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_visualise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bPlot_RL;
bPlot_RL = get(hObject,'Value'); 

% --- Executes during object creation, after setting all properties.
function radiobutton_visualise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_visualise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global bPlot_RL;
bPlot_RL = get(hObject,'Value'); 

% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bStop_loop;
bStop_loop = true;


% --- Executes on selection change in popupmenu_method.
function popupmenu_method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents            = cellstr(get(hObject,'String'));
handles.rl_parameters.method = contents{get(hObject,'Value')};
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipanel1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function figure1_ResizeFcn(hObject, eventdata, handles)

function figure1_WindowButtonDownFcn(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu_Qinit.
function popupmenu_Qinit_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Qinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
qinit    = contents{get(hObject,'Value')}; 

if strcmp(qinit,'Q-random')
    handles.qinit = 'random';
elseif strcmp(qinit,'Q-zeros')
    handles.qinit = 'zeros';  
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_Qinit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Qinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
contents = cellstr(get(hObject,'String'));
qinit    = contents{get(hObject,'Value')}; 

if strcmp(qinit,'Q-random')
    handles.qinit = 'random';
elseif strcmp(qinit,'Q-zeros')
    handles.qinit = 'zeros';  
end
guidata(hObject,handles);



function edit_noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.p_noise = str2double(get(hObject,'String')); 
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_noise as text
%        str2double(get(hObject,'String')) returns contents of edit_noise as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.p_noise = str2double(get(hObject,'String')); 
guidata(hObject,handles);


% --- Executes on selection change in popupmenu_value_reward.
function popupmenu_value_reward_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_value_reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String')); 
contents = contents{get(hObject,'Value')};


axes(handles.axes2);
h_Q         = handles.plot_parameterse.h_Q;
grid_world  = handles.grid_world;
reward_f    = handles.rl_parameters.reward;

if strcmp(contents,'Value')
    qtable     = handles.qtable;
    plot_qtable(handles.axes2,qtable.Q,grid_world.X,grid_world.Y,h_Q);   
    %handles.axes2.Title = 'Value function';
elseif strcmp(contents,'Reward')
    rl_2D_plot_reward(reward_f,grid_world,h_Q);
    %handles.axes2.Title = 'Reward function';
end


% --- Executes during object creation, after setting all properties.
function popupmenu_value_reward_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_value_reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
