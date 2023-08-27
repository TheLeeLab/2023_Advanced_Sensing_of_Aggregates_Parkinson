function [gain,offset] = loadMap(libpath)
% load gain and offset map from the folder
    libpath  = fullfile(libpath,'camera','*.mat');
    numFiles = dir(libpath); 
    if isempty(numFiles)
        gain   = [];
        offset = [];
    else
        gain   = load('gain.mat').gain;
        offset = load('offset.mat').offset;
    end
end