function data = aapa_analysis_folder()
clear all

% get folder name with input data files
folder_input = uigetdir;
folder = strcat(folder_input, '\');

% list .tr files from input directory
files = dir(fullfile(folder, '*.tr'));

% create out cell array 1st row
data = {'filename ', 'distance f1 ', 'f2 ', 'f3 ', 'entrances f1 ', 'f2 ', 'f3 ', '1st ent[s] f1',...
    'f2 ', 'f3 ', 'time in sector[s] f1 ', 'f2 ', 'f3 ', 'dist in sector f1', 'f2 ', 'f3 ',...
    'diamond ent f1 ', 'f2 ', 'f3'};

% process data files
for i = 1:length(files)
    file_name = strcat(folder, files(i).name);
    analysis_output = analysis(file_name);
    
    %save output to cell array
    for j = 1:18
        data{i+1,1} = files(i).name;
        data{i+1,j+1} = analysis_output(j);
    end
    
end

disp('analysis done');

end