function create_fig_double (file_name_events, phase, room_x, room_y, arena_x, arena_y, room_ent_x, room_ent_y, arena_ent_x, arena_ent_y, diam_pol_x, diam_pol_y, diam_pol_x_arena, diam_pol_y_arena, view_room_x, view_room_y, view_arena_x, view_arena_y, ent_pol_x, ent_pol_y, exit_pol_x, exit_pol_y, ent_pol_x_arena, ent_pol_y_arena, exit_pol_x_arena, exit_pol_y_arena)
global sectorX
global sectorY

figure('visible','off')
x0=200;
y0=200;
width=650;
height=400;
set(gcf,'units','points','position',[x0,y0,width,height]);

    % ROOM FRAME FIGURE====================================================
subplot(1,2,1);
    
    % plot track
    plot(room_x(:), room_y(:),'-o','MarkerIndices',1:4:length(room_x), 'linewidth', 0.5);
    hold on;
    
    % plot view points
    for i = 1:length(room_x)
        if mod(i-1,4) == 0
            plot([view_room_x(i) room_x(i)], [view_room_y(i) room_y(i)], 'Color', [0.7 0.7 0.7]);
        end
    end
    
    % plot entrances from unreal
    if length(ent_pol_x) > 0
    scatter(ent_pol_x(:), ent_pol_y(:), 20, 'y', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
    end
    
    % plot sector exit from unreal
    if length(exit_pol_x) > 0
    scatter(exit_pol_x(:), exit_pol_y(:), 15, 'g', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
    end

    % plot entrances
    if length(room_ent_x) > 0
                if ((room_ent_x(1)) ~= 0) && (length(room_ent_x) ~= 1)
    scatter(room_ent_x(:), room_ent_y(:), 'r', 'linewidth' , 0.8);
        end
    end
    
    % plot diamant entrances
    if length(diam_pol_x) > 0
    scatter(diam_pol_x(:), diam_pol_y(:), 15, 'd', 'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);
    end
    
    % plot begging of track
    scatter(room_x(1), room_y(1), 200 ,'r', 'linewidth' , 0.8);
    
    % plot end of track
    scatter(room_x(end), room_y(end), 200 ,'k', 'linewidth' , 0.8);
    
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
    file_name_fig = strrep(file_name_events, '_','\_');
    fig = [file_name_fig ': phase ' phase_st ' room frame'];
    title(fig, 'FontSize', 13)

    % set figure properties
    set(gca,'Yticklabel',[]); 
    set(gca,'Xticklabel',[]);
    axis equal;
    pbaspect([4 4.5 1])
    
    % ARENA FRAME =========================================================
subplot(1,2,2);
    
    % plot track
    plot(arena_x(:), arena_y(:),'-o','MarkerIndices',1:4:length(arena_x), 'linewidth', 0.5);
    hold on;
    
    % plot view points
    for i = 1:length(arena_x)
        if mod(i-1,4) == 0
            plot([view_arena_x(i) arena_x(i)], [view_arena_y(i) arena_y(i)], 'Color', [0.7 0.7 0.7]);
        end
    end
    
    % plot entrances from unreal
    if length(ent_pol_x_arena) > 0
    scatter(ent_pol_x_arena(:), ent_pol_y_arena(:), 20, 'y', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
    end
    
    % plot sector exit from unreal
    if length(exit_pol_x_arena) > 0
    scatter(exit_pol_x_arena(:), exit_pol_y_arena(:), 15, 'g', 'filled', 'linewidth' , 0.8, 'MarkerEdgeColor',[0 .5 .5]);
    end

    % plot entrances
    if length(arena_ent_x) > 0
    if ((arena_ent_x(1)) ~= 0) && (length(arena_ent_x) ~= 1)
    scatter(arena_ent_x(:), arena_ent_y(:), 'r', 'linewidth' , 0.8);
        end
    end
    
    % plot diamant entrances
    if length(diam_pol_x_arena) > 0
    scatter(diam_pol_x_arena(:), diam_pol_y_arena(:), 15, 'd', 'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);
    end
    
    % plot begging of track
    scatter(arena_x(1), arena_y(1), 200 ,'r', 'linewidth' , 0.8);
    
    % plot end of track
    scatter(arena_x(end), arena_y(end), 200 ,'k', 'linewidth' , 0.8);
    
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
    file_name_fig = strrep(file_name_events, '_','\_');
    fig = [file_name_fig ': phase ' phase_st ' arena frame'];
    title(fig, 'FontSize', 13)

    % set figure properties
    set(gca,'Yticklabel',[]); 
    set(gca,'Xticklabel',[]);
    axis equal;
    pbaspect([4 4.5 1])
    
end