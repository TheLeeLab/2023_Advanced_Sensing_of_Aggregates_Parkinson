%% This is the main code for creating the metadata file for the following processing and analysis work
% author: Bin Fu, University of Cambridge, bf341@cam.ac.uk

%% add library and check license
clc;clear;
libpath = uigetdir(pwd); %select the folder you put the code library, could type the specific path if the code library is always in the same path
addpath(genpath(libpath));
[status,errmsg] = load.checkToolBox('image_toolbox');

%% scan files in the data folder and save their path and name 
datapath = uigetdir(pwd); %select the folder you put the data
datapath = fullfile(datapath,'**','*.tif'); %find all tif images in the specified folder

folders  = {dir(datapath).folder}';
filnames = fullfile(folders,{dir(datapath).name}');
[~,names,ext] = fileparts({dir(datapath).name}');
width  = cell(length(folders),1); %number of columns per image
height = cell(length(folders),1); %number of rows per image
id     = num2cell((1:length(folders))'); %unique id per tif stack

for i = 1:length(folders)
    tiff_info = imfinfo(filnames{i});
    width{i}  = tiff_info.Width;
    height{i} = tiff_info.Height;
end

T = cell2table([folders,names,ext,width,height,id],'VariableNames',{'filepath','filename','extension','width','height','id'});
writetable(T,'metadata_example.xlsx');
