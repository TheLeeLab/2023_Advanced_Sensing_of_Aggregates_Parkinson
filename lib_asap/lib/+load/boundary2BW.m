function BW = boundary2BW(mat,imsz)
% input  : mat, the boundary of the cell/large aggregates
%          imsz, size of image in pixel
% 
% output : BW, the converted binary mask
%
% author ： Bin Fu, University of Cambridge, bf341@cam.ac.uk
    BW = false(imsz);
    if mat(1,1)~=0            
        tmpt = sub2ind(size(BW),mat(:,1)',mat(:,2)');
        BW(tmpt) = 1;
        BW = imfill(BW,'holes');
    end
end