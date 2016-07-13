% Rescale x to run from c to d when its values run from a to b:
function z = rescale(x,a,b,c,d)
z = -(-b*c + a*d)/(-a + b) + (-c + d)*x/(-a + b);
end

