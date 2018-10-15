clear all

% get folder name with input data files
folder_input = uigetdir;
folder = strcat(folder_input, '\');

% list .tr files from input directory
files = dir(fullfile(folder, '*.tr'));

% process data files
for i = 1:length(files)
    file_name = strcat(folder, files(i).name);
    analysis(file_name);
end

disp('Analysis done.');