%% Generate GMMs


%% Sample gmms


nbGMMs = 1;

GMMs = cell(1,nbGMMs);
true_positions = zeros(1,nbGMMs);

for i=1:nbGMMs

    
a = 50; b = 100;
K = floor(a + (b-a).*rand);

tmp = zeros(3,K);

tmp(1,:) = ones(1,K)./K;


a = 100;
b = 200;
tmp(2,:) =(a + (b-a).*rand(1,K));

tmp(3,:) = ones(1,K);

a = 5; b = 50;
for k=1:K
    tmp(3,k) = tmp(3,k) * (a + (b-a).*rand);
end

GMMs{i} = tmp;
true_positions(i) = gmm_sample(1,tmp(1,:),tmp(2,:),tmp(3,:));


end


% Plot GMMs


close all;
figure;
hold on;
xs = linspace(0,300,1000);

for i=1:size(GMMs,2)
    tmp = GMMs{i};
    ys = gmm_pdf(xs,tmp(1,:),tmp(2,:),tmp(3,:));
    plot(xs,ys,'Color',rand(1,3));
    
end


%% Save GMMs

%path_to_save = '/home/guillaume/MatlabWorkSpace/MRFF-cpp/time_complexity/GMMs/';
path_to_save = '/home/guillaume/MatlabWorkSpace/DiscreteMultipleBelief/discrete_gaussian_test/GMMs/gmm_o2/';


tag = 1;
for i=1:size(GMMs,2)
    gmm = GMMs{i}';
    save([path_to_save 'gmm_' num2str(tag) '_.txt'],'gmm','-ascii');
    tag = tag + 1;
end



