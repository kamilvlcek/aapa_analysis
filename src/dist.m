function output = dist(point1, point2)
% DIST - Calculates distance between point1 and point 2  
% Inputs:
%   point1 - [x y] coordinates of point 1 
%   point2 - [x y] coordinates of point 2 
% Output:
%   output - cartesian distance between points

output = sqrt((point2(1) - point1(1))^2 + (point2(2) - point1(2))^2);

end