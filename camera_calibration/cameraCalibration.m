%% This is the main code for calculating the gain and offset map for a camera
% author: Bin Fu, University of Cambridge, bf341@cam.ac.uk
% Bsed on: 1. Video-rate nanoscopy using sCMOS cameraspecific single-molecule localization algorithms 
%          2. https://www.mirametrics.com/tech_note_ccdgain.php 

clc;clear;
[status,errmsg] = load.checkToolBox('statistics_toolbox');

%% load files and sort them based on the bright-field intensity
files     = dir('*.tif');
filenames = {files.name}';
prefix    = regexp(filenames,'\d*','Match');
prefix    = str2num(char([prefix{:}]));
[prefix,order] = sort(prefix);

%% calculate image offset based on dark frame (intensity = 0, no light)
darkimg = double(Tifread(filenames{order==1}));
offset  = mean(darkimg,3); %offset
var_offset = var(darkimg,0,3); %offset

%% calculate mean and variance
mean_sig = zeros([size(offset),length(order)-1]);
var_sig  = zeros([size(offset),length(order)-1]);

for i = 2:length(order)
    brightimg = double(Tifread(filenames{order(i)}));
    mean_sig(:,:,i-1) = mean(brightimg,3) - offset;
    var_sig(:,:,i-1)  = var(brightimg,0,3) - var_offset;
end

%% calculate the slope between mean and variance
gain = zeros(size(offset));
for i = 1:size(mean_sig,1)
    for j = 1:size(mean_sig,2)
        A = squeeze(var_sig(i,j,:))';
        B = squeeze(mean_sig(i,j,:))';
        gain(i,j) = pinv(A*(A'))*A*(B'); %unit: e-/count
    end
end

%% variance-mean plot for a single pixel
plot(squeeze(var_sig(150,150,:)),squeeze(mean_sig(150,150,:)),'b.','markersize',10);
set(gca,'fontsize',14);
xlabel('Variance(count^2)','fontsize',14);
ylabel('Mean(count)','fontsize',14);
title('Mean-Variance plot','fontsize',16);

%% histogram of gain map for all pixels
pd = fitdist(gain(:),'Normal');
lowlimit  = median(gain(:))*0.5;
highlimit = median(gain(:))*1.5;
x_pdf = lowlimit : (highlimit-lowlimit)/500 : highlimit;
y = pdf(pd,x_pdf);
 
f = figure;
histogram(gain,'Normalization','pdf','EdgeAlpha',0,'FaceAlpha',0.5);
title('Gain for all pixels');
set(gca,'fontsize',14);
ylabel('Normalized frequency','fontsize',14);
xlabel('gain(e^-/count)','fontsize',14);
xlim([lowlimit,highlimit]);
line(x_pdf,y,'linewidth',2)

%% save gain and offset map in .mat form, please copy them to the code->camera folder
save('gain.mat','gain');
save('offset.mat','offset');

%% function
function tiff_stack = Tifread(filename)
    tiff_info = imfinfo(filename);
    width     = tiff_info.Width;
    height    = tiff_info.Height;
    tiff_stack = uint16(zeros(height(1),width(1),length(tiff_info)));
    for i = 1:length(tiff_info)
        tiff_stack(:,:,i) = imread(filename, i);
    end
end