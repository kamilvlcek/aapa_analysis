function data = aapa_II_main(folder)

if ~exist('folder','var') %pokud uz nemam folder - Kamil
% get folder name with input data files
    folder_input = uigetdir;
    folder = strcat(folder_input, '\');
end

% list _T.log files from input directory
files = dir(fullfile(folder, '*_T.log'));

% create out cell array 1st row
data = {'filename ', 'distance f0 ', 'f1 ', 'f2 ', 'f3 ', 'entrances f0 ', 'f1 ', 'f2 ', 'f3 ', ...
    'entrances unr f0 ', 'f1 ', 'f2 ', 'f3 ', '1st ent[s] f0', 'f1 ', 'f2 ', 'f3 ', ...
    'time in sector[s] f0 ', 'f1 ', 'f2 ', 'f3 ', 'dist in sector f0', 'f1 ', 'f2 ', 'f3 ',...
    'diamond ent f0 ', 'f1 ', 'f2 ', 'f3'};


% process data files
for i = 1:length(files)
    fprintf('%s ... ', files(i).name); %pro vice souboru je trosku videt, v jake fazi zpracovani to je - Kamil
    file_name = strcat(folder, files(i).name);
    analysis_output = analysis_II(file_name);
    
    %save output to cell array
    for j = 1:28
        data{i+1,1} = erase(files(i).name, '_T.log');
        data{i+1,j+1} = analysis_output(j);
    end
    fprintf(' ... OK \n'); 
end

disp('Analysis done, errors:');
data = data'; %ve sloupcich je to trosku prehlednejsi - Kamil

end