function SR

clc;
clear;
close all;
%% the example fuction
datasize=200;
var_noise=0.1;
x=linspace(-10,10,datasize)';
    f=sin(x)./x;
noise=var_noise*randn(datasize,1);
y=f+noise;
x_raw=x;
plot(x_raw,f,'r-','LineWidth',2),hold on;
%%
Inset=30;
dataindex=randsample(datasize,Inset);
xI=x(dataindex);
yI=y(dataindex);
%%
%%test
testnum=500;
x_test=linspace(-15,15,testnum)';

K_mn=Kernel_func(xI,x,0.7,1.2);
K_mm=Kernel_func(xI,xI,0.7,1.2);
 rank(K_mm)
K_mat=K_mn*1/var_noise*eye(datasize)*K_mn'+K_mm;
K_sm=Kernel_func(x_test,xI,0.7,1.2);
L=chol(K_mat,'lower');
b=K_mn*1/var_noise*eye(datasize)*y;
f_mean=K_sm*(L'\(L\b));

for i=1:testnum
K_sm=Kernel_func(x_test(i),xI,0.7,1.2);
v=L\(K_sm');
  f_var(i)=v'*v;
end
f_var=f_var';

plot(x_test,f_mean,'b-','LineWidth',2),hold on;

x_area=[x_test;flipdim(x_test,1)];
ybound_std=[(f_mean+1.96*sqrt(f_var));flipdim(f_mean-1.96*sqrt(f_var),1)];
fill(x_area,ybound_std,[187 255 0]/255,'EdgeColor','none');
plot(x_raw,f,'r-','LineWidth',2),hold on;
plot(xI,yI,'b+'),hold on;
plot(x_test,f_mean,'b-','LineWidth',2),hold on;
%%
legend1=legend('target function','training points','preditive distribution','95% confidence interval');
 set(legend1,'Box','off','Color','none',...
     'Location','NorthEast');
xlabel('(f)SR with 30 points ')
xlim([-15,15]);
ylim([-2,2]);
set(gca,'XTick',[-15:3:15])
matlab2tikz( 'SubReg30.tex' )

