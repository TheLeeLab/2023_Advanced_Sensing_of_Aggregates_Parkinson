function [fov,inCell,outCell,percentage,inout,outPoints] = calculateDensity(cell_mask,oligPoints,imsz,pxsz,plotflag)
% calculate density based on the cell position and diffraction-limited objects position
% input  : cell_mask, binary mask of cell
%          oligPoints, centroids of oligomers, in (x,y) form and in pixel unit
%          imsz, image size in pixel
%          pxsz, physical pixel size in the object plane in um (e.g. 16um pixel size and 100x magnification, then pxsz is 0.16um)
%          plot, a flag for visualizing in/out oligomers and cells
% 
% output : fov, field-of-view density, irrespective of cell position
%          inCell, in-cell density
%          outCell, out-cell density
%          percentage, the percentage area occupied by the cell
%          outPoints, the centroids of oligomers which are outside the cell and in nm unit
%          inout, the extra column labelling whether each object is inside or outside
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    [~,numCell]     = bwlabel(cell_mask); %number of cells per fov
    oligPoints(:,2) = abs(oligPoints(:,2)-imsz(1)); %change to normal cartisian coordinate
    oligPoints      = oligPoints*pxsz; %change from pixel unit to um
    
    boundaries = bwboundaries(cell_mask, 'noholes');
    inout      = false(size(oligPoints,1),1); %repo for all points to indicate whether it is inside or outside the cell
    
    if plotflag == 1
        f = figure;
    end

    for k = 1:numCell %find whether points inside or outside through each cell
        cellb = boundaries{k};
        cellb(:,1) = abs(cellb(:,1)-imsz(1)); %[y,x]
        cellb = cellb*pxsz; %change from pixel unit to um
        s     = inpolygon(oligPoints(:,1),oligPoints(:,2),cellb(:,2),cellb(:,1)); %solve triangulation function to determine inside or outside
        inout = inout | s;

        if plotflag == 1
            plot(cellb(:,2),cellb(:,1),'r.');hold on;
        end
    end

    inPoints  = oligPoints(inout==1,:);
    outPoints = oligPoints(inout==0,:);

    if plotflag == 1
        plot(inPoints(:,1),inPoints(:,2),'.','Color','r');
        plot(outPoints(:,1),outPoints(:,2),'.','Color','b');
        xticks('');yticks(''); axis image;
        xlim([0 imsz(2)*pxsz]); ylim([0 imsz(1)*pxsz]);
    end

    fov = size(oligPoints,1) / ((pxsz*imsz(1)) * (pxsz*imsz(2))); %fov density
    if numCell ~= 0
        inCell = size(inPoints,1) / (sum(cell_mask,'all') * (pxsz^2));
    else
        inCell = 0;
    end
    outCell = size(outPoints,1) / ((imsz(1)*imsz(2)-sum(cell_mask,'all')) * (pxsz^2)); %outside cell density
    percentage = sum(cell_mask,'all')/(imsz(1)*imsz(2)); %how much area occupied by the cells
end