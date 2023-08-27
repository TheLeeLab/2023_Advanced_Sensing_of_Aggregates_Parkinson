function BW = LBDetection2D(img,c_lb)
% detect large objects in a FoV
% input  : img, 2D raw image
%          s, config
% 
% output : BW, binary mask of the image for the large object
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    img1 = imgaussfilt(img,c_lb.k1_dog) - imgaussfilt(img,c_lb.k2_dog);
    BW   = core.threshold(img1,c_lb);
    
    %intensity post-filtering
    t = regionprops('table',BW,img,'PixelValues'); 
    if size(t,1) > 1
        counts = cell2mat(cellfun(@(x) core.findPercentileMean(x,0.05),t.PixelValues,'UniformOutput',false));
        idx1 = find(counts<2^c_lb.bit*c_lb.ratio);
        BW   = core.fillRegions(BW,idx1);
    end
end