function linear_reg
%% the example fuction
datasize=200;
var_noise=0.1;
x=linspace(-10,10,datasize)';
    f=sin(x)./x;
noise=var_noise*randn(datasize,1);
y=f+noise;
x_raw=x;
% plot(x_raw,f,'r-','LineWidth',2),hold on;
%% the training data samples
Inset=30;
dataindex=randsample(datasize,Inset);
xI=x(dataindex);
yI=y(dataindex);
% plot(xI,yI,'b+'),hold on;
%  x(dataindex)=[];
%  y(dataindex)=[];
x=xI;
y=yI;
mu=2;
lamda=10;
K_mat=Kernel_func(x,x,mu,lamda)+var_noise*eye(Inset);
% [vecmat,valmat]=eig(K_mat);
% valmat=diag(valmat);
% [valmat,ix]=sort(valmat,'descend');
% vecmat=vecmat(:,ix);
L=chol(K_mat,'lower');
%%
testnum=500;
x_test=linspace(-15,15,testnum)';
K_test_train=Kernel_func(x_test,x,mu,lamda);
K_test=Kernel_func(x_test,x_test,mu,lamda);

f_mean=K_test_train*(L'\(L\y));
for i=1:testnum
K_ss=Kernel_func(x_test(i),x_test(i),mu,lamda);
K_s=Kernel_func(x_test(i),x,mu,lamda);
v=L\K_s';
  f_var(i)=K_ss-v'*v;
end
f_var=f_var';
plot(x_test,f_mean,'g-','LineWidth',2),hold on;
% PlotAxisAtOrigin(x_test,f_mean)
%%
xlabel('X')
ylabel('Y')
set(gca,'XTick',[-15:3:15])
matlab2tikz( 'SubData30.tex' )

