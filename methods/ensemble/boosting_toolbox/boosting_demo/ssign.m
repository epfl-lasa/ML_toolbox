%Does a few useful mappings:
%ssign(true) = 1
%ssign(false) = -1
%ssign(-0.1) = -1
%ssign(0.1) = 1
%ssign(0) = -1
%So map from logical to polar {0, 1} -> {-1, 1}
%Or use as a sign function with an arbitrary sign at 0: ssign(x) (- {-1, 1}
%instead of ssign(x) (- {-1, 0, 1}
function y = ssign(x)

y = ((x > 0) * 2) - 1;

end