function [v,alpha] = gmc_velocity(w,V,vtmp)
%GMC_VELOCITY Computes the direction velocity given a set of weights and
% assoicated velocity modes and the previously applied velocity.
%
%   input -----------------------------------------------------------------
%
%       o w     :  (1 x K), set of K weights; sum(w) = 1
%
%       o V     :  (K x D), set of K velocities of dimension D;
%                           normr(D) = 1.
%       
%       o vtmp  :  (1 x D), previous applied velocity; norm(vtmp) = 1
%
%   output ----------------------------------------------------------------
%
%       o v     : (1 x D), output control velocity (normalised)
%
%   comments --------------------------------------------------------------
%   
%   The objective of this function is to keep a consistency of the control 
%   velocities. When we have a multi-modal distribution over output
%   velocities, taking the the expectation can lead to a net velocity of
%   zero.
%

[K,D] = size(V);

% (D x 1)
vtmp = vtmp(:)'; 

% (K x 1)
alpha = exp(-1*acos(sum(V .* repmat(vtmp,K,1),2)));
alpha = alpha(:) .* w(:);
alpha = alpha / sum(alpha);
v     = sum(repmat(alpha,1,D) .* V);
v     = v./(norm(v)+realmin);


end

