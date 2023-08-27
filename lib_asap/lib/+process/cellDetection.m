function BW = cellDetection(img,c_cell)
% detect cells in a 3D matrix
% input  : img, 3D raw image
%          c_cell, config for cell detection
% 
% output : BW, binary mask of the image for oligomers
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    img1 = imgaussfilt(img,c_cell.k1_dog) - imgaussfilt(img,c_cell.k2_dog);
    BW   = core.threshold(img1,c_cell);

    for j = 1:size(BW,3)
        if c_cell.disk ~= 0
            BW(:,:,j) = imopen(BW(:,:,j),strel('disk',c_cell.disk(1))); %erase small binary objects
            BW(:,:,j) = imclose(BW(:,:,j),strel('disk',c_cell.disk(2))); %connect seperate binary objects
        end
        c_cell.intens  = c_cell.intens_ratio*mean2(img(:,:,j));
        BW(:,:,j) = core.BWFilter(BW(:,:,j),img(:,:,j),c_cell); %area and intensity post-filtering
    end
end