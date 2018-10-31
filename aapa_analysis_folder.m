function data = aapa_analysis_folder(folder)
%clear all - to je zbytecne, + nechci mazat folder - Kamil

if ~exist('folder','var') %pokud uz nemam folder - Kamil
    % get folder name with input data files
    folder_input = uigetdir;
    folder = strcat(folder_input, '\');
end

% list .tr files from input directory
files = dir(fullfile(folder, '*.tr'));

% create out cell array 1st row
data = {'filename ', 'distance f1 ', 'f2 ', 'f3 ', 'entrances f1 ', 'f2 ', 'f3 ', '1st ent[s] f1',...
    'f2 ', 'f3 ', 'time in sector[s] f1 ', 'f2 ', 'f3 ', 'dist in sector f1', 'f2 ', 'f3 ',...
    'diamond ent f1 ', 'f2 ', 'f3'};

% process data files
for i = 1:length(files)
    fprintf('%s ... ', files(i).name); %pro vice souboru je trosku videt, v jake fazi zpracovani to je - Kamil
    file_name = strcat(folder, files(i).name);
    analysis_output = analysis(file_name);
    
    %save output to cell array
    for j = 1:18
        data{i+1,1} = files(i).name;
        data{i+1,j+1} = analysis_output(j);
    end
    fprintf(' ... OK \n');
end

disp('analysis done');
data = data'; %ve sloupcich je to trosku prehlednejsi - Kamil
end