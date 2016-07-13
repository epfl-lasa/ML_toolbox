function K_mat=Kernel_func(x,y,mu,lamda)
xdatasize=size(x,1);
ydatasize=size(y,1);
for i=1:xdatasize
        for j=1:ydatasize
       K_mat(i,j)=mu*exp(-norm(x(i)-y(j))^2/(2*lamda^2));
        end
    end            
end

