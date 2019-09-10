function [distance, entrances, entrances_index, time_sect, dist_sect, ent_first, room_entX, room_entY, arena_entX, arena_entY] = output(time, data_len, roomX, roomY, arenaX, arenaY, phase)

global sectorX; 
global sectorY;

ent_first_ent = 0; dist_sect = 0; time_sect = 0; ent_first_sess = 1; entrances = 0;
in_sect_prev = 0; n =1; room_ent = [0]; distance = 0; k = 1; ent_first = 0;
room_entX = 0; room_entY = 0; arena_entX = 0; arena_entY = 0;
entrances_index = 0;
for i = 1:data_len
    
    %distance
    if i>1
        arena_dis1 = [arenaX(i), arenaY(i)];
        arena_dis2 = [arenaX(i-1), arenaY(i-1)];
        dist_par = dist(arena_dis1, arena_dis2);
        distance = distance + dist_par;
    end
    
    %register entrance
    if phase == 4
        in = inpolygon(arenaX(i), arenaY(i), sectorX(phase,:), sectorY(phase,:));
    else
        in = inpolygon(roomX(i), roomY(i), sectorX(phase,:), sectorY(phase,:));
    end
    
    if in == 1
        room_entX(k) = roomX(i);
        room_entY(k) = roomY(i);
        arena_entX(k) = arenaX(i);
        arena_entY(k) = arenaY(i);
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
            arena_dis_sect1 = [arenaX(i), arenaY(i)];
            arena_dis_sect2 = [arenaX(i-1), arenaY(i-1)];
            dist_sect_par = dist(arena_dis_sect1, arena_dis_sect2);
            dist_sect = dist_sect + dist_sect_par;
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