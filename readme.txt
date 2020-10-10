Run aapa_II_main.m, select folder with data to analyze.
--------------------------------
Input:
aaapa__II__main.m (folder, closefig, nbins)

- folder: after running, you are prompted to choose the folder containing the data you wish to analyze
- closefig: default set to 1, set to 0 if you wish to leave the figures opened after generating them
- nbins: list of 2 values, default set to [15 15], change this to change the number of bins used for histogram

--------------------------------

Output files:
- Figures:
	Figures are saved in the 'figures' folder of data source.
- Histograms:
	Histograms are saved in the 'histogram' folder of data source.
- CSV files:
	All the output data files are saved in the 'results' folder of data source.
	- results.csv: file with results of the analysis
	- entrances.csv: file with details on entrances for each subject. These are generated from data written in data files, not the entrances computed by the script.
			 There's a rows for each entrance with subj name, phase, entrance start and entrance duration.
	- diamand.csv: file with details on diamant collections for each subject. There's a row for each collection with subj name, phase and time of collection.
	- histogram_arena/_room.csv - histograms generated for the whole folder of input data as a group, for more info refer to matlab function hist3 (https://www.mathworks.com/help/stats/hist3.html)

--------------------------------

Output of the function:
Function returns 1 table and 4 cell arrays, please only refer the 4 cell array as the 1st output argument, the table, is only used to display results after running the function.
Output format: 
	- data_table - table only for printing the resultd after the function is ran, use data cell array for further data reference, this value is not intended for later use

	- data - 2 dimensional cell array, values (for every row): {filename, status, distance F0, distance F1, distance F2, distance F3, entrances F0, entrances F1, entrances F2, 
	  entrances F3, entrances unreal F0, entrances unreal F1, entrances unreal F3, entrances unreal file F0, entrances unreal file F1, entrances unreal file F2, 
	  entrances unreal file F3, 1st entrance F0, 1st entrance F1, 1st entrance F2, 1st entrance F3, time in sector F0, time in sector F1, time in sector F2, time in sector F3, 
	  time in sector unreal F0, time in sector unreal F1, time in sector unreal F2, time in sector unreal F3, distance in sector F0, distance in sector F1, distance in sector F2, 
	  distance in sector F3, diamond no F0, diamond no F1, diamond no F2, diamond no F3, diamond unreal no F0, diamond unreal no F1, diamond unreal no F2, diamond unreal no F3}

	- en_to_file - 2 dimensional cell array, values: {filename, phase, entrance time (withing the phase), entrance duration}

	- diam_to_file - 2 dimensional cell array, values: {filename, phase, collection time (withing the phase)}
	
	- histogram_room, histogram_arena - 2 dimensional cell array, values: {phase, values for each bins}
					  - first row is dedicated to phase, with each new histogram there's 1 row in the 1st collumn for the filename, you can later reference this by using the nbins value defined in the function input
