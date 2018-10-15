function analysis(file)


%GET FILE NAME
file_name_full = file;
[filepath, file_name, ext] = fileparts(file_name_full);


%DEFINE FORBIDDEN SECTORS
sector_1_x = [-1, -531, -17, 538];
sector_1_y = [-179, -712, -1221, -721];
sector_2_x = [0, 535, -6, -544];
sector_2_y = [180, 718, 1248, 719];



%GET DATA FROM FILE
data_file = fopen(file_name_full);


%find header end
header_end = 'Position changed: diamant6';
read_line = '';
header_lines = 0;
while contains(read_line,header_end) == 0
    read_line = string(fgetl(data_file));
    header_lines = header_lines  + 1;
end


%save data into variables
read_file = 1; count_diamant = 0; unreal_entrance = 0;
i = 1; j = 1; k = 1; i_diam = 1; i_unreal = 1; j_diam = 1; j_unreal = 1; 
k_diam = 1; k_unreal = 1;
diam_ent_f1 = 0; diam_ent_f2 = 0; diam_ent_f3 = 0;
view_len = 80;

while read_file == 1
    line = fgetl(data_file);
    line_str = strsplit(line);
    
    %sort data and text lines
    number_line = string(line_str(1));
    
    %data line
    if number_line == ''
        time_num = str2double(line_str(2));
        
        %phase 1
        if time_num < 180
            time_f1(i) = time_num;
            frame_f1(i) = str2double(line_str(3));
            room_f1(i,1) = str2double(line_str(4));
            room_f1(i,2) = str2double(line_str(5));  
            angle_f1(i) = str2double(line_str(6));
            view_f1(i) = str2double(line_str(9));
            
            [arena_f1(i,1), arena_f1(i,2)] = rotate(room_f1(i,1), room_f1(i,2), (angle_f1(i)*-1));
            
            %view points for graph
            view_int_f1(i) = mod(view_f1(i), 360); %angle to 0-360                        
            [view_room_f1(i,1), view_room_f1(i,2)]  = angle2point(room_f1(i,1),...
                room_f1(i,2), view_len, view_int_f1(i)); 
            [view_arena_f1(i,1), view_arena_f1(i,2)]  = angle2point(arena_f1(i,1),...
                arena_f1(i,2), view_len, view_int_f1(i));
           
            %diamant data
            if count_diamant == 1 
                diam_time_f1(i_diam) = time_f1(i-1);
                diam_room_f1(i_diam,1) = room_f1(i-1,1);
                diam_room_f1(i_diam,2) = room_f1(i-1,2);
                diam_arena_f1(i_diam,1) = arena_f1(i-1,1);
                diam_arena_f1(i_diam,2) = arena_f1(i-1,2);
                diam_ent_f1 = diam_ent_f1 + 1;
                i_diam = i_diam + 1;
                count_diamant = 0;
            end
            
            %unreal data
            if unreal_entrance == 1
                unreal_frame_f1(i_unreal) = frame_f1(i);
                unreal_room_f1(i_unreal,1) = room_f1(i,1);
                unreal_room_f1(i_unreal,2) = room_f1(i,2);
                unreal_arena_f1(i_unreal,1) = arena_f1(i,1);
                unreal_arena_f1(i_unreal,2) = arena_f1(i,2);
                unreal_ind_f1(i_unreal) = i;
                i_unreal = i_unreal + 1;
            end      
            i = i + 1;
        
        %phase2
        elseif time_num >= 180 & time_num < 360
            
            time_f2(j) = time_num;
            frame_f2(j) = str2double(line_str(3));
            room_f2(j,1) = str2double(line_str(4));
            room_f2(j,2) = str2double(line_str(5));  
            angle_f2(j) = str2double(line_str(6));
            view_f2(j) = str2double(line_str(9));
            
            [arena_f2(j,1), arena_f2(j,2)] = rotate(room_f2(j,1), room_f2(j,2), (angle_f2(j)*-1));
            
            %view points for graph
            view_int_f2(j) = mod(view_f2(j), 360); %angle to 0-360            
            [view_room_f2(j,1), view_room_f2(j,2)]  = angle2point(room_f2(j,1),...
                room_f2(j,2), view_len, view_int_f2(j)); 
            [view_arena_f2(j,1), view_arena_f2(j,2)]  = angle2point(arena_f2(j,1),...
                arena_f2(j,2), view_len, view_int_f2(j));
           
            %diamant data
            if count_diamant == 1
                diam_time_f2(j_diam) = time_f2(j-1);
                diam_room_f2(j_diam,1) = room_f2(j-1,1);
                diam_room_f2(j_diam,2) = room_f2(j-1,2);
                diam_arena_f2(j_diam,1) = arena_f2(j-1,1);
                diam_arena_f2(j_diam,2) = arena_f2(j-1,2);
                diam_ent_f2 = diam_ent_f2 + 1;
                j_diam = j_diam + 1;
                count_diamant = 0;
            end
            
            %unreal data
            if unreal_entrance == 1
                unreal_frame_f2(j_unreal) = frame_f2(j);
                unreal_room_f2(j_unreal,1) = room_f2(j,1);
                unreal_room_f2(j_unreal,2) = room_f2(j,2);
                unreal_arena_f2(j_unreal,1) = arena_f2(j,1);
                unreal_arena_f2(j_unreal,2) = arena_f2(j,2);
                unreal_ind_f2(j_unreal) = j;
                j_unreal = j_unreal + 1;
            end      
            j = j + 1;
        
        %phase 3
        elseif time_num >= 360
            time_f3(k) = time_num;
            frame_f3(k) = str2double(line_str(3));
            room_f3(k,1) = str2double(line_str(4));
            room_f3(k,2) = str2double(line_str(5));  
            angle_f3(k) = str2double(line_str(6));
            view_f3(k) = str2double(line_str(9));
            
            [arena_f3(k,1), arena_f3(k,2)] = rotate(room_f3(k,1), room_f3(k,2), (angle_f3(k)*-1));
            
            %view points for graph
            view_int_f3(k) = mod(view_f3(k), 360); %angle to 0-360            
            [view_room_f3(k,1), view_room_f3(k,2)]  = angle2point(room_f3(k,1),...
                room_f3(k,2), view_len, view_int_f3(k)); 
            [view_arena_f3(k,1), view_arena_f3(k,2)]  = angle2point(arena_f3(k,1),...
                arena_f3(k,2), view_len, view_int_f3(k));
                  
            %compute forbidden sector coordinates
            angle_rot = (angle_f3(k) - angle_f3(1)) * -1;
            [sector_3_x(k, 1), sector_3_y(k, 1)] = rotate(sector_2_x(1), sector_2_y(1), angle_rot);
            [sector_3_x(k, 2), sector_3_y(k, 2)] = rotate(sector_2_x(2), sector_2_y(2), angle_rot);
            [sector_3_x(k, 3), sector_3_y(k, 3)] = rotate(sector_2_x(3), sector_2_y(3), angle_rot);
            [sector_3_x(k, 4), sector_3_y(k, 4)] = rotate(sector_2_x(4), sector_2_y(4), angle_rot);
  
            %diamant data
            if count_diamant == 1 
                diam_time_f3(k_diam) = time_f3(k-1);
                diam_room_f3(k_diam,1) = room_f3(k-1,1);
                diam_room_f3(k_diam,2) = room_f3(k-1,2);
                diam_arena_f3(k_diam,1) = arena_f3(k-1,1);
                diam_arena_f3(k_diam,2) = arena_f3(k-1,2);
                diam_ent_f3 = diam_ent_f3 + 1;
                k_diam = k_diam + 1;
                count_diamant = 0;
            end
            
            %unreal data
            if unreal_entrance == 1
                unreal_frame_f3(k_unreal) = frame_f3(k);
                unreal_room_f3(k_unreal,1) = room_f3(k,1);
                unreal_room_f3(k_unreal,2) = room_f3(k,2);
                unreal_arena_f3(k_unreal,1) = arena_f3(k,1);
                unreal_arena_f3(k_unreal,2) = arena_f3(k,2);
                unreal_ind_f3(k_unreal) = k;
                k_unreal = k_unreal + 1;
            end      
            k = k + 1;
            
        end
        
    
    %entrance to sector     
    elseif contains(number_line,'vstup')
        unreal_entrance = 1;
        
    
    %exit out of sector    
    elseif contains(number_line, 'vystup')
        unreal_entrance = 0;
    
    
    %diamant entrance
    else
        count_diamant = 1;
    
    end
    
    
    %search for end of file
    if feof(data_file) == 1
        read_file = 0;
    end
   
end

fclose('all');



%GENERATE OUTPUT DATA

%phase1
[distance_f1, entrances_f1, entrances_index_f1 time_sect_f1, dist_sect_f1,...
    ent_first_f1, room_ent_all_x_f1, room_ent_all_y_f1, arena_ent_all_x_f1,...
    arena_ent_all_y_f1] = output(time_f1, room_f1, arena_f1, sector_1_x, sector_1_y);

%phase2
[distance_f2, entrances_f2, entrances_index_f2, time_sect_f2, dist_sect_f2,...
    ent_first_f2, room_ent_all_x_f2, room_ent_all_y_f2, arena_ent_all_x_f2,...
    arena_ent_all_Y_f2] = output(time_f2, room_f2, arena_f2, sector_2_x, sector_2_y);

%phase3
[distance_f3, entrances_f3, entrances_index_f3, time_sect_f3, dist_sect_f3,...
    ent_first_f3, room_ent_all_x_f3, room_ent_all_y_f3, arena_ent_all_x_f3,...
    arena_ent_all_y_f3] = output_f3(time_f3, room_f3(:,1), room_f3(:,2),...
    arena_f3(:,1), arena_f3(:,2), sector_3_x, sector_3_y);



%COMPARE ENTRANCES FROM UNREAL

%entrances from unreal missing here(index)
unreal_abund_f1 = setdiff(unreal_ind_f1, entrances_index_f1);
unreal_abund_f2 = setdiff(unreal_ind_f2, entrances_index_f2);
unreal_abund_f3 = setdiff(unreal_ind_f3, entrances_index_f3);

%entrances missing in unreal
unreal_mis_f1 = setdiff(entrances_index_f1, unreal_ind_f1);
unreal_mis_f2 = setdiff(entrances_index_f2, unreal_ind_f2);
unreal_mis_f3 = setdiff(entrances_index_f3, unreal_ind_f3);



%CREATE FIGURES
fig_room = 1; fig_arena = 0;

%phase1
phase = 1;
create_fig(fig_room, file_name, phase, room_f1(:, 1), room_f1(:,2),...
    room_ent_all_x_f1, room_ent_all_y_f1, diam_room_f1(:,1), diam_room_f1(:,2),...
    sector_1_x, sector_1_y, unreal_abund_f1, unreal_mis_f1, view_room_f1);

%save fig
file_name_fig = strcat(file_name,'_room_f1.jpg');
saveas(gcf, file_name_fig);

create_fig(fig_arena, file_name, phase, arena_f1(:, 1), arena_f1(:,2),...
    arena_ent_all_x_f1, arena_ent_all_y_f1, diam_arena_f1(:,1), diam_arena_f1(:,2),...
    sector_1_x, sector_1_y, unreal_abund_f1, unreal_mis_f1, view_arena_f1);

%save fig
file_name_fig = strcat(file_name,'_arena_f1.jpg');
saveas(gcf, file_name_fig); 

%phase2
phase = 2;
create_fig(fig_room, file_name, phase, room_f2(:, 1), room_f2(:,2),...
    room_ent_all_x_f2, room_ent_all_y_f2, diam_room_f2(:,1), diam_room_f2(:,2),...
    sector_2_x, sector_2_y, unreal_abund_f2, unreal_mis_f2, view_room_f2);

%save fig
file_name_fig = strcat(file_name,'_room_f2.jpg');
saveas(gcf, file_name_fig);

create_fig(fig_arena, file_name, phase, arena_f2(:, 1), arena_f2(:,2),...
    arena_ent_all_x_f2, arena_ent_all_Y_f2, diam_arena_f2(:,1), diam_arena_f2(:,2),...
    sector_2_x, sector_2_y, unreal_abund_f2, unreal_mis_f2, view_arena_f2);

%save fig
file_name_fig = strcat(file_name,'_arena_f2.jpg');
saveas(gcf, file_name_fig); 

%phase3
phase = 3;
fig_room = 1; fig_arena = 0;
create_fig(fig_room, file_name, phase, room_f3(:, 1), room_f3(:,2),...
    room_ent_all_x_f3, room_ent_all_y_f3, diam_room_f3(:,1), diam_room_f3(:,2),...
    sector_3_x, sector_3_y, unreal_abund_f3, unreal_mis_f3, view_room_f3);

%save fig
file_name_fig = strcat(file_name,'_room_f3.jpg');
saveas(gcf, file_name_fig);

create_fig(fig_arena, file_name, phase, arena_f3(:, 1), arena_f3(:,2),...
    arena_ent_all_x_f3, arena_ent_all_y_f3, diam_arena_f3(:,1), diam_arena_f3(:,2),...
    sector_3_x, sector_3_y, unreal_abund_f3, unreal_mis_f3, view_arena_f3);

%save fig
file_name_fig = strcat(file_name,'_arena_f3.jpg');
saveas(gcf, file_name_fig);



%CREATE AND DISPLAY OUTPUT TABLE
distance = [distance_f1; distance_f2; distance_f3];
entrances = [entrances_f1; entrances_f2; entrances_f3];
first_ent = [ent_first_f1; ent_first_f2; ent_first_f3];
time_sect = [time_sect_f1; time_sect_f2; time_sect_f3];
dist_sect = [dist_sect_f1; dist_sect_f2; dist_sect_f3];
diamant_ent = [diam_ent_f1; diam_ent_f2; diam_ent_f3;];
output_disp = [distance, entrances, first_ent, time_sect, dist_sect, diamant_ent];

disp(file_name);
disp('distance, entrances, 1st entrance, time in sector, distance in sector, diamant');
disp(output_disp);


end