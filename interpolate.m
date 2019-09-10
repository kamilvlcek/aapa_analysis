function x = interpolate(t0, t1, t, x0, x1)
% returns position x between 2 points (x0, x1 and t0, t1) in time t

if x0 == x1
    x = x0;
else
    x = (((t-t0)/(t1-t0)) * (x1-x0)) + x0;
end

end