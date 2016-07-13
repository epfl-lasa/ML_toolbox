function [X,labels] = ml_brokenswiss_data(n,noise)
%ML_BROKENSWISS_DATA 
%
%   input -----------------------------------------------------------------
%
%       o n : (1 x 1), the number of samples to be generated.
%       o noise : (1 x 1), the level of noise
%
%   output-----------------------------------------------------------------
%
%       o X           : (n x 3), data
%       o labels      : (n x 1), class of the data (0 or 1)
%

    t = [(3 * pi / 2) * (1 + 2 * rand(ceil(n / 2), 1) * .4); (3 * pi / 2) * (1 + 2 * (rand(floor(n / 2), 1) * .4 + .6))];  
    height = 30 * rand(n, 1);
    X = [t .* cos(t) height t .* sin(t)] + noise * randn(n, 3);
    labels(1:size((3 * pi / 2) * (1 + 2 * rand(ceil(n / 2), 1) * .4),1),1) = 0;
    labels(1+size((3 * pi / 2) * (1 + 2 * rand(ceil(n / 2), 1) * .4),1):size((3 * pi / 2) * (1 + 2 * rand(ceil(n / 2), 1) * .4),1)+size((3 * pi / 2) * (1 + 2 * (rand(floor(n / 2), 1) * .4 + .6)),1),1) = 1;
    t = [t height];

end
