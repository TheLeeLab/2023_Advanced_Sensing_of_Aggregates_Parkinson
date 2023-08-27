function [sigImage,bgImage] = extractBg(BW,img)
% calculate the pure background image from the original image
% input  : BW, binary mask
%          img, processed image
% 
% output : sigImage, the pure signal image
%          bgImage, the estimated background image, not a single value
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    bgImage   = (1-BW).*double(img); %img - signal image = pure background 
    bgImage   = imfill(bgImage,"holes"); %use flood fill algorithm to estimate the background intensity within the signal region
    sigImage  = max(img-bgImage,0); %pure signal intensity of the detected points.
end