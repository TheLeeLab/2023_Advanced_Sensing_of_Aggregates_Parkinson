function BW = BWFilter(BW,img,c)
% area and intensity post-filtering
% input  : BW, binary mask
%          img, the processed image
%          c, config
% 
% output : BW, filtered binary mask
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    ss     = regionprops('table',BW,img,'Area','MeanIntensity');
    area   = ss.Area;
    intens = ss.MeanIntensity;
    switch length(c.area)
        case 1 %area and intensity post-filtering
            idx = union(find(area<c.area),find(intens<c.intens));
        case 2 %area and intensity post-filtering
            idx = union(find(area<c.area(1) | area>c.area(2)),find(intens<c.intens));
        otherwise
            error('area size not supported');
    end
    BW = core.fillRegions(BW,idx);
end