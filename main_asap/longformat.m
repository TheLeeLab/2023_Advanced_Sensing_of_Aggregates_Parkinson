%% This is the code for concatenate results into one single table
% author: Bin Fu, University of Cambridge, bf341@cam.ac.uk

%% load filenames and result folder
clc;clear;
T = readtable('metadata_example.xlsx');
names     = T.filename; 
fullnames = fullfile(T.filepath,strcat(names,T.extension));
id        = T.id;

result_folder = uigetdir(pwd); %directory where you save the result

%% concatenate results
number_long  = [];
info_long    = [];
density_long = [];

for i = 1:length(fullnames)
    number  = readtable(fullfile(result_folder,[names{i},'_number.xlsx'])); %number of a-syn aggregates, table property is: diffraction-limited object number, non-diffraction-limit object number,z
    dlObj   = readtable(fullfile(result_folder,[names{i},'_dl.xlsx'])); %diffraction-limited a-syn aggregates, table property is: x,y,z,sumintensity,bg
    % density = readtable(fullfile(result_folder,[names{i},'_density.xlsx'])); density of diffraction-limited a-syn aggregates, table property is: fov density, inside-cell density, outside-cell density, area occupied by cell (%)
    
    number.id = repmat(id(i),size(number,1),1); %append id as an extra column
    dlObj.id  = repmat(id(i),size(dlObj,1),1);
    % density.id = repmat(id(i),size(density,1),1);

    number_long = [number_long;number];
    info_long = [info_long;dlObj];
    % density_long = [density_long;density];
    i
end

%% save result
writetable(number_long,'result_number.xlsx');
writetable(info_long,'result_oligomer.xlsx');
% writetable(density_long,'result_density.xlsx');
