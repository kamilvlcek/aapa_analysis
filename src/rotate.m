function [x_rot, y_rot] = rotate(x, y, angle)
%rotates point[x,y] by angle in degrees

x_rot = x * cosd(angle) + y * sind(angle);
y_rot = x * -1 * sind(angle) + y * cosd(angle);

end