function create_fig_double_new (file_name, phase, room_x, room_y, arena_x, arena_y, room_ent_all_X, room_ent_all_Y, arena_ent_all_X, arena_ent_all_Y, diamant_ent_room_x, diamant_ent_room_y, diamant_ent_arena_x, diamant_ent_arena_y, sector_x_input, sector_y_input, unreal_abund, unreal_mis, view_coord_room, view_coord_arena)

figure('visible','off')
x0=200;
y0=200;
width=600;
height=250;
set(gcf,'units','points','position',[x0,y0,width,height]);

%==========================ROOM FRAME=============================
subplot(1,2,1);
plot(room_x(:), room_y(:),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(room_x)
    plot([view_coord_room(i,1) room_x(i)], [view_coord_room(i,2) room_y(i)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund)
    scatter(room_x(unreal_abund), room_y(unreal_abund), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis)
    scatter(room_x(unreal_mis), room_y(unreal_mis), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(room_ent_all_X(:), room_ent_all_Y(:), 'filled', 'r');

%plot diamond entrances
scatter(diamant_ent_room_x(:), diamant_ent_room_y(:), 15, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(room_x(1), room_y(1), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(room_x(end), room_y(end), 200, 'k', 'linewidth' , 1);

%plot sector
if phase ~= 3
    sector_x = [sector_x_input(1), sector_x_input(2), sector_x_input(1), sector_x_input(4)];
    sector_y = [sector_y_input(1), sector_y_input(2), sector_y_input(1), sector_y_input(4)];
    plot (sector_x, sector_y, 'r', 'linewidth', 0.1);
end

%plot arena boundaries
r = 900;
theta = linspace(0,2*pi);
x = r*cos(theta); 
y = r*sin(theta);
plot(x, y, 'k'); 

%generate figure name
phase_st = num2str(phase);
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase ' phase_st, ' room frame'];
title(fig, 'FontSize', 13)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);
%=====================ARENA FRAME===========================
subplot(1,2,2);
plot(arena_x(:), arena_y(:),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(arena_x)
    plot([view_coord_arena(i,1) arena_x(i)], [view_coord_arena(i,2) arena_y(i)], 'Color', [0.7 0.7 0.7]);
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund)
    scatter(arena_x(unreal_abund), arena_y(unreal_abund), 'y', 'filled');
end

%plot missing entrances from unreal
for i = 1:length(unreal_mis)
    scatter(arena_x(unreal_mis), arena_y(unreal_mis), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot sector entrances
scatter(arena_ent_all_X(:), arena_ent_all_Y(:), 'filled', 'r');

%plot diamond entrances
scatter(diamant_ent_arena_x(:), diamant_ent_arena_y(:), 15, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
scatter(arena_x(1), arena_y(1), 200 ,'r', 'linewidth' , 1);

%plot end of track
scatter(arena_x(end), arena_y(end), 200, 'k', 'linewidth' , 1);

%plot sector
if phase == 3
    sector_x = [sector_x_input(1), sector_x_input(2), sector_x_input(1), sector_x_input(4)];
    sector_y = [sector_y_input(1), sector_y_input(2), sector_y_input(1), sector_y_input(4)];
    plot (sector_x, sector_y, 'r', 'linewidth', 0.1);
end

%plot arena boundaries
r = 900;
theta = linspace(0,2*pi);
x = r*cos(theta); 
y = r*sin(theta);
plot(x, y, 'k'); 

%generate figure name
phase_st = num2str(phase);
file_name_fig = strrep(file_name, '_','\_');
fig = [file_name_fig ': phase ' phase_st, ' arena frame'];
title(fig, 'FontSize', 13)

set(gca,'Yticklabel',[]); 
set(gca,'Xticklabel',[]);

end