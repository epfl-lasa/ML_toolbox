function [opt_vals, opt_ids] = ml_curve_opt(curve, method)
%ML_CURVE_OPT Returns optimal number of clusters from an RSS curve, 
% where the optimum is at the "elbow" of the curve. This can be computed 
% by two methods: 'derivatives' and 'line'.
%
%   input ----------------------------------------------------------------
%
%       o curve       : (1 x N), number of data points to generate.
%
%       o method      : 'string', method used to compute the 'elbow'
%
%   output ----------------------------------------------------------------
%
%       o opt_vals    : (1 x optimal_values), optimal RSS values.
%
%       o opt_ids     : (1 x optimal_values), optimal RSS index=K.
%

switch(method)
    % %%% Using derivatives
    case 'derivatives'
        % Compute first derivative
        d_curve = [0 diff(curve)];

        % Compute second derivative
        dd_curve = [0 diff(d_curve)];

        % Find maximum values
        [dd_vals, idx] = findpeaks(dd_curve);

        % Peak values
        [~, ids] = sort(dd_vals,'descend');

        % Return first 2 values with significant change
        opt_vals = dd_vals(ids(1:2)); % Maximum values of the second derivative
        opt_ids  = idx(ids(1:2));     % Indices of those maximum values  

   % %%%% Using distance to line
    case 'line'

        %# get coordinates of all the points
        nPoints = length(curve);
        allCoord = [1:nPoints;curve]';              %'# SO formatting

        %# pull out first point
        firstPoint = allCoord(1,:);

        %# get vector between first and last point - this is the line
        lineVec = allCoord(end,:) - firstPoint;

        %# normalize the line vector
        lineVecN = lineVec / sqrt(sum(lineVec.^2));

        %# find the distance from each point to the line:
        %# vector between all points and first point
        vecFromFirst = bsxfun(@minus, allCoord, firstPoint);

        %# To calculate the distance to the line, we split vecFromFirst into two 
        %# components, one that is parallel to the line and one that is perpendicular 
        %# Then, we take the norm of the part that is perpendicular to the line and 
        %# get the distance.
        %# We find the vector parallel to the line by projecting vecFromFirst onto 
        %# the line. The perpendicular vector is vecFromFirst - vecFromFirstParallel
        %# We project vecFromFirst by taking the scalar product of the vector with 
        %# the unit vector that points in the direction of the line (this gives us 
        %# the length of the projection of vecFromFirst onto the line). If we 
        %# multiply the scalar product by the unit vector, we have vecFromFirstParallel
        scalarProduct = dot(vecFromFirst, repmat(lineVecN,nPoints,1), 2);
        vecFromFirstParallel = scalarProduct * lineVecN;
        vecToLine = vecFromFirst - vecFromFirstParallel;

        %# distance to line is the norm of vecToLine
        distToLine = sqrt(sum(vecToLine.^2,2));

        %# find the maximum
        [opt_vals,opt_ids] = max(distToLine);

end







end