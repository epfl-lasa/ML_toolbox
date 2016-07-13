function Nystrom_method
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
x(dataindex)=[];
y(dataindex)=[];
x=[xI;x];
y=[yI;y];
%% the covariance matrix,kernel;
K_mat=Kernel_func(x,x,0.7,1.2);
K_mm=K_mat(1:Inset,1:Inset);

%%
[vecmat_m,valmat_m]=eig(K_mm);
valmat_m=diag(valmat_m);
[valmat_m,ix]=sort(valmat_m,'descend');
vecmat_m=vecmat_m(:,ix);
valmat_n=datasize/Inset*valmat_m;
prin_val=sum(valmat_n>0);

for i=1:prin_val;     
vecmat_n(:,i)=sqrt(Inset/datasize)/valmat_m(i)*K_mat(1:datasize,1:Inset)*...
    vecmat_m(:,i);
valmat_n(i)=datasize/Inset*valmat_m(i);
end

valmat_n=diag(valmat_n(1:prin_val)); 

new_kernel=inv(valmat_n)+vecmat_n'*1/var_noise*eye(datasize)*vecmat_n;
% rank(new_kernel)
L=chol(new_kernel,'lower');  %using cholesky decomposition to be more stable
%%test
testnum=500;
x_test=linspace(-15,15,testnum)';
K_test_train=Kernel_func(x_test,x,0.7,1.2);
K_test=Kernel_func(x_test,x_test,0.7,1.2);

b_temp=vecmat_n'*1/var_noise*eye(datasize)*y;
f_mean=K_test_train*(1/var_noise*eye(datasize)*y-1/var_noise*eye(datasize)*...
    vecmat_n*(L'\(L\b_temp)));
for i=1:testnum
K_ss=Kernel_func(x_test(i),x_test(i),0.7,1.2);
K_s=Kernel_func(x_test(i),x,0.7,1.2);
v=L\( vecmat_n'*1/var_noise*eye(datasize)*K_s');
  f_var(i)=K_ss-(K_s*1/var_noise*eye(datasize)*K_s'-v'*v);
%  f_var(i)=K_ss-K_s*(1/var_noise*eye(datasize)-1/var_noise*eye(datasize)*vecmat_n...
%      *inv(new_kernel)*vecmat_n'*1/var_noise*eye(datasize))*K_s';
end
f_var=f_var';

% in_pos=find(f_var>0);
% f_var=f_var(in_pos);
% x_test=x_test(in_pos);
% f_mean=f_mean(in_pos);

plot(x_test,f_mean,'b-','LineWidth',2),hold on;
%%plot the variance
x_area=[x_test;flipdim(x_test,1)];
ybound_std=[(f_mean+1.96*sqrt(f_var));flipdim(f_mean-1.96*sqrt(f_var),1)];
fill(x_area,ybound_std,[187 255 0]/255,'EdgeColor','none');
plot(x_raw,f,'r-','LineWidth',2),hold on;
plot(xI,yI,'b+'),hold on;
plot(x_test,f_mean,'b-','LineWidth',2),hold on;
%  alpha(0.6)
legend1=legend('target function','training points','preditive distribution','95% confidence interval');
 set(legend1,'Box','off','Color','none',...
     'Location','NorthEast');
xlabel('30 active training points')
set(gca,'XTick',[-15:3:15])
matlab2tikz( 'Nys_data30.tex' )
end
%%