function [lower_ind, higher_ind] = get_closest(time, event) 
% returns index of closest lower and closest higher point to event in time

    for j = 1:length(time)
        if time(j) > event
            if j == 1
                higher_ind = j;
                lower_ind = j;
                break
            else
                higher_ind = j;
                lower_ind = j-1;
                break
            end
        elseif time(length(time)) < event
            higher_ind = length(time);
            lower_ind = length(time);
            break
        elseif time(length(time)) == event
            higher_ind = length(time);
            lower_ind = length(time);
            break
        end
    end
end


