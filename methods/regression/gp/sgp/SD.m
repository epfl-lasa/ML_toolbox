function SD
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
%% the training data samples
Inset=30;
dataindex=randsample(datasize,Inset);
xI=x(dataindex);
yI=y(dataindex);
plot(xI,yI,'b+'),hold on;
%  x(dataindex)=[];
%  y(dataindex)=[];
x=xI;
y=yI;
K_mat=Kernel_func(x,x,0.7,1.2)+var_noise*eye(Inset);
% [vecmat,valmat]=eig(K_mat);
% valmat=diag(valmat);
% [valmat,ix]=sort(valmat,'descend');
% vecmat=vecmat(:,ix);
L=chol(K_mat,'lower');
%%
testnum=500;
x_test=linspace(-15,15,testnum)';
K_test_train=Kernel_func(x_test,x,0.7,1.2);
K_test=Kernel_func(x_test,x_test,0.7,1.2);

f_mean=K_test_train*(L'\(L\y));
for i=1:testnum
K_ss=Kernel_func(x_test(i),x_test(i),0.7,1.2);
K_s=Kernel_func(x_test(i),x,0.7,1.2);
v=L\K_s';
  f_var(i)=K_ss-v'*v;
end
f_var=f_var';
plot(x_test,f_mean,'b-','LineWidth',2),hold on;
%%
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
xlabel('SD with 30 points ')
set(gca,'XTick',[-15:3:15])
matlab2tikz( 'SubData30.tex' )

