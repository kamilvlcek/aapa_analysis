function [distance, entrances, entrances_index, time_sect, dist_sect, ent_first, room_ent_all_X, room_ent_all_Y, arena_ent_all_X, arena_ent_all_Y] = output(time, room, arena, sector_x, sector_y)

ent_first_ent = 0; dist_sect = 0; time_sect = 0; ent_first_sess = 1; entrances = 0;
in_sect_prev = 0; n =1; room_ent = []; distance = 0; k = 1;
for i = 1:length(room)
    
    %distance
    if i>1
        dist_par = dist(arena(i, :), arena(i-1, :));
        distance = distance + dist_par;
    end
    
    %register entrance
    in = inpolygon(room(i,1), room(i,2),sector_x, sector_y);
    if in == 1
        room_ent_all_X(k) = room(i, 1);
        room_ent_all_Y(k) = room(i, 2);
        arena_ent_all_X(k) = arena(i, 1);
        arena_ent_all_Y(k) = arena(i, 2);
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
            dist_sect_par = dist(arena(i, :), arena(i-1, :));
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