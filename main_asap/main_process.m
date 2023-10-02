%% This is the main code for cell and a-syn aggregate detection
% author: Bin Fu, University of Cambridge, bf341@cam.ac.uk

%% add library and check license
clc;clear;
libpath = uigetdir(pwd); %select the folder you put the code library, could type the specific path if the code library is always in the same path
addpath(genpath(libpath));
[status,errmsg] = load.checkToolBox('image_toolbox');

%% load filenames
T = readtable('metadata_example.xlsx');
names     = T.filename; 
fullnames = fullfile(T.filepath,strcat(names,T.extension));

%% config and camera gain and offset map loading
c_lb   = load.loadJSON('config_lb.json'); %config for lewy body(large & bright object) segmentation
c_spot = load.loadJSON('config_oligomer.json'); %config for oligomer(small & spot-like object) segmentation
c_cell = load.loadJSON('config_microglia.json'); %config for cell segmentation
[gain,offset] = load.loadMap(libpath);

%% batch processing for cell images
saveFlag = 1; %1 means saving the data, any other input means visualizing the result

for i = 1:length(names) %process for all the images within the data folder
    img   = load.Tifread(fullnames{i}); %read image as a 3D-tiff stack
    img   = double(img(:,:,1:17)); %first half is the images for cell
    cellM = process.cellDetection(img,c_cell); %result cell binary mask

    if saveFlag == 1 %save data
        newFolder = load.makeDir('.\data_result'); %save the result in the current path
        load.Tifwrite(cellM,fullfile(newFolder,[names{i},'_mask.tif']),1); %save binary mask as a 2-bit tif
    else %visualize segmenation result
        for j = 1:size(cellM,3)
            f = figure;imshow(imadjust(uint16(img(:,:,j))));
            visual.plotBinaryMask(f,cellM(:,:,j)); visual.plotScaleBar(f,[size(img(:,:,j))],0.107,5)
        end
    end
    i
end

%% batch processing for a-syn aggregate images
saveFlag = 0;

for i = 1:length(names) %process for all the images within the data folder
    img = load.Tifread(fullnames{i}); %read image as a 3D-tiff stack
    img = double(img(:,:,18:end)); %second half is the images for a-syn aggregate
    [dlM,ndlM,result_oligomer,result_number] = process.aggregateDetection(img,c_lb,c_spot,19,gain,offset,saveFlag); %result diffraction-limited (dl) aggregate and non-diffraction-limited (ndl) aggregagate binary mask

    if saveFlag == 1 %save data
        newFolder  = load.makeDir('.\data_result'); %save the result in the current path
        boundaries = array2table(load.BW2boundary(ndlM),'VariableNames',{'row','col','z'});
        writetable(result_number,fullfile(newFolder,[names{i},'_number.xlsx'])); %save the numbers for dl aggregates and ndl aggregates
        writetable(result_oligomer,fullfile(newFolder,[names{i},'_dl.xlsx'])) %save the property (position, intensity, background) for dl aggregates
        writetable(boundaries,fullfile(newFolder,[names{i},'_ndl.xlsx'])); %save the property (boundary position) for ndl aggregates
    else %visualize segmenation result
        for j = 1:size(dlM,3)
            f = figure;imshow(imadjust(uint16(img(:,:,j))));
            visual.plotBinaryMask(f,dlM(:,:,j)); visual.plotBinaryMask(f,ndlM(:,:,j),[1 0 0]); visual.plotScaleBar(f,[size(img(:,:,j))],0.107,5)
        end
    end
    i
end
