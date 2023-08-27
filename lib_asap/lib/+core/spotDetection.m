function BW = spotDetection(img,h,c_spot)
% detect small objects but will have artefacts around large objects
% input  : img, 2D raw image
%          c_spot, config for spot detection
% 
% output : BW, binary mask of the image for oligomers
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    img1  = img - imgaussfilt(img,c_spot.k2_dog);
    img1  = max(img1,0);
    img1  = imfilter(img1,h,'replicate','conv','same');
    BW    = core.threshold(img1,c_spot);
    BW    = imopen(BW,strel('disk',c_spot.disk)); %structure post-filtering
end