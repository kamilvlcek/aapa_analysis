function mytable = aapa_II_main(folder,closefig, nbins)
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
data = cell(1, 42);

% create matrix to store coordinates for histogram
f1_x= []; f1_y= []; f2_x= []; f2_y= [];
f3_x= []; f3_y= []; f4_x= []; f4_y= [];

% process data files
for i = 1:length(files)
    fprintf('file %i/%i  %s ', i, numel(files), files(i).name); %pro vice souboru je trosku videt, v jake fazi zpracovani to je - Kamil
    file_name = strcat(folder, files(i).name);
    [subj, diamTimes, entTimes, entDur, room_x, room_y, f_len] = analysis_II(file_name,closefig);
    
    %save output to cell array
    subj_name = erase(files(i).name, '_T.log');
    data{i,1} = subj_name;
    data{i,2} = subj.status;
    props = properties(subj);
    
    l = 3; %cycle trhough properties from prop no3
    for j = 2:length(props)
        thisprop = props{j};
        for k = 1:4
            data{i,l} = subj.(thisprop)(k);
            l = l+1;
        end
    end
    
    % do more things only if data exists
    if ~strcmp(subj.status, 'NOT processed')
        % save coordinates from each subjects into 1 matrix
        f1_x = cat(1,room_x(1:f_len(1),1),f1_x);
        f1_y = cat(1,room_y(1:f_len(1),1),f1_y);
        
        f2_x = cat(1,room_x(1:f_len(2),2),f2_x);
        f2_y = cat(1,room_y(1:f_len(2),2),f2_y);
        
        f3_x = cat(1,room_x(1:f_len(3),3),f3_x);
        f3_y = cat(1,room_y(1:f_len(3),3),f3_y);
        
        f4_x = cat(1,room_x(1:f_len(4),4),f4_x);
        f4_y = cat(1,room_y(1:f_len(4),4),f4_y);

        
        % format times of entrances and diamand entrances to display
        props = properties(diamTimes);
        
        diam_max = max(subj.diamants);
        diam_disp = zeros(diam_max,4);
        ent_max = max(subj.entrances_unr);  
        ent_disp = zeros(ent_max,4);
        entDur_disp = zeros(ent_max,4);
    
        % display in 4xN matrix with zeros
        for k = 1:length(props)
            thisprop = props{k};
            diam_disp(1:subj.diamants(k),k) = diamTimes.(thisprop)';
            ent_disp(1:subj.entrances_unr(k),k) = entTimes.(thisprop)';
            entDur_disp(1:subj.entrances_unr(k),k) = entDur.(thisprop)';
        end
    
        % display results
        diam_mes = [subj_name, ' Diamant entrances times: '];
        disp(diam_mes);
        disp(diam_disp);
        
        ent_mes = [subj_name, ' Sector entrances times: '];
        disp(ent_mes);
        disp(ent_disp);
        
        dur_mes = [subj_name, ' Sector entrances duration: '];
        disp(dur_mes);
        disp(entDur_disp);
    end

end

% create result table and write to file
var_names = {'Filename', 'Status','DistanceF0','DistanceF1','DistanceF2','DistanceF3', ... 
    'EntrancesF0', 'EntrancesF1', 'EntrancesF2', 'EntrancesF3', ...
    'EntrancesUnrF0', 'EntrancesUnrF1', 'EntrancesUnrF2', 'EntrancesUnrF3', ...
    'EntrancesUnrFileF0', 'EntrancesUnrFileF1', 'EntrancesUnrFileF2','EntrancesUnrFileF3', ...
    'Ent1stF0', 'Ent1stF1', 'Ent1stF2', 'Ent1stF3', ...
    'TimeInSectF0', 'TimeInSectF1', 'TimeInSectF2', 'TimeInSectF3', ...
    'TimeInSectUnrF0', 'TimeInSectUnrF1', 'TimeInSectUnrF2', 'TimeInSectUnrF3', ...
    'DistInSectF0', 'DistInSectF1', 'DistInSectF2', 'DistInSectF3', ...
    'DiamantF0', 'DiamantF1', 'DiamantF2', 'DiamantF3', ...
    'DiamantUnrF0', 'DiamantUnrF1', 'DiamantUnrF2', 'DiamantUnrF3'};

    mytable = cell2table(data, 'VariableNames', var_names);
    writetable(mytable,[folder, 'results.csv']);

    
% create histogram and display table data
if ~isempty(f1_x)
    coord = [f1_x, f1_y];
    n = create_hist (coord, nbins, 1, folder, closefig);
    disp('F1 histogram: ');
    disp(n);
end

if ~isempty(f2_x)
    coord = [f2_x, f2_y];
    n = create_hist (coord, nbins, 2, folder, closefig);
    disp('F2 histogram: ');
    disp(n);
end

if ~isempty(f3_x)
    coord = [f3_x, f3_y];
    n = create_hist (coord, nbins, 3, folder, closefig);
    disp('F3 histogram: ');
    disp(n);
end

if ~isempty(f4_x)
    coord = [f4_x, f4_y];
    n = create_hist (coord, nbins, 4, folder, closefig);
    disp('F4 histogram: ');
    disp(n);
end

% display analysis results
disp ('Status: "File OK" = file processed; "INC, processed" = file incomplete, but processed; "NOT processed" = file too short, not processed');
disp('Analysis done.');

end