function output_an = analysis(file)

%DEFINE EXP TIMES
f1 = 180; %180
f3 = 360; %360
exp_end = 540; %540

%GET FILE NAME
file_name_full = file;
[filepath, file_name, ext] = fileparts(file_name_full);


%DEFINE FORBIDDEN SECTORS
sector_1_x = [-1, -531, -17, 538];
sector_1_y = [179, 712, 1221, 721];
sector_2_x = [0, 535, -6, -544];
sector_2_y = [-180, -718, -1248, -719];



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
view_len = 65;
frame_f1 = []; frame_f2 = []; frame_f3 = [];
diam_ent_f1 = -1; diam_ent_f2 = -1; diam_ent_f3 = -1;

while read_file == 1
    line = fgetl(data_file);
    line_str = strsplit(line);
    
    %sort data and text lines
    number_line = string(line_str(1));
    
    %data line
    if number_line == ''
        time_num = str2double(line_str(2));
        
        %phase 1
        if time_num < f1
            time_f1(i) = time_num;
            frame_f1(i) = str2double(line_str(3));
            room_f1(i,1) = str2double(line_str(4));
            room_f1_temp = str2double(line_str(5));
            room_f1(i,2) = room_f1_temp*-1;  
            angle_f1(i) = str2double(line_str(6));
            view_f1(i) = str2double(line_str(9));
            
            [arena_f1(i,1), arena_f1(i,2)] = rotate(room_f1(i,1), room_f1(i,2), (angle_f1(i)*-1));
            
            %view points for graph
            view_int_f1(i) = mod(view_f1(i), 360); %angle to 0-360                        
            [view_room_f1(i,1), view_room_f1(i,2)]  = angle2point(room_f1(i,1),...
                room_f1(i,2), view_len, view_int_f1(i)); 
            [view_arena_f1(i,1), view_arena_f1(i,2)]  = angle2point(arena_f1(i,1),...
                arena_f1(i,2), view_len, view_int_f1(i));
           
%             %diamant data
%             if count_diamant == 1 
%                 diam_time_f1(i_diam) = time_f1(i-1);
%                 diam_room_f1(i_diam,1) = room_f1(i-1,1);
%                 diam_room_f1(i_diam,2) = room_f1(i-1,2);
%                 diam_arena_f1(i_diam,1) = arena_f1(i-1,1);
%                 diam_arena_f1(i_diam,2) = arena_f1(i-1,2);
%                 diam_ent_f1 = diam_ent_f1 + 1;
%                 i_diam = i_diam + 1;
%                 count_diamant = 0;
%             end
            
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
        elseif time_num >= f1 & time_num < f3
            
            time_f2(j) = time_num;
            frame_f2(j) = str2double(line_str(3));
            room_f2(j,1) = str2double(line_str(4));
            room_f2_temp = str2double(line_str(5));
            room_f2(j,2) = room_f2_temp*-1;  
            
            angle_f2(j) = str2double(line_str(6));
            view_f2(j) = str2double(line_str(9));
            
            [arena_f2(j,1), arena_f2(j,2)] = rotate(room_f2(j,1), room_f2(j,2), (angle_f2(j)*-1));
            
            %view points for graph
            view_int_f2(j) = mod(view_f2(j), 360); %angle to 0-360            
            [view_room_f2(j,1), view_room_f2(j,2)]  = angle2point(room_f2(j,1),...
                room_f2(j,2), view_len, view_int_f2(j)); 
            [view_arena_f2(j,1), view_arena_f2(j,2)]  = angle2point(arena_f2(j,1),...
                arena_f2(j,2), view_len, view_int_f2(j));
           
%             %diamant data
%             if count_diamant == 1
%                 diam_time_f2(j_diam) = time_f2(j-1);
%                 diam_room_f2(j_diam,1) = room_f2(j-1,1);
%                 diam_room_f2(j_diam,2) = room_f2(j-1,2);
%                 diam_arena_f2(j_diam,1) = arena_f2(j-1,1);
%                 diam_arena_f2(j_diam,2) = arena_f2(j-1,2);
%                 diam_ent_f2 = diam_ent_f2 + 1;
%                 j_diam = j_diam + 1;
%                 count_diamant = 0;
%             end
            
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
        elseif time_num >= f3 & time_num <= exp_end
            time_f3(k) = time_num;
            frame_f3(k) = str2double(line_str(3));
            room_f3(k,1) = str2double(line_str(4));
            room_f3_temp = str2double(line_str(5));
            room_f3(k,2) = room_f3_temp * -1;
            angle_f3(k) = str2double(line_str(6));
            view_f3(k) = str2double(line_str(9));
            
            [arena_f3(k,1), arena_f3(k,2)] = rotate(room_f3(k,1), room_f3(k,2), (angle_f3(k)*-1));
            
            %view points for graph
            view_int_f3(k) = mod(view_f3(k), 360); %angle to 0-360            
            [view_room_f3(k,1), view_room_f3(k,2)]  = angle2point(room_f3(k,1),...
                room_f3(k,2), view_len, view_int_f3(k)); 
            [view_arena_f3(k,1), view_arena_f3(k,2)]  = angle2point(arena_f3(k,1),...
                arena_f3(k,2), view_len, view_int_f3(k));
                  
  
            %diamant data
%             if count_diamant == 1 
%                 diam_time_f3(k_diam) = time_f3(k-1);
%                 diam_room_f3(k_diam,1) = room_f3(k-1,1);
%                 diam_room_f3(k_diam,2) = room_f3(k-1,2);
%                 diam_arena_f3(k_diam,1) = arena_f3(k-1,1);
%                 diam_arena_f3(k_diam,2) = arena_f3(k-1,2);
%                 diam_ent_f3 = diam_ent_f3 + 1;
%                 k_diam = k_diam + 1;
%                 count_diamant = 0;
%             end
            
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
        if time_num < f1
            diam_time_f1(i_diam) = time_f1(i-1);
                diam_room_f1(i_diam,1) = room_f1(i-1,1);
                diam_room_f1(i_diam,2) = room_f1(i-1,2);
                diam_arena_f1(i_diam,1) = arena_f1(i-1,1);
                diam_arena_f1(i_diam,2) = arena_f1(i-1,2);
                diam_ent_f1 = diam_ent_f1 + 1;
                i_diam = i_diam + 1;

        elseif time_num >= f1 & time_num < f3
            diam_time_f2(j_diam) = time_f2(j-1);
                diam_room_f2(j_diam,1) = room_f2(j-1,1);
                diam_room_f2(j_diam,2) = room_f2(j-1,2);
                diam_arena_f2(j_diam,1) = arena_f2(j-1,1);
                diam_arena_f2(j_diam,2) = arena_f2(j-1,2);
                diam_ent_f2 = diam_ent_f2 + 1;
                j_diam = j_diam + 1;

        else
            diam_time_f3(k_diam) = time_f3(k-1);
                diam_room_f3(k_diam,1) = room_f3(k-1,1);
                diam_room_f3(k_diam,2) = room_f3(k-1,2);
                diam_arena_f3(k_diam,1) = arena_f3(k-1,1);
                diam_arena_f3(k_diam,2) = arena_f3(k-1,2);
                diam_ent_f3 = diam_ent_f3 + 1;
                k_diam = k_diam + 1;
        end
    
%         count_diamant = 1;
    
    end
    
    
    %search for end of file
    if feof(data_file) == 1
        read_file = 0;
        if time_num < 535
            time_num_str = string(time_num);
            error_msg = strcat(file_name, ' incomplete, time: ', time_num_str);
            disp(error_msg);
        end
        
    end
   
end

fclose('all');

    

%GENERATE OUTPUT DATA
distance_f1 = -1; distance_f2 = -1; distance_f3 = -1; 
entrances_f1 = -1; entrances_f2 = -1; entrances_f3 = -1;
ent_first_f1 = -1; ent_first_f2 = -1; ent_first_f3 = -1; 
time_sect_f1 = -1; time_sect_f2 = -1; time_sect_f3 = -1; 
dist_sect_f1 = -1; dist_sect_f2 = -1; dist_sect_f3 = -1; 

%phase 1
if ~isempty(frame_f1)
    [distance_f1, entrances_f1, entrances_index_f1 time_sect_f1, dist_sect_f1,...
        ent_first_f1, room_ent_all_x_f1, room_ent_all_y_f1, arena_ent_all_x_f1,...
        arena_ent_all_y_f1] = output(time_f1, room_f1, arena_f1, sector_1_x, sector_1_y);
    %compare entrances from unreal
    unreal_abund_f1 = setdiff(unreal_ind_f1, entrances_index_f1);
    unreal_mis_f1 = setdiff(entrances_index_f1, unreal_ind_f1);
    
    
    %phase2
    if ~isempty(frame_f2)
        [distance_f2, entrances_f2, entrances_index_f2, time_sect_f2, dist_sect_f2,...
            ent_first_f2, room_ent_all_x_f2, room_ent_all_y_f2, arena_ent_all_x_f2,...
            arena_ent_all_y_f2] = output(time_f2, room_f2, arena_f2, sector_2_x, sector_2_y);
        %compare entrances from unreal
        unreal_abund_f2 = setdiff(unreal_ind_f2, entrances_index_f2);
        unreal_mis_f2 = setdiff(entrances_index_f2, unreal_ind_f2);

        
        %phase3
        if ~isempty(frame_f3)
            %create phase 3 sector
            [sector_3_x(1, 1), sector_3_y(1, 1)] = rotate(sector_2_x(1), sector_2_y(1), angle_f3(1)*-1);
            [sector_3_x(1, 2), sector_3_y(1, 2)] = rotate(sector_2_x(2), sector_2_y(2), angle_f3(1)*-1);
            [sector_3_x(1, 3), sector_3_y(1, 3)] = rotate(sector_2_x(3), sector_2_y(3), angle_f3(1)*-1);
            [sector_3_x(1, 4), sector_3_y(1, 4)] = rotate(sector_2_x(4), sector_2_y(4), angle_f3(1)*-1);

            [distance_f3, entrances_f3, entrances_index_f3, time_sect_f3, dist_sect_f3,...
                ent_first_f3, room_ent_all_x_f3, room_ent_all_y_f3, arena_ent_all_x_f3,...
                arena_ent_all_y_f3] = output_f3(time_f3, room_f3(:,1), room_f3(:,2),...
                arena_f3(:,1), arena_f3(:,2), sector_3_x, sector_3_y);
            %compare entrances from unreal
            unreal_abund_f3 = setdiff(unreal_ind_f3, entrances_index_f3);
            unreal_mis_f3 = setdiff(entrances_index_f3, unreal_ind_f3);


        end
    end
end



set(0,'DefaultLineMarkerSize',3);

% CREATE DOUBLE FIGURES
%phase1
if ~isempty(frame_f1)
    phase = 1;
    create_fig_double_new (file_name, phase, room_f1(:,1), room_f1(:,2), arena_f1(:,1), arena_f1(:,2),...
        room_ent_all_x_f1, room_ent_all_y_f1, arena_ent_all_x_f1, arena_ent_all_y_f1,...
        diam_room_f1(:,1), diam_room_f1(:,2), diam_arena_f1(:,1), diam_arena_f1(:,2),...
        sector_1_x, sector_1_y, unreal_abund_f1, unreal_mis_f1, view_room_f1, view_arena_f1)
    %save fig
    file_name_fig = strcat(file_name,'_f1.jpg');
    saveas(gcf, fullfile(filepath, file_name_fig));
    
    %phase2
    if ~isempty(frame_f2)
        phase = 2;
        create_fig_double_new (file_name, phase, room_f2(:,1), room_f2(:,2), arena_f2(:,1), arena_f2(:,2),...
            room_ent_all_x_f2, room_ent_all_y_f2, arena_ent_all_x_f2, arena_ent_all_y_f2,...
            diam_room_f2(:,1), diam_room_f2(:,2), diam_arena_f2(:,1), diam_arena_f2(:,2),...
            sector_2_x, sector_2_y, unreal_abund_f2, unreal_mis_f2, view_room_f2, view_arena_f2)
        %save fig
        file_name_fig = strcat(file_name,'_f2.jpg');
        saveas(gcf, fullfile(filepath, file_name_fig));
        
        %phase3
        if ~isempty(frame_f3)
            phase = 3;
            create_fig_double_new (file_name, phase, room_f3(:,1), room_f3(:,2), arena_f3(:,1), arena_f3(:,2),...
                room_ent_all_x_f3, room_ent_all_y_f3, arena_ent_all_x_f3, arena_ent_all_y_f3,...
                diam_room_f3(:,1), diam_room_f3(:,2), diam_arena_f3(:,1), diam_arena_f3(:,2),...
                sector_3_x, sector_3_y, unreal_abund_f3, unreal_mis_f3, view_room_f3, view_arena_f3)
            %save fig
            file_name_fig = strcat(file_name,'_f3.jpg');
            saveas(gcf, fullfile(filepath, file_name_fig));
   
        end
    end
end




%CREATE ALL FIGURES AS SUBPLOTS
figure
x0=100;
y0=50;
width=750;
height=450;
set(gcf,'units','points','position',[x0,y0,width,height]);
diam_size = 15;
%ROOM FRAME F1=========================================================
if ~isempty(frame_f1)
    
subplot(2,3,1);
plot(room_f1(:,1), room_f1(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(room_f1)
    plot([view_room_f1(i,1) room_f1(i,1)], [view_room_f1(i,2) room_f1(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f1)
    scatter(room_f1(unreal_abund_f1,1), room_f1(unreal_abund_f1,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f1)
    scatter(room_f1(unreal_mis_f1,1), room_f1(unreal_mis_f1,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(room_ent_all_x_f1(:), room_ent_all_y_f1(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_room_f1(:,1), diam_room_f1(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(room_f1(1,1), room_f1(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(room_f1(end,1), room_f1(end,2), 200, 'k', 'linewidth' , 1);

%plot sector
sector_x = [sector_1_x(1), sector_1_x(2), sector_1_x(1), sector_1_x(4)];
sector_y = [sector_1_y(1), sector_1_y(2), sector_1_y(1), sector_1_y(4)];
plot (sector_x, sector_y, 'r', 'linewidth', 0.1);

%plot arena boundaries
r = 900;
theta = linspace(0,2*pi);
x = r*cos(theta); 
y = r*sin(theta);
plot(x, y, 'k'); 

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 1 room frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

%=====================ARENA FRAME F1===========================
subplot(2,3,4);
plot(arena_f1(:,1), arena_f1(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(arena_f1)
    plot([view_arena_f1(i,1) arena_f1(i,1)], [view_arena_f1(i,2) arena_f1(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f1)
    scatter(arena_f1(unreal_abund_f1,1), arena_f1(unreal_abund_f1,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f1)
    scatter(arena_f1(unreal_mis_f1,1), arena_f1(unreal_mis_f1,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(arena_ent_all_x_f1(:), arena_ent_all_y_f1(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_arena_f1(:,1), diam_arena_f1(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(arena_f1(1,1), arena_f1(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(arena_f1(end,1), arena_f1(end,2), 200, 'k', 'linewidth' , 1);

%plot arena boundaries
plot(x, y, 'k'); 

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 1 arena frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

%ROOM FRAME F2===========================================================
if ~isempty(frame_f2)

subplot(2,3,2);
plot(room_f2(:,1), room_f2(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(room_f2)
    plot([view_room_f2(i,1) room_f2(i,1)], [view_room_f2(i,2) room_f2(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f2)
    scatter(room_f2(unreal_abund_f2,1), room_f2(unreal_abund_f2,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f2)
    scatter(room_f2(unreal_mis_f2,1), room_f2(unreal_mis_f2,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(room_ent_all_x_f2(:), room_ent_all_y_f2(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_room_f2(:,1), diam_room_f2(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(room_f2(1,1), room_f2(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(room_f2(end,1), room_f2(end,2), 200, 'k', 'linewidth' , 1);

%plot sector
sector_x = [sector_2_x(1), sector_2_x(2), sector_2_x(1), sector_2_x(4)];
sector_y = [sector_2_y(1), sector_2_y(2), sector_2_y(1), sector_2_y(4)];
plot (sector_x, sector_y, 'r', 'linewidth', 0.1);

%plot arena boundaries
plot(x, y, 'k'); 

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 2 room frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

%=====================ARENA FRAME F2===========================
subplot(2,3,5);
plot(arena_f2(:,1), arena_f2(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(arena_f2)
    plot([view_arena_f2(i,1) arena_f2(i,1)], [view_arena_f2(i,2) arena_f2(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f2)
    scatter(arena_f2(unreal_abund_f2,1), arena_f2(unreal_abund_f2,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f2)
    scatter(arena_f2(unreal_mis_f2,1), arena_f2(unreal_mis_f2,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(arena_ent_all_x_f2(:), arena_ent_all_y_f2(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_arena_f2(:,1), diam_arena_f2(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(arena_f2(1,1), arena_f2(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(arena_f2(end,1), arena_f2(end,2), 200, 'k', 'linewidth' , 1);

%plot arena boundaries
plot(x, y, 'k'); 

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 2 arena frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);


%ROOM FRAME F3=========================================================
if ~isempty(frame_f3)

subplot(2,3,3);
plot(room_f3(:,1), room_f3(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(room_f3)
    plot([view_room_f3(i,1) room_f3(i,1)], [view_room_f3(i,2) room_f3(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f3)
    scatter(room_f3(unreal_abund_f3,1), room_f3(unreal_abund_f3,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f3)
    scatter(room_f3(unreal_mis_f3,1), room_f3(unreal_mis_f3,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(room_ent_all_x_f3(:), room_ent_all_y_f3(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_room_f3(:,1), diam_room_f3(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(room_f3(1,1), room_f3(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(room_f3(end,1), room_f3(end,2), 200, 'k', 'linewidth' , 1);

%plot arena boundaries
plot(x, y, 'k'); 

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 3 room frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

%=====================ARENA FRAME F3===========================
subplot(2,3,6);
plot(arena_f3(:,1), arena_f3(:,2),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(arena_f3)
    plot([view_arena_f3(i,1) arena_f3(i,1)], [view_arena_f3(i,2) arena_f3(i,2)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund_f3)
    scatter(arena_f3(unreal_abund_f3,1), arena_f3(unreal_abund_f3,2), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis_f3)
    scatter(arena_f3(unreal_mis_f3,1), arena_f3(unreal_mis_f3,2), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(arena_ent_all_x_f3(:), arena_ent_all_y_f3(:), 'filled', 'r');

%plot diamond entrances
scatter(diam_arena_f3(:,1), diam_arena_f3(:,2), diam_size, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(arena_f3(1,1), arena_f3(1,2), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(arena_f3(end,1), arena_f3(end,2), 200, 'k', 'linewidth' , 1);

%plot arena boundaries
plot(x, y, 'k'); 

%plot sector
sector_x = [sector_3_x(1), sector_3_x(2), sector_3_x(1), sector_3_x(4)];
sector_y = [sector_3_y(1), sector_3_y(2), sector_3_y(1), sector_3_y(4)];
plot (sector_x, sector_y, 'r', 'linewidth', 0.1);

%generate figure name
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase 3 arena frame'];
title(fig, 'FontSize', 10)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

end
end
end

%save fig
file_name_fig = strcat(file_name,'_all.jpg');
saveas(gcf, fullfile(filepath, file_name_fig));



%CREATE OUTPUT DATA
output_an = [distance_f1, distance_f2, distance_f3, entrances_f1, entrances_f2, entrances_f3,ent_first_f1, ent_first_f2, ent_first_f3, time_sect_f1, time_sect_f2, time_sect_f3, dist_sect_f1, dist_sect_f2, dist_sect_f3, diam_ent_f1, diam_ent_f2, diam_ent_f3];


end