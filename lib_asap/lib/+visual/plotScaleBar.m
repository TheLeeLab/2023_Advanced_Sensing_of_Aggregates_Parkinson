function [] = plotScaleBar(f,imsz,pixelRes,scale)
% input  :  f, the figure where the scale bar should be
%           imsz, image size, [row,column]
%           pixelRes, pixel size in object space
%           scale, the real scale of the scale bar, !!! in the same scale with pixelRes

    figure(f);hold on;
    length_bar = round(scale/pixelRes);
    width_bar = round(length_bar/5);
    r_start = round(imsz(1)*13/14) - length_bar;
    c_start = round(imsz(2)*13/14) - width_bar;    
    rectangle('Position',[r_start,c_start,length_bar,width_bar],'FaceColor',[1 1 1]);
end