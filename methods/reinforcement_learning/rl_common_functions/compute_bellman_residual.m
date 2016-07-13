function [ res ] = compute_bellman_residual(fqi_option)
%COMPUTE_BELLMAN_RESIDUAL Summary of this function goes here
%   Detailed explanation goes here


nfq_Qk1 = initialise_nfq('split',2);
nfq_Qk2 = initialise_nfq('split',2);

N       = size(fqi_option.qs,1);
   

res = zeros(N-1,1);

for k=2:N
   
   nfq_Qk1 = get_Q(nfq_Qk1,fqi_option,k);
   nfq_Qk2 = get_Q(nfq_Qk2,fqi_option,k-1);
    
   res(k-1) = bellman_residual(nfq_Qk1,nfq_Qk2);  
  
end


end

function nfq_Q = get_Q(nfq_Q,fqi_option,k)

   if iscell(nfq_Q) 
%        fqi_option.qs{k,1}{1}.IW{1}
       for j=1:size(nfq_Q,1)
  %         nfq_Q{j}       =  fqi_option.qs{k,1}{j};
            nfq_Q{j}.net.IW  = fqi_option.qs{k,1}{j}.IW;
            nfq_Q{j}.net.LW  = fqi_option.qs{k,1}{j}.LW;
            nfq_Q{j}.net.b   = fqi_option.qs{k,1}{j}.b;
       end
   else
%        nfq_Q.net.IW = fqi_option.qs{k,1}.IW;
%        nfq_Q.net.IW = fqi_option.qs{k,1}.LW;
%        nfq_Q.net.IW = fqi_option.qs{k,1}.b;
   end
  
   
end

