function [x, y] = angle2point(x, y, len, angle)
%creates point2[x,y] in length and angle from point1

x = x - (len * cos(pi * angle /180));
y = y + (len * sin(pi * angle /180));

end