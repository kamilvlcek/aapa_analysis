function [distance, entrances, entrances_index, time_sect, dist_sect, ent_first, room_ent_all_X, room_ent_all_Y, arena_ent_all_X, arena_ent_all_Y] = output_f3(time, room_x, room_y, arena_x, arena_y, sector_x, sector_y)

ent_first_ent = 0; dist_sect = 0; time_sect = 0; ent_first_sess = 1; entrances = 0;
in_sect_prev = 0; n =1; room_ent = []; distance = 0; k = 1;
for i = 1:length(room_x)
    
    %distance
    if i>1 
        arena_p1 = [arena_x(i), arena_y(i)];
        arena_p2 = [arena_x(i-1), arena_y(i-1)];
        dist_par = dist(arena_p1, arena_p2);
        distance = distance + dist_par;
    end
    
    %forbiden sector data
    sector_x_point = [sector_x(i, 1),sector_x(i, 2), sector_x(i, 3), sector_x(i, 4)];
    sector_y_point = [sector_y(i, 1), sector_y(i, 2), sector_y(i, 3), sector_y(i, 4)];
    
    %register entrance
    in = inpolygon(room_x(i), room_y(i),sector_x_point, sector_y_point);
    if in == 1
        room_ent_all_X(k) = room_x(i);
        room_ent_all_Y(k) = room_y(i);
        arena_ent_all_X(k) = arena_x(i);
        arena_ent_all_Y(k) = arena_y(i);
        entrances_index(k) = i;
        
        k = k + 1;
        
        %first session entrance data
        if ent_first_sess == 1
            ent_first = time(i); %time of 1st entrance
            entrances = entrances + 1;
            ent_first_sess = 0;
            n = n+1;
            
        %first coordinates in entrance
        elseif ent_first_ent == 1
            entrances = entrances + 1; %number of entrances into sector
            ent_first_ent = 0;
            n = n+1;
        
        %entrance
        else
            arena_p1n = [arena_x(i), arena_y(i)];
            arena_p2n = [arena_x(i-1), arena_y(i-1)];
            
            dist_sect_par = dist(arena_p1n, arena_p2n);
            dist_sect = dist_sect + dist_sect_par; %distance traveled in sector
            time_par = time(i) - time(i-1);
            time_sect = time_sect + time_par; %time spent in sector
        end
    
    in_sect_prev = 1;
                  
    %out of sector
    elseif in == 0 & in_sect_prev == 1
            ent_first_ent = 1;
            in_sect_prev = 0;
    end
    
end

end