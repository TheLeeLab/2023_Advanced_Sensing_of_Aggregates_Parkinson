function BW = fillRegions(BW,idx)
% fill objects in the binark mask
% input  : BW, binary mask
%          idx, the object index in the mask which will be eliminated (filled)
%          
% output : BW, filled binary mask
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    regions = bwconncomp(BW,8).PixelIdxList;
    
    for k = 1:length(idx)
        BW(regions{idx(k)}) = 0;
    end
end