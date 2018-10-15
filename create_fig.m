function create_fig (is_room, file_name, phase, room_x, room_y, room_ent_all_X, room_ent_all_Y, diamant_ent_room_x, diamant_ent_room_y, sector_x_input, sector_y_input, unreal_abund, unreal_mis, view_coord)
%creates figure from input coordinates

figure('Name','Figure','NumberTitle','off');

fig = plot(room_x(:), room_y(:),'-o', 'linewidth', 0.5);
hold on;

%plot view angle line
for i = 1:length(room_x)
    fig = plot([view_coord(i,1) room_x(i)], [view_coord(i,2) room_y(i)], 'Color', [0.7 0.7 0.7]);
end

%plot sector entrances
fig = scatter(room_ent_all_X(:), room_ent_all_Y(:), 'filled', 'r');

%plot diamond entrances
fig = scatter(diamant_ent_room_x(:), diamant_ent_room_y(:), 50, 'd',...
    'filled', 'b', 'MarkerEdgeColor',[0 .5 .5]);

%plot beginning of track
fig = scatter(room_x(1), room_y(1), 200 ,'r', 'linewidth' , 1);

%plot end of track
fig = scatter(room_x(end), room_y(end), 200, 'k', 'linewidth' , 1);

%plot missing entrances from unreal
for i = 1:length(unreal_mis)
    fig = scatter(room_x(unreal_mis), room_y(unreal_mis), 'filled',...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'g');
end

%plot abundant entrances from unreal
for i = 1:length(unreal_abund)
    fig = scatter(room_x(unreal_abund), room_y(unreal_abund), 'y', 'filled');
end

%plot sector
if is_room == 1 & phase ~= 3
    sector_x = [sector_x_input(1), sector_x_input(2), sector_x_input(1), sector_x_input(4)];
    sector_y = [sector_y_input(1), sector_y_input(2), sector_y_input(1), sector_y_input(4)];
    plot (sector_x, sector_y, 'r', 'linewidth', 0.1);
end

%plot arena boundaries
r = 900;
theta = linspace(0,2*pi);
x = r*cos(theta); 
y = r*sin(theta);
fig = plot(x, y, 'k'); 

%generate figure name
phase_st = num2str(phase);
file_name_fig = strrep(file_name, '_','\_');
if is_room == 1
    fig = [file_name_fig ': phase ' phase_st, 'room frame'];
else
    fig = [file_name_fig ': phase ' phase_st, 'arena frame'];
end
title(fig, 'FontSize', 16)


axis ([-1200, 1200, -1000, 1000]);

end