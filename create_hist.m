function n = create_hist (data, nbins, phase, folder, closefig, frame)

if closefig
    fh = figure('visible','off');
else
    fh = figure('visible','on');
end

% create histogram
figure(fh)
hist3 (data, 'CdataMode','auto', 'Nbins', nbins);
xlabel('X')
ylabel('Y')
title(['Histogram F', num2str(phase-1),' ', frame])
colorbar
view(2)

% save histogram
if exist([folder, '\histogram\'],'dir') ~= 7 %check if file exists
    mkdir([folder, '\histogram']);
end
file_name = strcat(folder,'\histogram\','hist_f', num2str(phase-1),'_', frame, '.jpg');
saveas(gcf, file_name);
if closefig, close(fh); end

% generate histogram table and save to file
n = hist3(data, 'Nbins', nbins);

end