function output_data = analysis_II(file_name_full)

% default output data in case of an error
output_data = [-1 -1 -1 -1, -1 -1 -1 -1, -1 -1 -1 -1, -1 -1 -1 -1, -1 -1 -1 -1, -1 -1 -1 -1, -1 -1 -1 -1];

% DEFINE FORBIDDEN SECTORS
global sectorX;
global sectorY;
sectorX = [0, 0, 600, 1039.2; 
            0, -1039.2, -2400, -1039.2;
            0, 1039.2, 1000, 0];
sectorY = [0, -1200, -2080, -600;
            0, 600, 0, -600;
            0, 600, 2001, 1200];

        
% DEFINE PARAMETERS FOR DETECTING TIME CHANGE
frame_rate = 0.1;
max_time_change = 2;        


% CHECK IF EVENTS FILE EXISTS AND CREATE THE NAME FOR IT
file_name_events = erase(file_name_full, '_T');

% create file name for figs and saving
[filepath, file_name,ext] = fileparts(file_name_events);

% check for existence
if ~exist(file_name_events, 'file')
    line = strcat('Missing event file: ', file_name);
    disp(line);
    return
end


%% LOAD DATA 
data_file = fopen(file_name_full);

file_set = 0;
phase = 1; last_phase = 1;
beg_count = 1;
row_pl = 1; row_ps = 1; row_an = 1;
room_x = [0 0 0 0]; room_y = [0 0 0 0];
view = [0 0 0 0];
f_len = [0 0 0 0];
time = [0 0 0 0];
file_rot = 'empty'; file_loc = 'empty';
time_temp = 0; time_temp_l = 0;
time_change = 0;
time_of_change = -1;

% LOAD XY ROOM COORDINATES AND ARENA ANGLE
while 1
  
    if feof(data_file)
        % throw message if file not complete
        if time_now < 598
            time_num_str = string(time_now);
            if time_now < 180
                error_msg = strcat(file_name, ' incomplete, time: ', time_num_str, ' file not proccesed');
                return
            else
                error_msg = strcat(file_name, ' incomplete, time: ', time_num_str);
            end
            disp(error_msg);
        end
        break;
    end
    
    line = fgetl(data_file); % get line
    
    % file with platform rotation
    if (contains (line, 'Player') || contains (line, 'Platform')) && file_set == 0
        file_loc = 'Player Location';
        file_rot = 'Player Rotation';
        angle = [0 0 0 0];
        file_set = 1;
        
    % file without platform rotation
    elseif (contains (line, ']Location') || contains (line, ']Rotation')) && file_set == 0
        file_loc = 'Location';
        file_rot = 'Rotation';
        angle = -1;
        file_set = 1;
    end
    
    % split lines for time and position/rotation loading
    data_time = strsplit(line, {']', '-', ':', '.', ''},'CollapseDelimiters',true);
    min = str2double(data_time(5));
    s = str2double(data_time(6));
    ms = str2double(data_time(7));
    
    % get begining time
    if (beg_count == 1) 
        time_beg = (min * 60) + s + (ms/1000);
        beg_count = 0;
    end
    
    % get current time
    time_temp = (min * 60) + s + (ms/1000);
    
    % check for sudden time change
    if time_temp_l ~= 0
        if time_temp < time_temp_l
            line = strcat('Error procesing, time change: ', file_name);
            disp(line);
            return % exit function if time went back
        elseif time_temp - time_temp_l > max_time_change
            if ~contains(line,'Closing log File')
                line = strcat('Time change, file being processed: ', file_name);
                disp(line);
                % save time change
                time_change = time_temp - time_temp_l + frame_rate;
                time_of_change = time_temp;
            end
        end
    end
    
    
    % get current experiment time and correct time inaccuracy
    time_temp_l = time_temp;
    
    time_corrected = time_temp - time_change; 
    
    if (time_corrected - time_beg < 0)
        time_now = (time_corrected - time_beg) + 3600;
    else
        time_now = time_corrected - time_beg;
    end
    
    
    % set phase
    phase = set_phase(time_now);
            
    % save data about previous phase
    if last_phase ~= phase
    f_len(last_phase) = row_ps - 1;
        row_ps = 1;
        row_pl = 1;
        row_an = 1;
        last_phase = phase;
    end
    
    % load player rotation (view)
    if contains (line, file_rot)
        data_pos = strsplit(line, {';', '['}, 'CollapseDelimiters', true);
        view(row_pl, phase) = str2double(data_pos(4));        
   
        % log time
        time(row_pl, phase) = time_now;       
        row_pl = row_pl + 1;
    end
            
    
    % load player position
    if contains(line, file_loc)
        data_pos = strsplit(line, {';', '['}, 'CollapseDelimiters', true);
        room_x(row_ps,phase) = str2double(data_pos(4))*-1;
        room_y(row_ps,phase) = str2double(data_pos(5));
        f_len(last_phase) = row_ps;
        row_ps = row_ps +1;
    end
    
    
    % load platform rotation if file has it
    if contains(line,'Platform Rotation')
        data_pos = strsplit(line, {';', '['}, 'CollapseDelimiters', true);
        angle(row_an, phase) = str2double(data_pos(4));
        row_an = row_an + 1;
    end
    
end



% generate arena frame coordinates and viewing point for figures

view_len = 65;
view_room_x = [0 0 0 0]; view_room_y = [0 0 0 0];
view_arena_x = [0 0 0 0]; view_arena_y = [0 0 0 0];
arena_x = [0 0 0 0]; arena_y = [0 0 0 0];
rot_speed = 15; % 15 stupnov/s
gen_sect = 1;
ang = 151.3972930908203;

for phase = 1:4
    
    if f_len(phase) > 0
        
        for i=1:f_len(phase)
            % if file doesn't have angle info
            if angle == -1
                ang = ang + 15;
                if ang > 359.9
                    ang = mod(ang,360);
                end
                
            % angle to 0-360    
            else
                if angle(i,phase) < 0
                    ang = angle(i,phase)+ 360;
                else
                    ang = angle(i,phase);
                end
            end
            
            
            % create arena coordinated by rotating room
            [arena_x(i,phase), arena_y(i,phase)] = rotate(room_x(i,phase), room_y(i,phase), ang*-1);
        
            % compute viewing angle and line for graph
            if view(i,phase) < 0
                    view_ang = view(i,phase)+ 360;
            else
                    view_ang = view(i,phase);
            end
            
            [view_room_x(i,phase), view_room_y(i,phase)] = angle2point(room_x(i,phase),room_y(i,phase), view_len, view_ang);
            [view_arena_x(i,phase), view_arena_y(i,phase)] = angle2point(arena_x(i,phase),arena_y(i,phase), view_len, view_ang);
        
        
            %create phase 4 sector
            if phase == 4 && gen_sect == 1
                [sectorX(4,1), sectorY(4,1)] = rotate(sectorX(3,1), sectorY(3,1), ang*-1);
                [sectorX(4,2), sectorY(4,2)] = rotate(sectorX(3,2), sectorY(3,2), ang*-1);
                [sectorX(4,3), sectorY(4,3)] = rotate(sectorX(3,3), sectorY(3,3), ang*-1);
                [sectorX(4,4), sectorY(4,4)] = rotate(sectorX(3,4), sectorY(3,4), ang*-1);
                gen_sect = 0;
            end
           
            
        end
    end
end


% LOAD EVENTS (ENTRANCES & DIAMONDS)

% open file
data_file_events = fopen(file_name_events);

beg_count = 1;
diam_count = 1;
phase = 1;
row_sect = 1;
sect_ent = [0 0 0 0]; sect_exit = [0 0 0 0]; diam = [0 0 0 0];
results = [0 0 0];
ent_low = [0 0 0 0]; diam_low = [0 0 0 0]; ent_high = [0 0 0 0]; diam_high = [0 0 0 0];
ent_pol_x = [0 0 0 0];
ent_pol_y = [0 0 0 0];
exit_pol_x = [0 0 0 0];
exit_pol_y = [0 0 0 0];
exit_low = [0 0 0 0]; exit_high = [0 0 0 0];
entranrances_unr = [0];
diam_pol_x = [0 0 0 0];
diam_pol_y = [0 0 0 0];
diam_pol_x_arena = [0 0 0 0];
diam_pol_y_arena = [0 0 0 0];
ent_pol_x_arena = [0 0 0 0]; ent_pol_y_arena = [0 0 0 0];
exit_pol_x_arena = [0 0 0 0]; exit_pol_y_arena = [0 0 0 0];

diamants = [-1 -1 -1 -1];
entrances_unr = [-1 -1 -1 -1];

while 1
    
    line = fgetl(data_file_events); % get line
    
    % stop reading at the end of data log
    if feof(data_file_events)
        break;
    end
    
    % get clock time
    data_time = strsplit(line, {']', '-', ':', '.', ''},'CollapseDelimiters',true);
    min = str2double(data_time(5));
    s = str2double(data_time(6));
    ms = str2double(data_time(7));
    
    %set begining time
    if (beg_count == 1) 
        time_beg = (min * 60) + s + (ms/1000);
        beg_count = 0;
    end
    
    %load experiment time
        time_t = (min * 60) + s + (ms/1000);
        
        if time_t >= time_of_change
            time_temp = time_t - time_change;
        end
        
        if (time_temp - time_beg < 0)
            time_now = (time_temp - time_beg) + 3600;
        else
            time_now = time_temp - time_beg;
        end

    % get times of diamant entrances
    if contains (line, 'Diamant entered')
        diam(diam_count,phase) = time_now;
        %get clloset high and low xy coordinated for each entrances
        [diam_low(diam_count, phase), diam_high(diam_count, phase)] = get_closest(time(1:f_len(phase),phase), time_now);
        diam_pol_x(diam_count, phase) = interpolate(time(diam_low(diam_count, phase),phase), time(diam_high(diam_count, phase),phase), time_now, room_x(diam_low(diam_count, phase),phase), room_x(diam_high(diam_count, phase),phase));
        diam_pol_y(diam_count, phase) = interpolate(time(diam_low(diam_count, phase),phase), time(diam_high(diam_count, phase),phase), time_now, room_y(diam_low(diam_count, phase),phase), room_y(diam_high(diam_count, phase),phase));
        
        % interpolate points for entrances based on time of entrance
        diam_pol_x_arena(diam_count, phase) = interpolate(time(diam_low(diam_count, phase),phase), time(diam_high(diam_count, phase),phase), time_now, arena_x(diam_low(diam_count, phase),phase), arena_x(diam_high(diam_count, phase),phase));
        diam_pol_y_arena(diam_count, phase) = interpolate(time(diam_low(diam_count, phase),phase), time(diam_high(diam_count, phase),phase), time_now, arena_y(diam_low(diam_count, phase),phase), arena_y(diam_high(diam_count, phase),phase));
        
        diamants(phase) = diam_count;
        diam_count = diam_count + 1; 
        
        
    % get times of sector entrance
    elseif contains (line, 'Avoidance entered')
        ent = time_now;
        entrances_unr(phase) = row_sect;
    
    % get times of sector exit
    elseif contains (line, 'Avoidance left')
        exit = time_now;
        if exit - ent >= 0.001
            
            %get clloset high and low xy coordinated for each entrances and
            %interpolate ot get accurate position - for entrances
            sector_ent(row_sect, phase) = ent;
            [ent_low(row_sect, phase), ent_high(row_sect, phase)] = get_closest(time(1:f_len(phase),phase), ent);
            
            ent_pol_x(row_sect, phase) = interpolate(time(ent_low(row_sect, phase),phase), time(ent_high(row_sect, phase),phase), ent, room_x(ent_low(row_sect, phase),phase), room_x(ent_high(row_sect, phase),phase));
            ent_pol_y(row_sect, phase) = interpolate(time(ent_low(row_sect, phase),phase), time(ent_high(row_sect, phase),phase), ent, room_y(ent_low(row_sect, phase),phase), room_y(ent_high(row_sect, phase),phase));
            
            ent_pol_x_arena(row_sect, phase) = interpolate(time(ent_low(row_sect, phase),phase), time(ent_high(row_sect, phase),phase), ent, arena_x(ent_low(row_sect, phase),phase), arena_x(ent_high(row_sect, phase),phase));
            ent_pol_y_arena(row_sect, phase) = interpolate(time(ent_low(row_sect, phase),phase), time(ent_high(row_sect, phase),phase), ent, arena_y(ent_low(row_sect, phase),phase), arena_y(ent_high(row_sect, phase),phase));
            
            % for exits
            sector_exit(row_sect, phase) = exit;
            [exit_low(row_sect, phase), exit_high(row_sect, phase)] = get_closest(time(1:f_len(phase),phase), exit);
            
            exit_pol_x(row_sect, phase) = interpolate(time(exit_low(row_sect, phase),phase), time(exit_high(row_sect, phase),phase), exit, room_x(exit_low(row_sect, phase),phase), room_x(exit_high(row_sect, phase),phase));
            exit_pol_y(row_sect, phase) = interpolate(time(exit_low(row_sect, phase),phase), time(exit_high(row_sect, phase),phase), exit, room_y(exit_low(row_sect, phase),phase), room_y(exit_high(row_sect, phase),phase));
            
            exit_pol_x_arena(row_sect, phase) = interpolate(time(exit_low(row_sect, phase),phase), time(exit_high(row_sect, phase),phase), exit, arena_x(exit_low(row_sect, phase),phase), arena_x(exit_high(row_sect, phase),phase));
            exit_pol_y_arena(row_sect, phase) = interpolate(time(exit_low(row_sect, phase),phase), time(exit_high(row_sect, phase),phase), exit, arena_y(exit_low(row_sect, phase),phase), arena_y(exit_high(row_sect, phase),phase));
            
            
            row_sect = row_sect + 1;  
        end
        
    % get end of phase data
    elseif contains(line, 'Phase finished:')
        line_spl = strsplit(line, {' ', ','},'CollapseDelimiters',true);
        
        %diamant count, sector time, entrances
        entrances_unr(phase) = row_sect - 1;
        row_sect = 1;
        diamants(phase) = diam_count - 1;
        diam_count = 1;
        
        row = str2double(line_spl(3))+1; %nebrat vstupy vo vysledku z tohto, v logu nie su pocitane ent (chyba)
        results(row, 1) = str2double(line_spl(5));
        results(row, 2) = str2double(line_spl(9)); 
        results(row, 3) = str2double(line_spl(13));
        phase = phase + 1;
    end
end


%% GENERATE FORBIDDEN SECTOR DATA
room_ent_x = [0 0 0 0]; room_ent_y = [0 0 0 0]; arena_ent_x = [0 0 0 0]; arena_ent_y = [0 0 0 0];
distance = [-1 -1 -1 -1];
entrances = [-1 -1 -1 -1];
ent_first = [-1 -1 -1 -1];
time_sect = [-1 -1 -1 -1];
dist_sect = [-1 -1 -1 -1];
for phase = 1:4
    if f_len(phase) > 0
    
    [distance(phase), entrances(phase), entrances_index, time_sect(phase), dist_sect(phase),...
            ent_first(phase), room_entX, room_entY, arena_entX,...
            arena_entY] = output(time(:,phase), f_len(phase), room_x(:,phase), room_y(:,phase), arena_x(:,phase), arena_y(:,phase), phase);
        ent_len(phase) = length(room_entX);

        for j = 1:length(room_entX)
            room_ent_x(j,phase) = room_entX(j);
            room_ent_y(j,phase) = room_entY(j);
            arena_ent_x(j,phase) = arena_entX(j);
            arena_ent_y(j,phase) = arena_entY(j);
        end
    end    
end

%% CREATE FIGURES

set(0,'DefaultLineMarkerSize',3);%ma byt 3

% CREATE DOUBLE FIGURES

for phase = 1:4
    if f_len(phase) > 0
        
    create_fig_double (file_name, phase, room_x(1:f_len(phase),phase), room_y(1:f_len(phase),phase),...
        arena_x(1:f_len(phase),phase), arena_y(1:f_len(phase),phase), room_ent_x(1:ent_len(phase),phase), room_ent_y(1:ent_len(phase),phase),...
        arena_ent_x(1:ent_len(phase),phase), arena_ent_y(1:ent_len(phase),phase), diam_pol_x(1:diamants(phase),phase),...
        diam_pol_y(1:diamants(phase),phase), diam_pol_x_arena(1:diamants(phase),phase), diam_pol_y_arena(1:diamants(phase),phase),...
        view_room_x(1:f_len(phase),phase), view_room_y(1:f_len(phase),phase), view_arena_x(1:f_len(phase),phase),...
        view_arena_y(1:f_len(phase),phase), ent_pol_x(1:entrances_unr(phase),phase), ent_pol_y(1:entrances_unr(phase),phase),...
        exit_pol_x(1:entrances_unr(phase),phase), exit_pol_y(1:entrances_unr(phase),phase), ent_pol_x_arena(1:entrances_unr(phase),phase),...
        ent_pol_y_arena(1:entrances_unr(phase),phase), exit_pol_x_arena(1:entrances_unr(phase),phase), exit_pol_y_arena(1:entrances_unr(phase),phase))
        
    % save figures 
    plot_fname = erase(file_name, '.log');
    file_name_fig = strcat(plot_fname,'_f', num2str(phase-1),'.jpg');
        
    saveas(gcf, file_name_fig);
        
    end
end


% CREATE ALL FIG

%figure('visible','on')
figure
x0=100;
y0=50;
width=550;
height=450;
%set(gcf,'units','points','position',[x0,y0,width,height]);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
subp_top = 0;
subp_bot = 4;

for phase = 1:4
    if f_len(phase) > 0
        
        % ROOM FRAME FIGURE====================================================
        subp_top = subp_top + 1;
        subplot(2,4,subp_top);
    
        % plot track
        plot(room_x(1:f_len(phase),phase), room_y(1:f_len(phase),phase),'-o','MarkerIndices',1:4:f_len(phase), 'linewidth', 0.5);
        hold on;
    
        % plot view points
        for i = 1:f_len(phase)
            if mod(i-1,4) == 0
                plot([view_room_x(i,phase) room_x(i,phase)], [view_room_y(i,phase) room_y(i,phase)], 'Color', [0.7 0.7 0.7]);
            end
        end
    
        % plot entrances from unreal
        if length(ent_pol_x) > 0
            scatter(ent_pol_x(1:entrances_unr(phase),phase), ent_pol_y(1:entrances_unr(phase),phase), 20, 'y', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
        end
    
        % plot sector exit from unreal
        if length(exit_pol_x) > 0
            scatter(exit_pol_x(1:entrances_unr(phase),phase), exit_pol_y(1:entrances_unr(phase),phase), 15, 'g', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
        end

        % plot entrances
         if length(room_ent_x) > 0
            if ((room_ent_x(1)) ~= 0) && (length(room_ent_x) ~= 1)
                scatter(room_ent_x(1:ent_len(phase),phase), room_ent_y(1:ent_len(phase),phase), 'r', 'linewidth' , 0.8);
            end
         end
    
        % plot diamant entrances
        if length(diam_pol_x) > 0
            scatter(diam_pol_x(1:diamants(phase),phase), diam_pol_y(1:diamants(phase),phase), 15, 'd', 'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);
        end
    
        % plot begging of track
        scatter(room_x(1,phase), room_y(1,phase), 200 ,'r', 'linewidth' , 0.8);
    
        % plot end of track
        scatter(room_x(f_len(phase),phase), room_y(f_len(phase),phase), 200 ,'k', 'linewidth' , 0.8);
    
        % plot sector
        if phase ~= 4
            sector_x = [sectorX(phase,1), sectorX(phase,2), sectorX(phase,1), sectorX(phase,4)];
            sector_y = [sectorY(phase,1), sectorY(phase,2), sectorY(phase,1), sectorY(phase,4)];
            plot (sector_x, sector_y, 'r', 'linewidth', 1);
        end
    

        % plot arena boundaries
        r = 1200;
        theta = linspace(0,2*pi);
        x = r*cos(theta); 
        y = r*sin(theta);
        plot(x, y, 'k'); 

        %generate figure name
        phase_st = num2str(phase-1);
        file_name_fig = strrep(file_name, '_','\_');
        fig = [file_name_fig ': phase ' phase_st ' RF'];
        title(fig, 'FontSize', 13)

        % set figure properties
        set(gca,'Yticklabel',[]); 
        set(gca,'Xticklabel',[]);
    
        axis equal;
        pbaspect([4 4.5 1])

    
        % ARENA FRAME =========================================================
        subp_bot = subp_bot + 1;
        subplot(2,4,subp_bot);
    
        % plot track
        plot(arena_x(1:f_len(phase),phase), arena_y(1:f_len(phase),phase),'-o','MarkerIndices',1:4:f_len(phase), 'linewidth', 0.5);
        hold on;
    
        % plot view points
        for i = 1:f_len(phase)
            if mod(i-1,4) == 0
                plot([view_arena_x(i,phase) arena_x(i,phase)], [view_arena_y(i,phase) arena_y(i,phase)], 'Color', [0.7 0.7 0.7]);
            end
        end
    
        % plot entrances from unreal
        if length(ent_pol_x_arena) > 0
            scatter(ent_pol_x_arena(1:entrances_unr(phase),phase), ent_pol_y_arena(1:entrances_unr(phase),phase), 20, 'y', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
        end
    
        % plot sector exit from unreal
        if length(exit_pol_x_arena) > 0
            scatter(exit_pol_x_arena(1:entrances_unr(phase),phase), exit_pol_y_arena(1:entrances_unr(phase),phase), 15, 'g', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
        end

        % plot entrances
        if length(arena_ent_x) > 0
            if ((arena_ent_x(1)) ~= 0) && (length(arena_ent_x) ~= 1)
                scatter(arena_ent_x(1:ent_len(phase),phase), arena_ent_y(1:ent_len(phase),phase), 'r', 'linewidth' , 0.8);
            end
        end
    
        % plot diamant entrances
        if length(diam_pol_x_arena) > 0
            scatter(diam_pol_x_arena(1:diamants(phase),phase), diam_pol_y_arena(1:diamants(phase),phase), 15, 'd', 'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);
        end
    
        % plot begging of track
        scatter(arena_x(1,phase), arena_y(1,phase), 200 ,'r', 'linewidth' , 0.8);
    
        % plot end of track
        scatter(arena_x(f_len(phase),phase), arena_y(f_len(phase),phase), 200 ,'k', 'linewidth' , 0.8);
    
        % plot sector
        if phase == 4
            sector_x = [sectorX(phase,1), sectorX(phase,2), sectorX(phase,1), sectorX(phase,4)];
            sector_y = [sectorY(phase,1), sectorY(phase,2), sectorY(phase,1), sectorY(phase,4)];
            plot (sector_x, sector_y, 'r', 'linewidth', 1);
        end
    
  
      % plot arena boundaries
      r = 1200;
      theta = linspace(0,2*pi);
      x = r*cos(theta); 
      y = r*sin(theta);
      plot(x, y, 'k'); 

      %generate figure name
      phase_st = num2str(phase-1);
      file_name_fig = strrep(file_name, '_','\_');
      fig = [file_name_fig ': phase ' phase_st ' AF'];
      title(fig, 'FontSize', 13)

      % set figure properties
      set(gca,'Yticklabel',[]); 
      set(gca,'Xticklabel',[]);
      axis equal;
      pbaspect([4 4.5 1])
    end
end

% save figure
file_name_fig = strcat(file_name,'.jpg');
saveas(gcf, file_name_fig);

%% OUTPUT DATA
output_data = [distance, entrances, entrances_unr, ent_first, time_sect, dist_sect, diamants];