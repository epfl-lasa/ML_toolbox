%% Take the conditional of a Gaussian Mixture Model P(x|y)
clear all;
%% Generate GMM from data

rot_mat = @(theta) [cos(theta), -sin(theta);sin(theta) cos(theta)];

Priors       = [0.5,0.5];
Mu(:,1)      = [-2 0]';
Mu(:,2)      = [2 1]';
Sigma        = [];
Sigma(:,:,1) = rot_mat(pi/5) * [3,0;0,0.1];
Sigma(:,:,2) = rot_mat(-pi/5) * [3,0;0,0.1];


%% Condition the GMM at x = [-3,0,2]

x     = [-3,0,2];
in    = 1;

if in == 1
   out = 2;
else
   out = 1; 
end

disp('------------');
disp(['in:  ' num2str(in)  ]);
disp(['out: ' num2str(out) ]);


[Priors_c,Mu_c,Sigma_c] = GMC(Priors, Mu, Sigma, x, in, out);
Mu_c                    = squeeze(Mu_c)';

%% Plot the Conditional of the GMM and one of the three samples

s        = 2; % sample 1

Priors_x = Priors_c(s,:); 
Mu_x     = squeeze(Mu_c(:,s))';
Sigma_x  = squeeze(Sigma_c);


close all;
figure; 
subplot(1,2,1);
hold on; grid on;
plot_gmm_contour(gca,Priors,Mu,Sigma,[0 0 1]);


if in == 1
    Y = linspace(-5,5,100);
    X = repmat(x(s),1,100);hold on;
else
    X = linspace(-5,5,100);
    Y = repmat(x(s),1,100);hold on;
end
plot(X,Y,'-r');

if out == 1
    plot(Mu_x(1),x(s),'or');
    plot(Mu_x(1) + 3 .* sqrt(Sigma_x(1)),x(s),'or');
    plot(Mu_x(1) - 3 .* sqrt(Sigma_x(1)),x(s),'or');
else
    plot(x(s),Mu_x(2),'or');
    plot(x(s),Mu_x(1) + 3 .* sqrt(Sigma_x(1)),'or');
   plot(x(s),Mu_x(1) - 3 .* sqrt(Sigma_x(1)),'or');
end

xlabel('x','FontSize',14);
ylabel('y','FontSize',14);
axis equal;


subplot(1,2,2);hold on; grid on;
[xs,ys] = plot_gmm_1D(Priors_x,Mu_x,Sigma_x);
plot(xs,ys,'-r');
%xlim([min(Y) max(Y)]);

if(out == 2)
    xlabel('y');
    ylabel(['P(y|x=' num2str(x(s)) ')']);
else
    xlabel('x');
    ylabel(['P(x|y=' num2str(x(s)) ')']);
end


%% Take conditional
x        = 0;
in       = 1;
out      = 2;

[Priors_c,Mu_c,Mu_c] = GMC(Priors, Mu, Sigma, x, in, out);
bConditional            = true;

%%

nbStates = 2;
out      = 1;
in       = 2;
nbData   = 1;

x        = -0;

% Compute new Mu
for j=1:nbStates
  y_tmp(:,:,j) = repmat(Mu(out,j),1,nbData) + Sigma(out,in,j)*inv(Sigma(in,in,j)) * (x-repmat(Mu(in,j),1,nbData));
end
% Compute new covariance 
for j=1:nbStates
  Sigma_y_tmp(:,:,1,j) = Sigma(out,out,j) - (Sigma(out,in,j)*inv(Sigma(in,in,j))*Sigma(in,out,j));
end

% Compute new weights
for i=1:nbStates
  Pxi(:,i) = Priors(i).*gaussPDF(x, Mu(in,i), Sigma(in,in,i));
end
beta = Pxi./repmat(sum(Pxi,2)+realmin,1,nbStates);



%%

beta_tmp = reshape(beta,[1 size(beta)]);
y_tmp2 = repmat(beta_tmp,[length(out) 1 1]) .* y_tmp;
y = sum(y_tmp2,3);


