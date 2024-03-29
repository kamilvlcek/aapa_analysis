function [data_table, data, ent_to_file, diam_to_file, histogram_room, histogram_arena] = aapa_II_main(folder,closefig, nbins)
% view readme.txt for more info on ouput

% set path to used functions in src folder
currentFolder = pwd;
addpath([currentFolder, '\src\']);

% turn off warning for adding new sheets
warning('off', 'MATLAB:xlswrite:AddSheet');


% define default function values
if ~exist('closefig','var')
    closefig = 1; 
end %defaultne se NEzaviraji obrazky po ulozeni

if ~exist('folder','var') %pokud uz nemam folder - Kamil
% get folder name with input data files
    folder_input = uigetdir;
    folder = strcat(folder_input, '\');
end

if ~exist('nbins','var') %default bins for histogram = 15x15
    nbins = [15, 15];
end


% list _T.log files from input directory
files = dir(fullfile(folder, '*_T.log'));

% create out cell array 1st row
data = cell(1, 44);

% create matrix to store coordinates for histogram
f1_x_room= []; f1_y_room= []; f2_x_room= []; f2_y_room= [];
f3_x_room= []; f3_y_room= []; f4_x_room= []; f4_y_room= [];
f1_x_arena= []; f1_y_arena= []; f2_x_arena= []; f2_y_arena= [];
f3_x_arena= []; f3_y_arena= []; f4_x_arena= []; f4_y_arena= [];

% create empty list to store entrances and diamand data
ent_out = [];
filenames_ent_out = [];
diam_out = [];
filenames_diam_out = [];
batchtimer=tic; %start timer  %kamil 14.7.2021
disp(datetime('now')); %print current time %kamil 14.7.2021
% process data files
for i = 1:length(files)
    cas = toc(batchtimer); %time until now in seconds %kamil 14.7.2021
    odhadcelehocasu = length(files)/i * cas; %estimated total time %kamil 14.7.2021
    fprintf('file %i/%i, %.1f/%.1f min  %s ', i, numel(files), cas/60, odhadcelehocasu/60, files(i).name); %pro vice souboru je trosku videt, v jake fazi zpracovani to je - Kamil
    file_name = strcat(folder, files(i).name);
    [subj, diamTimes, entTimes, entDur, room_x, room_y, arena_x, arena_y, f_len] = analysis_II(file_name,closefig);
    
    %save output to cell array
    subj_name = erase(files(i).name, '_T.log');
    data{i,1} = i; %kamil 14.7.2021
    data{i,2} = ['''' subj_name ];
    data{i,3} = subj.status;
    data{i,4} = subj.error_msg; %kamil 14.7.2021
    props = properties(subj);
    
    l = 5; %cycle trhough properties from prop no3
    for j = 3:length(props)
        thisprop = props{j};
        for k = 1:4
            data{i,l} = subj.(thisprop)(k);
            l = l+1;
        end
    end
    
    % do more things only if data exist
    if ~strcmp(subj.status, 'NOT processed')
        % save room coordinates from each subject into matrix
        f1_x_room = cat(1,room_x(1:f_len(1),1),f1_x_room);
        f1_y_room = cat(1,room_y(1:f_len(1),1),f1_y_room);
        
        f2_x_room = cat(1,room_x(1:f_len(2),2),f2_x_room);
        f2_y_room = cat(1,room_y(1:f_len(2),2),f2_y_room);
        
        f3_x_room = cat(1,room_x(1:f_len(3),3),f3_x_room);
        f3_y_room = cat(1,room_y(1:f_len(3),3),f3_y_room);
        
        f4_x_room = cat(1,room_x(1:f_len(4),4),f4_x_room);
        f4_y_room = cat(1,room_y(1:f_len(4),4),f4_y_room);
        
        % save arena coordinates from each subject into matrix
        f1_x_arena = cat(1,arena_x(1:f_len(1),1),f1_x_arena);
        f1_y_arena = cat(1,arena_y(1:f_len(1),1),f1_y_arena);
        
        f2_x_arena = cat(1,arena_x(1:f_len(2),2),f2_x_arena);
        f2_y_arena = cat(1,arena_y(1:f_len(2),2),f2_y_arena);
        
        f3_x_arena = cat(1,arena_x(1:f_len(3),3),f3_x_arena);
        f3_y_arena = cat(1,arena_y(1:f_len(3),3),f3_y_arena);
        
        f4_x_arena = cat(1,arena_x(1:f_len(4),4),f4_x_arena);
        f4_y_arena = cat(1,arena_y(1:f_len(4),4),f4_y_arena);

        
        % format times of entrances and diamand entrances to save to file
        props = properties(diamTimes);
        
        diam_max = max(subj.diamants);
        diam_disp = zeros(diam_max,4);
        ent_max = max(subj.entrances_unr);  
        ent_disp = zeros(ent_max,4);
        entDur_disp = zeros(ent_max,4);
    
        for k = 1:length(props)
            thisprop = props{k};
            %entrances
            if ~isempty(entTimes.(thisprop))
                for l = 1:length(entTimes.(thisprop))
                    ent_out = [ent_out; k, entTimes.(thisprop)(l), entDur.(thisprop)(l)];
                    filenames_ent_out = [filenames_ent_out; subj_name];
                end
            end
            % diamants
            if ~isempty(diamTimes.(thisprop))
                for l = 1:length(diamTimes.(thisprop))
                    diam_out = [diam_out; k, diamTimes.(thisprop)(l)];
                    filenames_diam_out = [filenames_diam_out; subj_name];
                end
            end
        end    
    end
    
   

end

% create result table and write to file
var_names = {'No','Filename', 'Status','error_msg','DistanceF0','DistanceF1','DistanceF2','DistanceF3', ... 
    'EntrancesF0', 'EntrancesF1', 'EntrancesF2', 'EntrancesF3', ...
    'EntrancesUnrF0', 'EntrancesUnrF1', 'EntrancesUnrF2', 'EntrancesUnrF3', ...
    'EntrancesUnrFileF0', 'EntrancesUnrFileF1', 'EntrancesUnrFileF2','EntrancesUnrFileF3', ...
    'Ent1stF0', 'Ent1stF1', 'Ent1stF2', 'Ent1stF3', ...
    'TimeInSectF0', 'TimeInSectF1', 'TimeInSectF2', 'TimeInSectF3', ...
    'TimeInSectUnrF0', 'TimeInSectUnrF1', 'TimeInSectUnrF2', 'TimeInSectUnrF3', ...
    'DistInSectF0', 'DistInSectF1', 'DistInSectF2', 'DistInSectF3', ...
    'DiamantF0', 'DiamantF1', 'DiamantF2', 'DiamantF3', ...
    'DiamantUnrF0', 'DiamantUnrF1', 'DiamantUnrF2', 'DiamantUnrF3'};


    data_table = cell2table(data, 'VariableNames', var_names);
    filename = sprintf('output_data_%s.xlsx', datestr(now,'mm-dd-yyyy HH-MM'));
    out_data = [folder, filename];
    writetable(data_table, out_data, 'Sheet', 'results');
    disp(['summary results written to ' filename ', sheet results']);      %kamil 14.7.2021

    % create output table for entrances and write to file
    ent_to_file = cell(length(filenames_ent_out), 4);
    for rows = 1: length(filenames_ent_out)
        ent_to_file{rows, 1} = ['''' filenames_ent_out(rows, :)];
        ent_to_file{rows, 2} = ent_out(rows, 1)-1; % number of phases starts from 0
        ent_to_file{rows, 3} = ent_out(rows, 2);
        ent_to_file{rows, 4} = ent_out(rows, 3);
    end
  
    var_names_ent = {'Filename', 'Phase', 'Ent_time', 'Ent_dur'};
    ent_table = cell2table(ent_to_file, 'VariableNames', var_names_ent);
    writetable(ent_table, out_data, 'Sheet', 'entrances');
    disp(['list of entraces to avoidance area written to ' filename ', sheet entrances']);  %kamil 14.7.2021
    
    % create output table for diamants and write to file
    diam_to_file = cell(length(filenames_diam_out), 3);
    for rows = 1: length(filenames_diam_out)
        diam_to_file{rows, 1} = ['''' filenames_diam_out(rows, :)];
        diam_to_file{rows, 2} = diam_out(rows, 1)-1; % number of phases starts from 0
        diam_to_file{rows, 3} = diam_out(rows, 2);
    end

    var_names_diam = {'Filename', 'Phase', 'Diam_time'};
    diam_table = cell2table(diam_to_file, 'VariableNames', var_names_diam);
    writetable(diam_table, out_data, 'Sheet', 'diamants');
    disp(['list of entraces to diamants written to ' filename ', sheet diamants']);  %kamil 14.7.2021

    % create histogram and save data to output and csv
    histogram_room = cell(nbins(1)*4, nbins(2)+1);
    histogram_arena = cell(nbins(1)*4, nbins(2)+1);
    hist_list_room = [];
    hist_list_arena = [];
    if ~isempty(f1_x_room)
        %room
        coord = [f1_x_room, f1_y_room];
        n = create_hist (coord, nbins, 1, folder, closefig, 'room');
        hist_list_room = [hist_list_room; n];
        %arena
        coord = [f1_x_arena, f1_y_arena];
        n = create_hist (coord, nbins, 1, folder, closefig, 'arena');
        hist_list_arena = [hist_list_arena; n];
    end

    if ~isempty(f2_x_room)
        coord = [f2_x_room, f2_y_room];
        n = create_hist (coord, nbins, 2, folder, closefig, 'room');
        hist_list_room = [hist_list_room; n];
        %arena
        coord = [f2_x_arena, f2_y_arena];
        n = create_hist (coord, nbins, 2, folder, closefig, 'arena');
        hist_list_arena = [hist_list_arena; n];
    end

    if ~isempty(f3_x_room)
        coord = [f3_x_room, f3_y_room];
        n = create_hist (coord, nbins, 3, folder, closefig, 'room');
        hist_list_room = [hist_list_room; n];
        %arena
        coord = [f3_x_arena, f3_y_arena];
        n = create_hist (coord, nbins, 3, folder, closefig, 'arena');
        hist_list_arena = [hist_list_arena; n];
    end

    if ~isempty(f4_x_room)
        coord = [f4_x_room, f4_y_room];
        n = create_hist (coord, nbins, 4, folder, closefig, 'room');
        hist_list_room = [hist_list_room; n];
        %arena
        coord = [f4_x_arena, f4_y_arena];
        n = create_hist (coord, nbins, 4, folder, closefig, 'arena');
        hist_list_arena = [hist_list_arena; n];
    end
    
    % create cell array from hist list
    for rows = 1:length(hist_list_room)
            for cols = 1:nbins(2)
                histogram_room{rows, cols+1} = hist_list_room(rows, cols);
                histogram_arena{rows, cols+1} = hist_list_arena(rows, cols);
                % write phase numbers
                if rows == 1
                    histogram_room{rows, 1} = 'Phase 0';
                    histogram_arena{rows, 1} = 'Phase 0';
                 elseif rows == nbins(1) + 1
                    histogram_room{rows, 1} = 'Phase 1';
                    histogram_arena{rows, 1} = 'Phase 1';
                elseif rows == nbins(1)*2 + 1
                    histogram_room{rows, 1} = 'Phase 2';
                    histogram_arena{rows, 1} = 'Phase 2';
                elseif rows == nbins(1)*3 + 1
                    histogram_room{rows, 1} = 'Phase 3';
                    histogram_arena{rows, 1} = 'Phase 3';
                end
            end
    end

    % write room histogram to file
    hist_table = cell2table(histogram_room);
    writetable(hist_table, out_data, 'Sheet', 'hist_room');
    % write arena histogram to file
    hist_table = cell2table(histogram_arena);
    writetable(hist_table, out_data, 'Sheet', 'hist_arena');
    disp(['histogram data written to ' filename ', sheets hist_room and hist_arena']); %kamil 14.7.2021
    
    % delete blank sheets in output.xls file
    % possibly to add in the future


    % display analysis results
    disp ('Status: "File OK" = file processed; "INC, processed" = file incomplete, but processed; "NOT processed" = file too short, not processed');
    disp(datetime('now')); %print current time %kamil 14.7.2021
    disp('Analysis done.');

end