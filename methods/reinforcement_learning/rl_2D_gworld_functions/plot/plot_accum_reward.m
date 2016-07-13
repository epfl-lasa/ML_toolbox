function p_h = plot_accum_reward(num_episodes,rs, p_h)
%PLOT_ACCUM_REWARD Plot the accumulated reward
%
%   input -----------------------------------------------------------------
%
%       o ax            : axis handle
%
%       o num_episodes : (1 x 1),            number of episodes
%
%       o rs           : (1 x num_episodes), average rewards
%
%       o p_h          : plot handle
%

xs = 1:num_episodes;

if ~exist('p_h','var')
    
    p_h = plot(xs,rs,'-r');
    title('Average reward');
    xlabel('episodes');
    
else
    
    set(p_h,'XData',xs,'YData',rs);
    
end


end

