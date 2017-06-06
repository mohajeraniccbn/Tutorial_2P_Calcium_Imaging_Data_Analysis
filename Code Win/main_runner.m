%% Canadian Association for Neuroscience Meeting 2017, Montreal, Canada
% Satellite 5: Neural Signal and Image Processing: Quantitative Analysis of
% Neural Activity
% Date: May 27th - 8:30am to 6:00pm

% 11:15am to 12:15pm
% Quantitative tools to analyze two-photon calcium imaging data

% by Samsoon Inayat PhD
% Postdoctoral Fellow, 
% Labs of Drs. Majid Mohajerani and Bruce McNaughton,
% Department of Neuroscience,
% University of Lethbridge, Lethbridge, Alberta, Canada

% Email: samsoon.inayat@uleth.ca, mohajerani@uleth.ca
% samsoon.inayat@gmail.com

% Keyboard short cut to execute each section is Ctrl + Enter

clear all % clear all variables in main workspace
clc % clear console clears command window

%% Setting up folders 
% this section automatically adds the tutorial folders to Matlab path

this_folder = pwd; % get current folder path
slash_location = strfind(this_folder,'\'); % find all slash locations in the path, so that we can find the tutorial folder path
if isempty(slash_location) % to handle different style path specification 
    slash_location = strfind(this_folder,'/'); 
end
root_folder = this_folder(1:(slash_location(end)-1)); % root folder of tutorial
p = genpath(root_folder);  % generate paths so that all subfolders in root folder are added to path in the next line
addpath(p); % path of root folder and all subfolders added to Matlab Path
clear p slash_location;

main_data_folder = fullfile(root_folder,'Data'); % make variable to main_data_folder

% raw_data_folder = fullfile(main_data_folder,'Raw_And_Tif'); % raw data folder 
% tif_data_folder = fullfile(main_data_folder,'Raw_And_Tif'); % tif data folder for accessing tifs
processed_data_folder = fullfile(main_data_folder,'Processed'); % folder where processed data is stored
tools_folder = fullfile(root_folder,'Tools');
whos

%% Make folder name where tif files are stored in the data folder

% We are going to analyze data from mouse 162897 whose data was collected
% from awake animal on 2017 May 23. 

% Let us make a folder name where the tiff files of acquired data are
% present
recording_number = 4;
raw_tif_folder_name = sprintf('%s\\162897\\2017-05-23\\%d',main_data_folder,recording_number);
% explain the xml file from ThorLabs
% fileName = fullfile(raw_tif_folder_name,'Experiment.xml');
% winopen(fileName);
expInfo = thorGetExperimentInfo(raw_tif_folder_name);

processed_tif_folder_name = sprintf('%s\\162897\\2017-05-23\\%d',processed_data_folder,recording_number);
if ~exist('processed_tif_folder_name','dir')
    mkdir(processed_tif_folder_name);
end

%% Open the folder window in file explorer where tif files are stored
winopen(raw_tif_folder_name)
% if you have a mac try uncommenting the following line and open the folder
% macopen(tif_folder_name);

%% Visualization of data
% With Matlab
all_tif_file_names = get_tif_file_names(raw_tif_folder_name,'ChanA_0');
exploreTifs(all_tif_file_names,raw_tif_folder_name);
% load data
tic
frames = load_tif_files(all_tif_file_names(1:1000));
toc

%% Find average Image or max image etc.,
% all_tif_file_names = get_tif_file_names(raw_tif_folder_name,'ChanA_0');
% if ~exist('average_image','var')
%     [average_image max_image] = find_average_image(all_tif_file_names);
% end
average_image = mean(frames,3);
max_image = max(frames,[],3);
imwrite(uint16(average_image),fullfile(processed_tif_folder_name,'average_image.tif'));
imwrite(uint16(max_image),fullfile(processed_tif_folder_name,'max_image.tif'));
figure(1);clf;
subplot 131; imagesc(average_image);colormap gray;axis equal
subplot 132; imagesc(max_image);colormap gray;axis equal
subplot 133;imagesc(max_image-average_image);colormap gray;axis equal

%% Image Registration
% all_tif_file_names = get_tif_file_names(raw_tif_folder_name,'ChanA_0');
% register_images(all_tif_file_names,average_image,reg_processed_tif_folder_name);
tic
reg_frames = register_images(frames,average_image,processed_tif_folder_name);
toc

winopen(processed_tif_folder_name);
%% View registered tifs
fileName = fullfile(processed_tif_folder_name,'dft_registered_images.tif');
exploreTifs(fileName,processed_tif_folder_name,1000);

% for image set in folder 4 look for motion corrected frames 75,76 and
% 371,372 in both raw and registered sequences
%% find registerd images average and max
reg_average_image = mean(reg_frames,3);
reg_max_image = max(reg_frames,[],3);

imwrite(uint16(reg_average_image),fullfile(processed_tif_folder_name,'reg_average_image.tif'));
imwrite(uint16(reg_max_image),fullfile(processed_tif_folder_name,'reg_max_image.tif'));
figure(1);clf;
subplot 131;imagesc(reg_average_image);colormap gray;axis equal; title('Average Image');
subplot 132;imagesc(reg_max_image);colormap gray;axis equal ; title('Max Image');
subplot 133;imagesc(reg_max_image-reg_average_image);colormap gray;axis equal ;title('Max - Average Image');

%% ROI Manager
% you can also use ImageJ do draw ROIs and extract cellular signal
ROImanager
% for drawing rois by hand 
% after drawing rois cell signal is extracted by averaging over pixels
% DF/Fo for spontaneous activity can be then calculated as 
% Fo = mean(Cell_Signal) i.e. Cell_Signal = average over pixels in each
% frames
% DF/Fo = (Cell_Signal - Fo)/Fo;
% For evoked activity, Fo can be signal while no stimulus is present

%% Writing all registered images into one tif file to make Multi Tif File
% you can modify the following code to store multiple tif files into one
% file

% reg_processed_tif_folder_name = sprintf('%s\\dft_reg',processed_tif_folder_name);
% all_tif_file_names = get_tif_file_names(reg_processed_tif_folder_name,'');
% fileName = fullfile(processed_tif_folder_name,'reg_multi_tif.tif');
% h = waitbar(1/expInfo.timePoints,'Processing image frames');
% for ii = 1:expInfo.timePoints
%     waitbar(ii/expInfo.timePoints,h,sprintf('Processing image frames %d/%d',ii,expInfo.timePoints));
%     img = imread(all_tif_file_names{ii});
%     if ii == 1
%         imwrite(img,fileName);
%     else
%         imwrite(img,fileName,'Write','append');
%     end
% end
% close(h);

%% Cell signal extraction
% Switch to CellsortTest file
fileName = fullfile(processed_tif_folder_name,'dft_registered_images.tif');
edit('CellsortTest.m');
%% Suite 2P Execution

% Making mouse and experiment list
make_db_Suite2P % Open file name to see what is in there
db % db variable (Suite2P style) has list of animals and data to be processed

tic
master_file_Suite2P % This is the master file for running analysis on 2P data using Suite 2P
toc
%% Visualize Suite2P Data with GUI
% after opening the GUI with the following command load the data from mat file
% name starting with prefix F_
visualizing_Suite2P_gui

%% Visualize Suite2P registered images
reg_processed_tif_folder_name_suite2P = sprintf('%s\\Plane1',processed_tif_folder_name);
all_tif_file_names = get_tif_file_names(reg_processed_tif_folder_name_suite2P,'');
exploreTifs(all_tif_file_names{1},reg_processed_tif_folder_name_suite2P,expInfo.timePoints);

%% Look at Calcium traces
ofn = sprintf('F_%s_%s_plane1.mat',db.mouse_name,db.date);
file_name = fullfile(processed_tif_folder_name,ofn);
results_S2P = load(file_name);
cell_num = 6;
ca_trace = results_S2P.Fcell{1}(cell_num,:);
figure(100);clf;plot(ca_trace);
