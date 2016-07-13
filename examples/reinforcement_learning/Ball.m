clc
close all
clear
%% The hyper parameters

X0=[-5 -5 0];
DX0=[5 5 10];
H_wind=1;
D_wind=[0.5 0.5 0.5];
M_wind=1;

%% Initialozations
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',24);
xlim(axes1,[-5 10]);
ylim(axes1,[-5 10]);
zlim(axes1,[0 10]);
view(axes1,[-37.5 30]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');
zlabel('Z [m]');
ylabel('Y [m]');
xlabel('X [m]');

dt=0.001;
D_wind=D_wind/norm(D_wind);
%% Calculating the ball trajectory

X=zeros(ceil(5/dt),3);
DX=zeros(ceil(5/dt),3);
G=[0 0 -9.81];
wind=[0 0 0];
DDX=zeros(ceil(5/dt),3);
WIND=zeros(ceil(5/dt),3);
X(1,:)=X0;
DX(1,:)=DX0;
DDX(1,:)=G;
i=1;
while X(i,3)>=0
    i=i+1;
    if X(i-1,3)>=H_wind
        wind=M_wind*(1-(1/(1+exp(100*(X(i-1,3)-H_wind)))))*D_wind;
        DDX(i,:)=G+wind;
    else
        DDX(i,:)=G;
    end
    DX(i,:)=DX(i-1,:)+DDX(i,:)*dt;
    X(i,:)=X(i-1,:)+DX(i,:)*dt;
    if rem(i,10)==0
        if (exist('P','var')==1)
            delete(P);
        end
        P=plot3(X(i,1),X(i,2),X(i,3),'MarkerSize',40,'Marker','.','LineWidth',24,...
            'LineStyle','none','Color',[0 0 1]);
        pause(0.001)
    end
end

figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',24);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');
zlabel('Z [m]');
ylabel('Y [m]');
xlabel('X [m]');

STEP=1;
[x,y,z]=meshgrid(min(X(:,1)):STEP:max(X(:,1)),min(X(:,2)):STEP:max(X(:,2)),...
    H_wind:STEP/2:2*max(X(:,3)));
for i=1:size(z,3)
    WINDZ(:,:,i)=M_wind.*(1-(2./(1+exp(0.1.*(z(:,:,i)-H_wind))))).*D_wind(1,3);
    WINDY(:,:,i)=M_wind.*(1-(2./(1+exp(0.1.*(z(:,:,i)-H_wind))))).*D_wind(1,2);
    WINDX(:,:,i)=M_wind.*(1-(2./(1+exp(0.1.*(z(:,:,i)-H_wind))))).*D_wind(1,1);
end
quiver3(x,y,z,WINDX,WINDY,WINDZ)
hold on
plot3(X(X(:,1)~=0,1),X(X(:,1)~=0,2),X(X(:,1)~=0,3),'LineWidth',3,...
    'LineStyle','-','Color',[1 0 0]);
