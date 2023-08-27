function [dlM,ndlM,result_oligomer,result_number] = aggregateDetection(img,c_lb,c_spot,thres_dl,gain,offset,saveFlag)
% detect agggregates （diffraction-limited and non-diffraction-limited） in a 3D matrix
% input  : img, 3D raw image
%          c_lb, the config for lb detection
%          c_spot, the config for oligomer detection
%          thres_dl, area threshold in pixel for determining whether the object is diffraction-limited
%          gain, gain map of the camera
%          offset, offset map of the camera
%          saved, whether save the result
%          
% output : dlM, binary mask for diffraction-limited aggregates
%          ndlM, binary mask for non-diffraction-limited aggregats
%          result_oligomer, result per oligomer
%          result_slice, result per slice
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    bits   = (c_lb.bit); %bit width for the image
    BW_mip = core.LBDetection2D(max(img,[],3),c_lb); %determine the large objects position in the FoV (through maximum intensity project)
    dlM  = false(size(img,1),size(img,1),size(img,3));
    ndlM = dlM;
    result_oligomer = []; %'Centroid','SumIntensity','bg','z'
    result_number   = []; %'dlobjnumber','ndlobjnumber'
    h = core.rickerWavelet(c_spot.k_log); %create a kernel for strengthen the blob feature within an image

    % detection for large objects
    img1 = imgaussfilt3(img,c_lb.k1_dog) - imgaussfilt3(img,c_lb.k2_dog);
    BW1  = core.threshold(img1,c_lb);

    for j = 1:size(img,3)
        zimg = img(:,:,j);
        
        % large objects filtering based on intensity
        t = regionprops('table',BW1(:,:,j),zimg,'PixelValues'); %area and intensity post-filtering
        if size(t,1)>2
            counts = cell2mat(cellfun(@(x) core.findPercentileMean(x,0.05),t.PixelValues,'UniformOutput',false)); 
            idx1   = find(counts<2^bits*c_lb.ratio); %at least 5% pixel values should be larger than 65535/2 (if 16bit image)
            BW1(:,:,j) = core.fillRegions(BW1(:,:,j),idx1);
        end
        BW1(:,:,j) = imfill(BW1(:,:,j),'holes');

        % large objects filtering based on position
        [~,BW1(:,:,j)] = core.coincidence(cat(3,BW_mip,BW1(:,:,j)),2); 

        % blob detection
        BW2 = core.spotDetection(zimg,h,c_spot); %detect small objects in the FoV

        BW  = BW1(:,:,j) | BW2; %combine small and large object mask together
        BW  = imclose(BW,strel('disk',2));
        t   = regionprops('table',BW,zimg,'Area');
        a   = t.Area;
        
        % create dl and bdl binary mask based on the area from each binary object
        if ~isempty(a)
            idx1 = find(a>=thres_dl); dlM(:,:,j) = core.fillRegions(BW,idx1); %fill any object larger than diffraction limit (DL) (i.e., keep all DL objects)
            idx2 = find(a<thres_dl); ndlM(:,:,j) = core.fillRegions(BW,idx2);
        else
            idx1 = [];
            idx2 = [];
        end
        
        if saveFlag == 1
            if ~isempty(gain) && ~isempty(offset)
                zimg = (zimg-offset).*gain*0.95; %convert count to number of photons. 0.95 is the quantum efficiency of the camera at 600nm
            end
            r_oligomer = core.findInfo(dlM(:,:,j),zimg,j);
            r_number   = [length(idx2),length(idx1),j];
            r_number   = array2table(r_number,'VariableNames', {'dlobjnumber','ndlobjnumber','z'});
            result_oligomer = [result_oligomer;r_oligomer];
            result_number   = [result_number;r_number];
        end
    end  
end