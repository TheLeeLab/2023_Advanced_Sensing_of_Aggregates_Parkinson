%% This is the main code for analyzing the cell and a-syn oligomers density relationship
% author: Bin Fu, University of Cambridge, bf341@cam.ac.uk

%% add library and check license
clc;clear;
[status,errmsg] = load.checkToolBox('image_toolbox');
libpath = uigetdir(pwd); %select the folder you put the code library, could type the specific path if the code library is always in the same path
addpath(genpath(libpath));

%% load filenames
T = readtable('metadata_example.xlsx');
names     = T.filename; 
width     = T.width;
height    = T.height;

numOfSlice    = 17; %number of images per tif stack
result_folder = uigetdir(pwd); %directory where you save the result

%% density calculation
saveFlag = 0; %1 means saving results, 0 means visualizING density plot

for i = 1:length(names)
    cellM = load.Tifread(fullfile(result_folder,[names{i},'_mask.tif'])); %cell binary mask
    dlObj = readmatrix(fullfile(result_folder,[names{i},'_dl.xlsx'])); %diffraction-limited a-syn aggregates, table property is: x,y,z,sumintensity,bg
    density = zeros(numOfSlice,4);%fov density, inside-cell density, outside-cell density, area occupied by cell (%) 

    for z = 1:numOfSlice %from first z-slice to last z-slice
        dlObj_z = dlObj(dlObj(:,3)==z,[1 2]); % diffraction-limited a-syn aggregates at certain z-slice
        [density(z,1),density(z,2),density(z,3),density(z,4)] = core.calculateDensity(cellM(:,:,z),dlObj_z,[height(i),width(i)],0.107,~saveFlag); %change To 1 if you want to visualize cell and oligomer position
    end
    
    if saveFlag == 1
        t = array2table(density,'VariableNames',{'FoVdensity','Indensity','Outdensity','Cellarea'});
        writetable(t,fullfile(result_folder,[names{i},'_density.xlsx'])); %save the density result in the same folder
    end
    i
end
