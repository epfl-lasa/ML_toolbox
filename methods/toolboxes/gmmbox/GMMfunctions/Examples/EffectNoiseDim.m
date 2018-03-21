%% Make one dimension of singal Gaussian noise and see how the
%% conditional is effected.

Mu = zeros(2,3);
Mu(:,1) = [0.2 -1]';
Mu(:,2) = [0.22  0]';
Mu(:,3) = [0.14 1]';

Sigma = zeros(2,2,3);

cov_type = 'spherical';

if strcmp(cov_type,'full')
    
    Sigma(:,:,1) = [1 0.5; 0.5 1];
    Sigma(:,:,2) = [1 -0.5; -0.5 1];
    Sigma(:,:,3) = [1 0.1; 0.1 2];
    
elseif strcmp(cov_type,'diagonal')
    
    Sigma(:,:,1) = [1  0; 0 2];
    Sigma(:,:,2) = [2  0; 0 1.5];
    Sigma(:,:,3) = [1.5  0; 0 2];
    
else
    
    Sigma(:,:,1) = [1  0; 0 1];
    Sigma(:,:,2) = [2  0; 0 2];
    Sigma(:,:,3) = [0.2  0; 0 0.2];
    
end

Sigma = Sigma .* 0.01;

Priors = ones(1,3)./3;

%% Plot GMM setup
%% Query point and take conditional

x                       = [0,0.2,0.5];
Priors_x = cell(length(x),1);
Mu_x     = Priors_x;
Sigma_x  = Mu_x;


for i=1:length(x)
    [Priors_c,Mu_c,Sigma_c] = GMC(Priors, Mu, Sigma, x(i), 1, 2);
    Priors_x{i} = Priors_c;
    Mu_x{i}     = squeeze(Mu_c(:,1,:))';
    Sigma_x{i}  = squeeze(Sigma_c);
end


%% Plot conditional

close all;
subplot(1,2,1);
hold on; grid on;
for i = 1:length(Priors)
    plot_gaussian_contour(gca,Mu(:,i)',Sigma(:,:,i));
end
axis equal;
xlabel('noise variable');
ylabel('control output');

subplot(1,2,2);
color = {'-r','-g','-b'};
hold on;grid on;
for i=1:length(x)
    
    [xs,ys] =  plot_gmm_1D(Priors_x{i},Mu_x{i},Sigma_x{i});
    %ys= ys./sum(ys);
    h(i) = plot(xs,ys,color{i});
end
xlabel('control output');
legend(h,'0','0.2','0.5');


