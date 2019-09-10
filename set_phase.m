function f = set_phase(time)
% returns phase number based on time


% end of each phase
f0 = 60;
f1 = 240;
f2 = 420;


if time >= f0 && time < f1
        f = 2;
elseif time >= f1 && time < f2
        f = 3;
elseif time >= f2
        f = 4;
else
    f = 1;
end


end